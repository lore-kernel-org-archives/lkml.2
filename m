Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0FGMkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:40:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56223 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0FGMja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 07 Jun 2010 14:39:56 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 09/13] USB: gadget: g_multi: added documentation and INF files
In-reply-to: <61c7dcd3597ed56ec1caa5bcb66bf9bc1b09fb66.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <9fe3db6d72e8376ece39bbe4f5ac9c8cd863af4c.1275906835.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
 <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
 <7781ec0d22fa9dde7afbd3bf915af1a592780938.1275906835.git.m.nazarewicz@samsung.com>
 <871680934027e59f08ad63399a5923960147d313.1275906835.git.m.nazarewicz@samsung.com>
 <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
 <61c7dcd3597ed56ec1caa5bcb66bf9bc1b09fb66.1275906835.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A short documentation of the g_multi driver along with INF
files for Windows XP SP3 are provided.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/gadget_multi.txt  |  149 +++++++++++++++++++++++++++++++++++
 Documentation/usb/linux-cdc-acm.inf |    4 +-
 Documentation/usb/linux-rndis.inf   |    6 +-
 3 files changed, 154 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt

diff --git a/Documentation/usb/gadget_multi.txt b/Documentation/usb/gadget_multi.txt
new file mode 100644
index 0000000..0bd9139
--- /dev/null
+++ b/Documentation/usb/gadget_multi.txt
@@ -0,0 +1,149 @@
+                                                             -*- org -*-
+
+* Overview
+
+The Multifunction Composite Gadget (or g_multi) is a composite gadget
+that makes extensive use of the composite framework to provide
+a... multifunction gadget.
+
+In it's standard configuration it provides a single USB configuration
+with RNDIS[1] (that is Ethernet), USB CDC[2] ACM (that is serial) and
+USB Mass Storage functions.
+
+A CDC ECM (Ethernet) function may be turned on via a Kconfig option
+and RNDIS can be turned off.  If they are both enabled the gadget will
+have two configurations -- one with RNDIS and another with CDC ECM[3].
+
+Please not that if you use non-standard configuration (that is enable
+CDC ECM) you may need to change vendor and/or product ID.
+
+* Host drivers
+
+To make use of the gadget one needs to make it work on host side --
+without that there's no hope of achieving anything with the gadget.
+As one might expect, things one need to do very from system to system.
+
+** Linux host drivers
+
+Since the gadget uses standard composite framework and appears as such
+to Linux host it does not need any additional drivers on Linux host
+side.  All the functions are handled by respective drivers developed
+for them.
+
+This is also true for two configuration set-up with RNDIS
+configuration being the first one.  Linux host will use the second
+configuration with CDC ECM which should work better under Linux.
+
+** Windows host drivers
+
+For the gadget two work under Windown two conditions have to be met:
+
+*** Detecting as composite gadget
+
+First of all, Windows need to detect the gadget as an USB composite
+gadget which on its own have some conditions[4].  If they are met,
+Windows lets USB Generic Parent Driver[5] handle the device which then
+tries to much drivers for each individual interface (sort of, don't
+get into too many details).
+
+The good news is: you do not have to worry about most of the
+conditions!
+
+The only thing to worry is that the gadget has to have a single
+configuration so a dual RNDIS and CDC ECM gadget won't work unless you
+create a proper INF -- and of course, if you do submit it!
+
+*** Installing drivers for each function
+
+The other, trickier thing is making Windows install drivers for each
+individual function.
+
+For mass storage it is trivial since Windows detect it's an interface
+implementing USB Mass Storage class and selects appropriate driver.
+
+Things are harder with RDNIS and CDC ACM.
+
+**** RNDIS
+
+To make Windows select RNDIS drivers for the first function in the
+gadget, one needs to use the [[file:linux-rndis.inf]] file provided with
+this document.  It "attaches" Window's RNDIS driver to the first
+interface of the gadget.
+
+Please note, that while testing we encountered some issues[6] when
+RNDIS was not the first interface.  You do not need to worry abut it
+unless you are trying to develop your own gadget in which case watch
+out for this bug.
+
+**** CDC ACM
+
+Similarly, [[file:linux-cdc-acm.inf]] is provided for CDC ACM.
+
+**** Customising the gadget
+
+If you intend to hack the g_multi gadget be advised that rearranging
+functions will obviously change interface numbers for each of the
+functionality.  As an effect provided INFs won't work since they have
+interface numbers hard-coded in them (it's not hard to change those
+though[7]).
+
+This also means, that after experimenting with g_multi and changing
+provided functions one should change gadget's vendor and/or product ID
+so there will be no collision with other customised gadgets or the
+original gadget.
+
+Failing to comply may cause brain damage after wondering for hours why
+things don't work as intended before realising Windows have cached
+some drivers information (changing USB port may sometimes help plus
+you might try using USBDeview[8] to remove the phantom device).
+
+**** INF testing
+
+Provided INF files have been tested on Windows XP SP3, Windows Vista
+and Windows 7, all 32-bit versions.  It should work on 64-bit versions
+as well.  It most likesy won't work on Windows prior to Windows XP
+SP2.
+
+** Other systems
+
+At this moment, drivers for any other systems have not been tested.
+Knowing how MacOS is based on BSD and BSD is an Open Source it is
+believed that it should (read: "I have no idea whether it will") work
+out-of-the-box.
+
+For more exotic systems I have even less to say...
+
+Any testing and drivers *are* *welcome*!
+
+* Authors
+
+This document has been written by Michal Nazarewicz
+([[mailto:mina86@mina86.com]]) and INF files have been hacked with
+support of Marek Szyprowski ([[mailto:m.szyprowski@samsung.com]]) and
+Xiaofan Chen ([[mailto:xiaofanc@gmail.com]]) basing on the MS RNDIS
+template[9] and Microchip's CDC ACM INF file.
+
+* Footnotes
+
+[1] Remote Network Driver Interface Specification,
+[[http://msdn.microsoft.com/en-us/library/ee484414.aspx]].
+
+[2] Communications Device Class Abstract Control Model, spec for this
+and other USB classes can be found at
+[[http://www.usb.org/developers/devclass_docs/]].
+
+[3] CDC Ethernet Control Model.
+
+[4] [[http://msdn.microsoft.com/en-us/library/ff537109(v=VS.85).aspx]]
+
+[5] [[http://msdn.microsoft.com/en-us/library/ff539234(v=VS.85).aspx]]
+
+[6] To put it in some other nice words, Windows failed to respond to
+any user input.
+
+[7] You may find [[http://www.cygnal.org/ubb/Forum9/HTML/001050.html]]
+useful.
+
+[8] http://www.nirsoft.net/utils/usb_devices_view.html
+
+[9] [[http://msdn.microsoft.com/en-us/library/ff570620.aspx]]
diff --git a/Documentation/usb/linux-cdc-acm.inf b/Documentation/usb/linux-cdc-acm.inf
index 0e338e5..241d3d9 100644
--- a/Documentation/usb/linux-cdc-acm.inf
+++ b/Documentation/usb/linux-cdc-acm.inf
@@ -89,10 +89,10 @@ end of the line.
 [SourceDisksFiles]
 [SourceDisksNames]
 [DeviceList]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_0525&PID_A4AB&MI_02
 
 [DeviceList.NTamd64]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_0525&PID_A4AB&MI_02
 
 
 ;------------------------------------------------------------------------------
diff --git a/Documentation/usb/linux-rndis.inf b/Documentation/usb/linux-rndis.inf
index fa608fa..0cf87dc 100644
--- a/Documentation/usb/linux-rndis.inf
+++ b/Documentation/usb/linux-rndis.inf
@@ -30,15 +30,15 @@ DriverVer           = 06/21/2006,6.0.6000.16384
 
 ; Decoration for x86 architecture
 [RndisDevices.NTx86]
-%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
 
 ; Decoration for x64 architecture
 [RndisDevices.NTamd64]
-%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
 
 ; Decoration for ia64 architecture
 [RndisDevices.NTia64]
-%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2
+%RndisDevice%       = RNDIS.NT.5.1, USB\VID_0525&PID_a4a2, USB\VID_0525&PID_a4ab&MI_00
 
 ;@@@ This is the common setting for setup
 [ControlFlags]
-- 
1.7.1

