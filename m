Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab1ENUai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:30:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44607 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1ENUad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w2HyX7pt6tgbVzfeKoA1ZLAgFYRccjcrhmS9297Ug7AUQVYuVsKXYZllfv29wQC3Na
         FhJiGeAlDfLIu2IDnGfaJCP6BSrM+483jaJW6Y/B5SeFqSuLZCfYBwlZj3ceJMrhPTOC
         x1OCK1vsglUMwnzZZZNM0RrRyRM/dENv6B8M4=
MIME-Version: 1.0
In-Reply-To: <20110514162423.GA8292@gvim.org>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
	<20110514162423.GA8292@gvim.org>
Date: Sat, 14 May 2011 22:30:31 +0200
Message-ID: <BANLkTikaH24rnMxKUOJq8TtgXvzoD3=zYQ@mail.gmail.com>
Subject: Re: [linux-pm] pm loss development
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: markgross@thegnar.org
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 6:24 PM, mark gross <markgross@thegnar.org> wrote:
> On Thu, May 12, 2011 at 07:11:01PM +0200, Raffaele Recalcati wrote:
>> What happen normally in runtime pm implementation is that every devices
>> are switched off and are enabled only when needed.
>> In our case instead we have a completely functional embedded system and,
>> when an asyncrhonous event appear, we have only some tens milliseconds
>> before the actual power failure takes place.
>
> Very interesting!  I've been worried about a similar failure on battery
> driven devices that can experience significant voltage droops when
> battery gets old, or low, and we turn on the flashlight led, vibrator
> and make the screen bright while a high volume ring tone gets played.
>
> I think 10ms is a bit unrealistic.  I think its more like 300uSec before
> you hit brown out.

In our circuit it is the real timing, but I can understand your situation.
Are you sure about 300usec?

