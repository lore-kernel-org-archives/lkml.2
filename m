Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1KTKK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 05:10:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1KTKKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 05:10:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4]
Date: Sun, 20 Nov 2011 11:13:39 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>
References: <201111200153.40224.rjw@sisk.pl>
In-Reply-To: <201111200153.40224.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111201113.39348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Sleep: Update documentation related to system wakeup

The system wakeup section of Documentation/power/devices.txt is
outdated, so make it agree with the current code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt |   56 +++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 20 deletions(-)

Index: linux/Documentation/power/devices.txt
===================================================================
--- linux.orig/Documentation/power/devices.txt
+++ linux/Documentation/power/devices.txt
@@ -140,41 +140,57 @@ sequencing in the driver model tree.
 
 /sys/devices/.../power/wakeup files
 -----------------------------------
-All devices in the driver model have two flags to control handling of wakeup
-events (hardware signals that can force the device and/or system out of a low
-power state).  These flags are initialized by bus or device driver code using
+All device objects in the driver model contain fields that control the handling
+of system wakeup events (hardware signals that can force the system out of a
+sleep state).  These fields are initialized by bus or device driver code using
 device_set_wakeup_capable() and device_set_wakeup_enable(), defined in
 include/linux/pm_wakeup.h.
 
-The "can_wakeup" flag just records whether the device (and its driver) can
+The "power.can_wakeup" flag just records whether the device (and its driver) can
 physically support wakeup events.  The device_set_wakeup_capable() routine
-affects this flag.  The "should_wakeup" flag controls whether the device should
-try to use its wakeup mechanism.  device_set_wakeup_enable() affects this flag;
-for the most part drivers should not change its value.  The initial value of
-should_wakeup is supposed to be false for the majority of devices; the major
-exceptions are power buttons, keyboards, and Ethernet adapters whose WoL
-(wake-on-LAN) feature has been set up with ethtool.  It should also default
-to true for devices that don't generate wakeup requests on their own but merely
-forward wakeup requests from one bus to another (like PCI bridges).
+affects this flag.  The "power.wakeup" field is a pointer to an object of type
+struct wakeup_source used for controlling whether or not the device should use
+its system wakeup mechanism and for notifying the PM core of system wakeup
+events signaled by the device.  This object is only present for wakeup-capable
+devices (i.e. devices whose "can_wakeup" flags are set) and is created (or
+removed) by device_set_wakeup_capable().
 
 Whether or not a device is capable of issuing wakeup events is a hardware
 matter, and the kernel is responsible for keeping track of it.  By contrast,
 whether or not a wakeup-capable device should issue wakeup events is a policy
 decision, and it is managed by user space through a sysfs attribute: the
-power/wakeup file.  User space can write the strings "enabled" or "disabled" to
-set or clear the "should_wakeup" flag, respectively.  This file is only present
-for wakeup-capable devices (i.e. devices whose "can_wakeup" flags are set)
-and is created (or removed) by device_set_wakeup_capable().  Reads from the
-file will return the corresponding string.
+"power/wakeup" file.  User space can write the strings "enabled" or "disabled"
+to it to indicate whether or not, respectively, the device is supposed to signal
+system wakeup.  This file is only present if the "power.wakeup" object exists
+for the given device and is created (or removed) along with that object, by
+device_set_wakeup_capable().  Reads from the file will return the corresponding
+string.
+
+The "power/wakeup" file is supposed to contain the "disabled" string initially
+for the majority of devices; the major exceptions are power buttons, keyboards,
+and Ethernet adapters whose WoL (wake-on-LAN) feature has been set up with
+ethtool.  It should also default to "enabled" for devices that don't generate
+wakeup requests on their own but merely forward wakeup requests from one bus to
+another (like PCI Express ports).
 
-The device_may_wakeup() routine returns true only if both flags are set.
+The device_may_wakeup() routine returns true only if the "power.wakeup" object
+exists and the corresponding "power/wakeup" file contains the string "enabled".
 This information is used by subsystems, like the PCI bus type code, to see
 whether or not to enable the devices' wakeup mechanisms.  If device wakeup
 mechanisms are enabled or disabled directly by drivers, they also should use
 device_may_wakeup() to decide what to do during a system sleep transition.
-However for runtime power management, wakeup events should be enabled whenever
-the device and driver both support them, regardless of the should_wakeup flag.
+Device drivers, however, are not supposed to call device_set_wakeup_enable()
+directly in any case.
 
+It ought to be noted that system wakeup is conceptually different from "remote
+wakeup" used by runtime power management, although it may be supported by the
+same physical mechanism.  Remote wakeup is a feature allowing devices in
+low-power states to trigger specific interrupts to signal conditions in which
+they should be put into the full-power state.  Those interrupts may or may not
+be used to signal system wakeup events, depending on the hardware design.  On
+some systems it is impossible to trigger them from system sleep states.  In any
+case, remote wakeup should always be enabled for runtime power management for
+all devices and drivers that support it.
 
 /sys/devices/.../power/control files
 ------------------------------------
