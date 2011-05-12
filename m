Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab1ELRLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:11:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab1ELRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=knACInmUAw/oxM1jeHlq93/OAChAbjzqb/shjgHaQhKFREvikEoblLca3SMJlY1t/I
         PsfbNPeTvLO2Ph64y3g8XrH2OEpMguKInzzilnKVf02gRenBFDCxfMxouP15vtHbbhab
         c4fJ4ZjteL6M4Qy3GEOvok7OusYCafEvcTvjk=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: pm loss development
Date: Thu, 12 May 2011 19:11:01 +0200
Message-Id: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What happen normally in runtime pm implementation is that every devices
are switched off and are enabled only when needed.
In our case instead we have a completely functional embedded system and,
when an asyncrhonous event appear, we have only some tens milliseconds
before the actual power failure takes place.
This patchset add a support in order to switch off not vital part of the system,
in order to allow the board to survive longer.
This allow the possibility to save important data.

The implementation has been written by Davide Ciminaghi.
My work instead was about analyzing different previuos implementation,
a first completely custom one, a second using runtime pm, arriving
finally to that one.

I have tested PM loss in our DaVinci dm365 basi board and I write here below a
piece of code showing a possible usage.

-------------------

static int powerfail_status;

static irqreturn_t basi_powerfail_stop(int irq, void *dev_id);

static irqreturn_t basi_powerfail_quick_check_start(int irq, void *dev_id)
{
        basi_mask_irq_gpio0(IRQ_DM365_GPIO0_2);
        basi_unmask_irq_gpio0(IRQ_DM365_GPIO0_0);

        /* PowerFail situation - START: power is going away */
        return IRQ_WAKE_THREAD;
}

static irqreturn_t basi_powerfail_start(int irq, void *dev_id)
{
        if (powerfail_status)
                return IRQ_HANDLED;
        powerfail_status = 1;
        pm_loss_power_changed(SYS_PWR_FAILING);
        return IRQ_HANDLED;
}


static irqreturn_t basi_powerfail_quick_check_stop(int irq, void *dev_id)
{
        basi_mask_irq_gpio0(IRQ_DM365_GPIO0_0);
        basi_unmask_irq_gpio0(IRQ_DM365_GPIO0_2);

        /* PowerFail situation - STOP: power is coming back */
        return IRQ_WAKE_THREAD;
}

static irqreturn_t basi_powerfail_stop(int irq, void *dev_id)
{
        if (!powerfail_status)
                return IRQ_HANDLED;
        powerfail_status = 0;
        pm_loss_power_changed(SYS_PWR_GOOD);
        return IRQ_HANDLED;
}

enum basi_pwrfail_prio {
        BASI_PWR_FAIL_PRIO_0,
        BASI_PWR_FAIL_MIN_PRIO = BASI_PWR_FAIL_PRIO_0,
        BASI_PWR_FAIL_PRIO_1,
        BASI_PWR_FAIL_PRIO_2,
        BASI_PWR_FAIL_PRIO_3,
        BASI_PWR_FAIL_MAX_PRIO = BASI_PWR_FAIL_PRIO_3,
};

struct pm_loss_default_policy_item basi_pm_loss_policy_items[] = {
        {
                .bus_name = "mmc",
                .bus_priority = BASI_PWR_FAIL_PRIO_1,
        },
        {
                .bus_name = "platform",
                .bus_priority = BASI_PWR_FAIL_PRIO_2,
        },
};

#define BASI_POLICY_NAME "basi-default"

struct pm_loss_default_policy_table basi_pm_loss_policy_table = {
        .name = BASI_POLICY_NAME,
        .items = basi_pm_loss_policy_items,
        .nitems = ARRAY_SIZE(basi_pm_loss_policy_items),
};

static void basi_powerfail_configure(void)
{
        int stat;
        struct pm_loss_policy *p;
        stat = request_threaded_irq(IRQ_DM365_GPIO0_2,
                                    basi_powerfail_quick_check_start,
                                    basi_powerfail_start,
                                    0,
                                    "pwrfail-on", NULL);
        if (stat < 0)
                printk(KERN_ERR "request_threaded_irq for IRQ%d (pwrfail-on) "
                       "failed\n", IRQ_DM365_GPIO0_2);
        stat = request_threaded_irq(IRQ_DM365_GPIO0_0,
                                    basi_powerfail_quick_check_stop,
                                    basi_powerfail_stop, 0,
                                    "pwrfail-off", NULL);
        if (stat < 0)
                printk(KERN_ERR "request_threaded_irq for IRQ%d (pwrfail-off) "
                       "failed\n", IRQ_DM365_GPIO0_0);
        basi_mask_irq_gpio0(IRQ_DM365_GPIO0_0);
        p = pm_loss_setup_default_policy(&basi_pm_loss_policy_table);

        if (!p)
                printk(KERN_ERR "Could not register pwr change policy\n");

        if (pm_loss_set_policy(BASI_POLICY_NAME) < 0)
                printk(KERN_ERR "Could not set %s power loss policy\n",
                       BASI_POLICY_NAME);
}

int platform_pm_loss_power_changed(struct device *dev,
                                   enum sys_power_state s)
{
        int ret = 0;

        /* Calling platform bus pm_loss functions */
        pr_debug_pm_loss("platform_pm_loss_power_changed(%d)\n", s);

        if (dev->driver && dev->driver->pm &&
                dev->driver->pm->power_changed)
                ret = dev->driver->pm->power_changed(dev, s);
        return ret;
}