>> This patchset add a support in order to switch off not vital part of the system,
>> in order to allow the board to survive longer.
>> This allow the possibility to save important data.
>>
>> The implementation has been written by Davide Ciminaghi.
>> My work instead was about analyzing different previuos implementation,
>> a first completely custom one, a second using runtime pm, arriving
>> finally to that one.
>>
>> I have tested PM loss in our DaVinci dm365 basi board and I write here below a
>> piece of code showing a possible usage.
>>
>> -------------------
>>
>> static int powerfail_status;
>>
>> static irqreturn_t basi_powerfail_stop(int irq, void *dev_id);
>>
>> static irqreturn_t basi_powerfail_quick_check_start(int irq, void *dev_id)
>> {
>>         basi_mask_irq_gpio0(IRQ_DM365_GPIO0_2);
>>         basi_unmask_irq_gpio0(IRQ_DM365_GPIO0_0);
>>
>>         /* PowerFail situation - START: power is going away */
>>         return IRQ_WAKE_THREAD;
>> }
>>
>> static irqreturn_t basi_powerfail_start(int irq, void *dev_id)
>> {
>>         if (powerfail_status)
>>                 return IRQ_HANDLED;
>>         powerfail_status = 1;
>>         pm_loss_power_changed(SYS_PWR_FAILING);
>>         return IRQ_HANDLED;
>> }
>>
>>
>> static irqreturn_t basi_powerfail_quick_check_stop(int irq, void *dev_id)
>> {
>>         basi_mask_irq_gpio0(IRQ_DM365_GPIO0_0);
>>         basi_unmask_irq_gpio0(IRQ_DM365_GPIO0_2);
>>
>>         /* PowerFail situation - STOP: power is coming back */
>>         return IRQ_WAKE_THREAD;
>> }
>>
>> static irqreturn_t basi_powerfail_stop(int irq, void *dev_id)
>> {
>>         if (!powerfail_status)
>>                 return IRQ_HANDLED;
>>         powerfail_status = 0;
>>         pm_loss_power_changed(SYS_PWR_GOOD);
>>         return IRQ_HANDLED;
>> }
>>
>> enum basi_pwrfail_prio {
>>         BASI_PWR_FAIL_PRIO_0,
>>         BASI_PWR_FAIL_MIN_PRIO = BASI_PWR_FAIL_PRIO_0,
>>         BASI_PWR_FAIL_PRIO_1,
>>         BASI_PWR_FAIL_PRIO_2,
>>         BASI_PWR_FAIL_PRIO_3,
>>         BASI_PWR_FAIL_MAX_PRIO = BASI_PWR_FAIL_PRIO_3,
>> };
>>
>> struct pm_loss_default_policy_item basi_pm_loss_policy_items[] = {
>>         {
>>                 .bus_name = "mmc",
>>                 .bus_priority = BASI_PWR_FAIL_PRIO_1,
>>         },
>>         {
>>                 .bus_name = "platform",
>>                 .bus_priority = BASI_PWR_FAIL_PRIO_2,
>>         },
>> };
>>
>> #define BASI_POLICY_NAME "basi-default"
>>
>> struct pm_loss_default_policy_table basi_pm_loss_policy_table = {
>>         .name = BASI_POLICY_NAME,
>>         .items = basi_pm_loss_policy_items,
>>         .nitems = ARRAY_SIZE(basi_pm_loss_policy_items),
>> };
>>
>> static void basi_powerfail_configure(void)
>> {
>>         int stat;
>>         struct pm_loss_policy *p;
>>         stat = request_threaded_irq(IRQ_DM365_GPIO0_2,
> Is this some comparator device that tugs on this gpio when the voltage
> drops or goes to 0?  Is threaded irq fast enough?

yes, there is a comparator.
I need more data about timing, I'll try to add this info in some days.

> Could we consider something that includes a hot path ISR based
> notification call back to do stuff like blink off devices that don't
> need to save state;  backlights, vibrators, flashlight LEDs, audio
> output drivers <-- I'm not sure about audio HW, and then a slower path
> for other things that can be put into lower power states?
>
> the all-clear notification that power is good again should be on a
> slower path I would assume.

First I get data, afterwards we can see if your need can be seen as an
extension or something else.

>
> --mark
>
>>                                     basi_powerfail_quick_check_start,
>>                                     basi_powerfail_start,
>>                                     0,
>>                                     "pwrfail-on", NULL);
>>         if (stat < 0)
>>                 printk(KERN_ERR "request_threaded_irq for IRQ%d (pwrfail-on) "
>>                        "failed\n", IRQ_DM365_GPIO0_2);
>>         stat = request_threaded_irq(IRQ_DM365_GPIO0_0,
>>                                     basi_powerfail_quick_check_stop,
>>                                     basi_powerfail_stop, 0,
>>                                     "pwrfail-off", NULL);
>>         if (stat < 0)
>>                 printk(KERN_ERR "request_threaded_irq for IRQ%d (pwrfail-off) "
>>                        "failed\n", IRQ_DM365_GPIO0_0);
>>         basi_mask_irq_gpio0(IRQ_DM365_GPIO0_0);
>>         p = pm_loss_setup_default_policy(&basi_pm_loss_policy_table);
>>
>>         if (!p)
>>                 printk(KERN_ERR "Could not register pwr change policy\n");
>>
>>         if (pm_loss_set_policy(BASI_POLICY_NAME) < 0)
>>                 printk(KERN_ERR "Could not set %s power loss policy\n",
>>                        BASI_POLICY_NAME);
>> }
>>
>> int platform_pm_loss_power_changed(struct device *dev,
>>                                    enum sys_power_state s)
>> {
>>         int ret = 0;
>>
>>         /* Calling platform bus pm_loss functions */
>>         pr_debug_pm_loss("platform_pm_loss_power_changed(%d)\n", s);
>>
>>         if (dev->driver && dev->driver->pm &&
>>                 dev->driver->pm->power_changed)
>>                 ret = dev->driver->pm->power_changed(dev, s);
>>         return ret;
>> }
>>
>>
>>
>>
>> _______________________________________________
>> linux-pm mailing list
>> linux-pm@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
>

Bye,
Raffaele
