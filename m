Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1GERnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:43:09 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:53663 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab1GERnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:43:07 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jul 2011 13:43:06 EDT
From: Kevin Hilman <khilman@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Partha Basak <p-basak2@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Anand Gadiyar <gadiyar@ti.com>, <sameo@linux.intel.com>,
        <parthab@india.ti.com>, <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>, <paul@pwsan.com>,
        <johnstul@us.ibm.com>, Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support of ehci and ohci
Organization: Texas Instruments, Inc.
References: <Pine.LNX.4.44L0.1107051018580.2060-100000@iolanthe.rowland.org>
Date: Tue, 05 Jul 2011 10:37:40 -0700
In-Reply-To: <Pine.LNX.4.44L0.1107051018580.2060-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 5 Jul 2011 10:22:09 -0400 (EDT)")
Message-ID: <8762ngtyqj.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

[...]

>>>You have ignored a few very important points:
>>>
>>>Firstly, system suspend is supposed to work even when runtime PM is
>>>not configured.
>>>
>>>Secondly, the user can disable runtime PM via sysfs at any time.
>>>This shouldn't mess up system suspend.
>>>
>>>Basically, it's a bad idea to mix up system suspend with runtime PM.
>> 
>> Your observations are correct but this is a generic limitation and
>> Kevin is working on this problem in parallel.
>> 
>> As of now, all OMAP drivers are mandated to use ONLY runtime pm framework
>> for enabling/disabling clocks. I will let Kevin comment further.
>
> Okay, let's see what Kevin says.

While I did design the OMAP PM core to be runtime PM centric, and we
implemented several drivers based on runtime PM alone, after some long
discussions on linux-pm[1] with Alan and Rafael (PM maintainer) over the
last couple weeks, I'm now convinced I had the wrong design/approach.

Rafael and Alan have been patient with my stubborness, but now I've been
pursuaded.  Rafael has detailed on linux-pm the various
problems/limitations/races between runtime PM and system PM[2], so I
don't plan debating them again here.

That being said, today we have several drivers that use runtime PM calls
in their suspend/resume path and our PM domain implementation (inside
omap_device) deals with most of the limitations fine.  However, there
are 2 main problems/limitation with this that we've chosen to live with
(for now):
        
1) synchronous calls must be used in the suspend/resume path (because
   PM workqueue is frozen during suspend/resumea)
2) disabling runtime PM from userspace will prevent that device
   from hitting its low-power state during suspend.

For v3.1 (and before), we've lived with these limitations, and I'm OK
with merging other drivers for v3.1 with these limitations.  After 3.1,
this will be changing (more on this below.)  

So, while I've been OK with merging drivers with the above limitations
for one more merge window, $SUBJECT patch adds a new twist by forcibly
managing the parent device from the child device.  Personally, I really
don't like that approach and it serves as a good illustration of yet
another reason why system PM and runtime PM need understood as
conceptually very different.

For v3.2, the PM core will change[2] to futher limit/protect
interactions between runtime PM and system PM, and I will be reworking
our PM domain (omap_device) implementation accordingly.  

Basically, what that will mean is that our PM domain layer (omap_device)
will also call omap_device_idle() in the suspend path, but only if the
device is *not* already idle (from previous runtime suspend.)  The PM
domain layer will then omap_device_enable() the device in the system
resume path if it was suspended in the system suspend path.  A minimally
tested patch to do this is below.

