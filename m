Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1DFWfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:35:38 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60634 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005Ab1DFWfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:35:37 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime PM callbacks
Organization: Texas Instruments, Inc.
References: <201103270058.41632.rjw@sisk.pl>
Date: Wed, 06 Apr 2011 15:35:32 -0700
In-Reply-To: <201103270058.41632.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 27 Mar 2011 00:58:41 +0100")
Message-ID: <87zko3dn4b.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, Magnus,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Remove the __weak definitions of platform bus type runtime PM
> callbacks, make platform_dev_pm_ops point to the generic routines
> as appropriate and allow architectures using platform_dev_pm_ops to
> replace the runtime PM callbacks in that structure with their own
> set.
>
> Convert architectures providing its own definitions of the platform
> runtime PM callbacks to use the new mechanism.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I dont't think we should be adding yet another new interface for setting
platform-specific runtime PM ops.

We now have 3.  Two existing ones:

1) new device power domains (presumably preferred)
2) platform_bus_set_pm_ops() (disliked by many)

and now the new one you create here

3) platform_set_runtime_pm_ops()

This new one is basically the same as platform_bus_set_pm_ops(), but
targetted only at runtime PM ops, and also has all the same problems
that have been discussed before.  Namely, it overrides the pm ops for
*every* device on the platform_bus, instead of targetting only specific
devices.  With the new device power domains, we can target specific
devices.

Wouldn't the right way to go here be to convert mach-shmobile over to
using device power domains?

The patch below against v2.6.39-rc2 combined with your patch (minus the
mach-shmobile/* changes) should do it.

Magnus, care to test?

If SH-mobile is converted to use device powerdomains, not only can we
drop this new platform_set_runtime_pm_ops(), but we can also drop
platform_bus_set_pm_ops() (I have a patch for this as soon as I post
the OMAP conversions to device power domains.)

That will leave only a single interface for overriding the runtime PM
ops: device power domains.  Personally, I prefer that as it's flexible
enough, and also allows platforms to target only specific devices
instead of the whole bus.

Kevin


>From c8176cdb019ebbb055d70212b7d69c778d3b4b35 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@ti.com>
Date: Wed, 6 Apr 2011 15:25:11 -0700
Subject: [PATCH] ARM: sh-mobile: runtime PM: convert to device powerdomains

Remove the deprecated use of weak platform_bus symbols in favor of using
the new device power domains.

Cc: Magnus Damm <damm@opensource.se>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-shmobile/pm_runtime.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm_runtime.c b/arch/arm/mach-shmobile/pm_runtime.c
index 94912d3..6c75c3f 100644
--- a/arch/arm/mach-shmobile/pm_runtime.c
+++ b/arch/arm/mach-shmobile/pm_runtime.c
@@ -66,7 +66,7 @@ static void platform_pm_runtime_bug(struct device *dev,
 		dev_err(dev, "runtime pm suspend before resume\n");
 }
 
-int platform_pm_runtime_suspend(struct device *dev)
+static int platform_pm_runtime_suspend(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
@@ -82,7 +82,7 @@ int platform_pm_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-int platform_pm_runtime_resume(struct device *dev)
+static int platform_pm_runtime_resume(struct device *dev)
 {
 	struct pm_runtime_data *prd = __to_prd(dev);
 
@@ -98,12 +98,20 @@ int platform_pm_runtime_resume(struct device *dev)
 	return 0;
 }
 
-int platform_pm_runtime_idle(struct device *dev)
+static int platform_pm_runtime_idle(struct device *dev)
 {
 	/* suspend synchronously to disable clocks immediately */
 	return pm_runtime_suspend(dev);
 }
 
+static struct dev_power_domain platform_pm_power_domain = {
+	.ops = {
+		.runtime_suspend = platform_pm_runtime_suspend,
+		.runtime_resume = platform_pm_runtime_resume,
+		.runtime_idle = platform_pm_runtime_idle,
+	},
+};
+
 static int platform_bus_notify(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -114,10 +122,12 @@ static int platform_bus_notify(struct notifier_block *nb,
 
 	if (action == BUS_NOTIFY_BIND_DRIVER) {
 		prd = devres_alloc(__devres_release, sizeof(*prd), GFP_KERNEL);
-		if (prd)
+		if (prd) {
 			devres_add(dev, prd);
-		else
+			dev->pwr_domain = &platform_pm_power_domain;
+		} else {
 			dev_err(dev, "unable to alloc memory for runtime pm\n");
+		}
 	}
 
 	return 0;
-- 
1.7.4



