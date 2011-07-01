Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1GAAXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:23:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab1GAAXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:23:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 7/10 v6] PM / Domains: Don't stop wakeup devices during system sleep transitions
Date: Fri, 1 Jul 2011 02:24:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201106112223.04972.rjw@sisk.pl> <201107010128.03732.rjw@sisk.pl> <8762nmc1hs.fsf@ti.com>
In-Reply-To: <8762nmc1hs.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107010224.37609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 01, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
...
> > So the only way forward I can see is to add a special PM domain callback,
> > say .active_wakeup(), that will return "true" if the device is to be left
> > active when wakeup-enabled.  So the check you don't like will become
> > something like:
> >
> > if (device_may_wakeup(dev) && genpd->active_wakeup
> >     && genpd->active_wakeup(dev))
> >         return 0;
> >
> > Would that be better?
> 
> Yes, much better.  And I like the default behavior if no hooks are provided.

So, what about the appended patch instead of the $subject one?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Domains: Wakeup devices support for system sleep transitions

There is the problem how to handle devices set up to wake up the
system from sleep states during system-wide power transitions.
In some cases, those devices can be turned off entirely, because the
wakeup signals will be generated on their behalf anyway.  In some
other cases, they will generate wakeup signals if their clocks are
stopped, but only if power is not removed from them.  Finally, in
some cases, they can only generate wakeup signals if power is not
removed from them and their clocks are enabled.

To allow platform-specific code to decide whether or not to put
wakeup devices (and their PM domains) into low-power state during
system-wide transitions, such as system suspend, introduce a new
generic PM domain callback, .active_wakeup(), that will be used
during the "noirq" phase of system suspend and hibernation (after
image creation) to decide what to do with wakeup devices.
Specifically, if this callback is present and returns "true", the
generic PM domain code will not execute .stop_device() for the
given wakeup device and its PM domain won't be powered off.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    8 ++++++++
 include/linux/pm_domain.h   |    1 +
 2 files changed, 9 insertions(+)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -450,6 +450,10 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(dev)
+	    && genpd->active_wakeup && genpd->active_wakeup(dev))
+		return 0;
+
 	if (genpd->stop_device)
 		genpd->stop_device(dev);
 
@@ -670,6 +674,10 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(dev)
+	    && genpd->active_wakeup && genpd->active_wakeup(dev))
+		return 0;
+
 	if (genpd->stop_device)
 		genpd->stop_device(dev);
 
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -38,6 +38,7 @@ struct generic_pm_domain {
 	int (*power_on)(struct generic_pm_domain *domain);
 	int (*start_device)(struct device *dev);
 	int (*stop_device)(struct device *dev);
+	bool (*active_wakeup)(struct device *dev);
 };
 
 static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
