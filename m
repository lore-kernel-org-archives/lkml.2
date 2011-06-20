Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1FTXFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:05:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab1FTXE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:04:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support for generic domains (v3)
Date: Tue, 21 Jun 2011 01:05:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201106112223.04972.rjw@sisk.pl> <201106112239.16285.rjw@sisk.pl> <201106200006.07642.rjw@sisk.pl>
In-Reply-To: <201106200006.07642.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106210105.41740.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 20, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make generic PM domains support system-wide power transitions
> (system suspend and hibernation).  Add suspend, resume, freeze, thaw,
> poweroff and restore callbacks to be associated with struct
> generic_pm_domain objects and make pm_genpd_init() use them as
> appropriate.
> 
> The new callbacks do nothing for devices belonging to power domains
> that were powered down at run time (before the transition).  For the
> other devices the action carried out depends on the type of the
> transition.  During system suspend the power domain .suspend()
> callback executes pm_generic_suspend() for the device, while the
> PM domain .suspend_noirq() callback runs pm_generic_suspend_noirq()
> for it, stops it and eventually removes power from the PM domain it
> belongs to (after all devices in the domain have been stopped and its
> subdomains have been powered off).
> 
> During system resume the PM domain .resume_noirq() callback
> restores power to the PM domain (when executed for it first time),
> starts the device and executes pm_generic_resume_noirq() for it,
> while the .resume() callback executes pm_generic_resume() for the
> device.  Finally, the .complete() callback executes pm_runtime_idle()
> for the device which should put it back into the suspended state if
> its runtime PM usage count is equal to zero at that time.
> 
> The actions carried out during hibernation and resume from it are
> analogous to the ones described above.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

The patch below adds wakeup devices support on top of this one.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Domains: Don't stop wakeup devices during system sleep transitions

Devices that are set up to wake up the system from sleep states
should not be stopped and power should not be removed from them
when the system goes into a sleep state.  Make the generic PM domain
code respect that limitation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -446,6 +446,9 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(dev))
+		return 0;
+
 	if (genpd->stop_device)
 		genpd->stop_device(dev);
 
@@ -666,6 +669,9 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(dev))
+		return 0;
+
 	if (genpd->stop_device)
 		genpd->stop_device(dev);
 