So, the driver still does not have to care about it's specific clocks
etc. (which should address Felipe's concern), clocks and other
IP-specific PM details will all continue to be handled by omap_device,
just like it is with runtime PM.

The primary change to the driver, is that whatever needs to be done to
prepare for both runtime PM and system PM (including context
save/restore etc.) will have to be done in a common function(s) that
will be called by *both* of its ->runtime_suspend() and ->suspend()
callbacks, and similar for ->runtime_resume() and ->resume().  

Some drivers will have additional work to do for system PM though.  This
is mainly because system PM can happen at *any* time, including in the
middle of ongoing activity, whereas runtime PM transitions happen when
the device is known to be idle.  What that means is that for example, a
drivers ->suspend() method might need to wait for (or forcibly stop) any
ongoing activity in order to be sure the device is ready to be suspended.

Frankly, this is not a very big change for the drivers, as the
device-specific idle work will still be handled by the PM domain layer.

Hope that helps clarify the background.

As for this particular patch, since it is rather late in the development
cycle for v3.1, I would recommend that it wait until the omap_device
changes, and then let the PM core (for system PM and runtime PM) handle
the parent/child relationships as they are designed to.   But that is up
to Felipe and USB maintainers to decide.

Kevin

[1] https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/031559.html
[2] https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/031977.html


>From 6696e9a2b106ca9c9936e5c2ad89650010120e10 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@ti.com>
Date: Tue, 7 Jun 2011 16:07:28 -0700
Subject: [PATCH] OMAP: PM: omap_device: add system PM methods for PM domain handling

Using PM domain callbacks, use omap_device idle/enable to
automatically suspend/resume devices.  Also use pm_generic_* routines
to ensure driver's callbacks are correctly called.

Driver ->suspend callback is needed to ensure the driver is in a state
that it can be suspended.

If device is already idle (typically because of previous runtime PM
activity), there's nothing extra to do.

KJH: The omap_device_* calls should probably actually be done in the
     _noirq() methods.

Not-yet-Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/plat-omap/include/plat/omap_device.h |    4 +++
 arch/arm/plat-omap/omap_device.c              |   32 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap_device.h b/arch/arm/plat-omap/include/plat/omap_device.h
index e4c349f..bc36d05 100644
--- a/arch/arm/plat-omap/include/plat/omap_device.h
+++ b/arch/arm/plat-omap/include/plat/omap_device.h
@@ -44,6 +44,9 @@ extern struct device omap_device_parent;
 #define OMAP_DEVICE_STATE_IDLE		2
 #define OMAP_DEVICE_STATE_SHUTDOWN	3
 
+/* omap_device.flags values */
+#define OMAP_DEVICE_SUSPENDED BIT(0)
+
 /**
  * struct omap_device - omap_device wrapper for platform_devices
  * @pdev: platform_device
@@ -73,6 +76,7 @@ struct omap_device {
 	s8				pm_lat_level;
 	u8				hwmods_cnt;
 	u8				_state;
+	u8                              flags;
 };
 
 /* Device driver interface (call via platform_data fn ptrs) */
diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index 49fc0df..f2711c3 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -564,12 +564,44 @@ static int _od_runtime_resume(struct device *dev)
 	return pm_generic_runtime_resume(dev);
 }
 
+static int _od_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct omap_device *od = to_omap_device(pdev);
+	int ret;
+
+	ret = pm_generic_suspend(dev);
+
+	od->flags &= ~OMAP_DEVICE_SUSPENDED;
+
+	if (od->_state == OMAP_DEVICE_STATE_ENABLED) {
+		omap_device_idle(pdev);
+		od->flags |= OMAP_DEVICE_SUSPENDED;
+	}
+
+	return ret;
+}
+
+static int _od_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct omap_device *od = to_omap_device(pdev);
+
+	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
+	    (od->_state == OMAP_DEVICE_STATE_IDLE))
+		omap_device_enable(pdev);
+	
+	return pm_generic_resume(dev);
+}
+
 static struct dev_power_domain omap_device_power_domain = {
 	.ops = {
 		.runtime_suspend = _od_runtime_suspend,
 		.runtime_idle = _od_runtime_idle,
 		.runtime_resume = _od_runtime_resume,
 		USE_PLATFORM_PM_SLEEP_OPS
+		.suspend = _od_suspend,
+		.resume = _od_resume,
 	}
 };
 
-- 
1.7.6

