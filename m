Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1G0Afh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:53849 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1G0Af1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471225"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, david.vrabel@csr.com,
        sarah.a.sharp@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [34/98] USB: teach "devices" file about Wireless and SuperSpeed USB
Message-Id: <20110727003526.8FB3A2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 834e2312e7a384877a876b0d34dffc3046c96bcb upstream.

USB: teach "devices" file about Wireless and SuperSpeed USB

The /sys/kernel/debug/usb/devices file doesn't know about Wireless or
SuperSpeed USB.  This patch (as1416b) teaches it, and updates the
Documentation/usb/proc_sub_info.txt file accordingly.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
CC: David Vrabel <david.vrabel@csr.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[Julien Blache: The original commit also added the correct speed for
 USB_SPEED_WIRELESS, I removed it as it's not supported in 2.6.32.]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/usb/proc_usb_info.txt |   36 +++++++++++++++++++++++-------------
 drivers/usb/core/devices.c          |   10 ++++++----
 2 files changed, 29 insertions(+), 17 deletions(-)

Index: linux-2.6.35.y/Documentation/usb/proc_usb_info.txt
===================================================================
--- linux-2.6.35.y.orig/Documentation/usb/proc_usb_info.txt
+++ linux-2.6.35.y/Documentation/usb/proc_usb_info.txt
@@ -1,12 +1,17 @@
 /proc/bus/usb filesystem output
 ===============================
-(version 2003.05.30)
+(version 2010.09.13)
 
 
 The usbfs filesystem for USB devices is traditionally mounted at
 /proc/bus/usb.  It provides the /proc/bus/usb/devices file, as well as
 the /proc/bus/usb/BBB/DDD files.
 
+In many modern systems the usbfs filsystem isn't used at all.  Instead
+USB device nodes are created under /dev/usb/ or someplace similar.  The
+"devices" file is available in debugfs, typically as
+/sys/kernel/debug/usb/devices.
+
 
 **NOTE**: If /proc/bus/usb appears empty, and a host controller
 	  driver has been linked, then you need to mount the
@@ -106,8 +111,8 @@ Legend:
 
 Topology info:
 
-T:  Bus=dd Lev=dd Prnt=dd Port=dd Cnt=dd Dev#=ddd Spd=ddd MxCh=dd
-|   |      |      |       |       |      |        |       |__MaxChildren
+T:  Bus=dd Lev=dd Prnt=dd Port=dd Cnt=dd Dev#=ddd Spd=dddd MxCh=dd
+|   |      |      |       |       |      |        |        |__MaxChildren
 |   |      |      |       |       |      |        |__Device Speed in Mbps
 |   |      |      |       |       |      |__DeviceNumber
 |   |      |      |       |       |__Count of devices at this level
@@ -120,8 +125,13 @@ T:  Bus=dd Lev=dd Prnt=dd Port=dd Cnt=dd
     Speed may be:
     	1.5	Mbit/s for low speed USB
 	12	Mbit/s for full speed USB
-	480	Mbit/s for high speed USB (added for USB 2.0)
-
+	480	Mbit/s for high speed USB (added for USB 2.0);
+		  also used for Wireless USB, which has no fixed speed
+	5000	Mbit/s for SuperSpeed USB (added for USB 3.0)
+
+    For reasons lost in the mists of time, the Port number is always
+    too low by 1.  For example, a device plugged into port 4 will
+    show up with "Port=03".
 
 Bandwidth info:
 B:  Alloc=ddd/ddd us (xx%), #Int=ddd, #Iso=ddd
@@ -291,7 +301,7 @@ Here's an example, from a system which h
 an external hub connected to the root hub, and a mouse and
 a serial converter connected to the external hub.
 
-T:  Bus=00 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
+T:  Bus=00 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
 B:  Alloc= 28/900 us ( 3%), #Int=  2, #Iso=  0
 D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
 P:  Vendor=0000 ProdID=0000 Rev= 0.00
@@ -301,21 +311,21 @@ C:* #Ifs= 1 Cfg#= 1 Atr=40 MxPwr=  0mA
 I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
 E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=255ms
 
-T:  Bus=00 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 4
+T:  Bus=00 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 4
 D:  Ver= 1.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
 P:  Vendor=0451 ProdID=1446 Rev= 1.00
 C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=100mA
 I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
 E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=255ms
 
-T:  Bus=00 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=1.5 MxCh= 0
+T:  Bus=00 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=1.5  MxCh= 0
 D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
 P:  Vendor=04b4 ProdID=0001 Rev= 0.00
 C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
 I:  If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=mouse
 E:  Ad=81(I) Atr=03(Int.) MxPS=   3 Ivl= 10ms
 
-T:  Bus=00 Lev=02 Prnt=02 Port=02 Cnt=02 Dev#=  4 Spd=12  MxCh= 0
+T:  Bus=00 Lev=02 Prnt=02 Port=02 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
 D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
 P:  Vendor=0565 ProdID=0001 Rev= 1.08
 S:  Manufacturer=Peracom Networks, Inc.
@@ -330,12 +340,12 @@ E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=
 Selecting only the "T:" and "I:" lines from this (for example, by using
 "procusb ti"), we have:
 
-T:  Bus=00 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
-T:  Bus=00 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 4
+T:  Bus=00 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12   MxCh= 2
+T:  Bus=00 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 4
 I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
-T:  Bus=00 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=1.5 MxCh= 0
+T:  Bus=00 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=1.5  MxCh= 0
 I:  If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=mouse
-T:  Bus=00 Lev=02 Prnt=02 Port=02 Cnt=02 Dev#=  4 Spd=12  MxCh= 0
+T:  Bus=00 Lev=02 Prnt=02 Port=02 Cnt=02 Dev#=  4 Spd=12   MxCh= 0
 I:  If#= 0 Alt= 0 #EPs= 3 Cls=00(>ifc ) Sub=00 Prot=00 Driver=serial
 
 
Index: linux-2.6.35.y/drivers/usb/core/devices.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/devices.c
+++ linux-2.6.35.y/drivers/usb/core/devices.c
@@ -66,8 +66,8 @@
 #define ALLOW_SERIAL_NUMBER
 
 static const char *format_topo =
-/* T:  Bus=dd Lev=dd Prnt=dd Port=dd Cnt=dd Dev#=ddd Spd=ddd MxCh=dd */
-"\nT:  Bus=%2.2d Lev=%2.2d Prnt=%2.2d Port=%2.2d Cnt=%2.2d Dev#=%3d Spd=%3s MxCh=%2d\n";
+/* T:  Bus=dd Lev=dd Prnt=dd Port=dd Cnt=dd Dev#=ddd Spd=dddd MxCh=dd */
+"\nT:  Bus=%2.2d Lev=%2.2d Prnt=%2.2d Port=%2.2d Cnt=%2.2d Dev#=%3d Spd=%-4s MxCh=%2d\n";
 
 static const char *format_string_manufacturer =
 /* S:  Manufacturer=xxxx */
@@ -521,11 +521,13 @@ static ssize_t usb_device_dump(char __us
 		speed = "1.5"; break;
 	case USB_SPEED_UNKNOWN:		/* usb 1.1 root hub code */
 	case USB_SPEED_FULL:
-		speed = "12 "; break;
+		speed = "12"; break;
 	case USB_SPEED_HIGH:
 		speed = "480"; break;
+	case USB_SPEED_SUPER:
+		speed = "5000"; break;
 	default:
-		speed = "?? ";
+		speed = "??";
 	}
 	data_end = pages_start + sprintf(pages_start, format_topo,
 			bus->busnum, level, parent_devnum,
