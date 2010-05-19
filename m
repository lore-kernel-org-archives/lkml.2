Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0ESJFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:05:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44956 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0ESJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:04:05 -0400
Date: Wed, 19 May 2010 11:04:22 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 8/8] USB: gadget: g_multi: added documentation and INF files
In-reply-to: <2460ac80ee51e759c7d4d552112c2e816db7c83b.1274187425.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <d849a70e2a74a635a27ae0fa7899bc3905ef4fcf.1274187425.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
 <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com>
 <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com>
 <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com>
 <a2865e8e9c3a9a305833ffea9caaec661082d5cf.1274187425.git.m.nazarewicz@samsung.com>
 <785cc2b8e47bacfa2ec25b9ed6cec4abc0326b64.1274187425.git.m.nazarewicz@samsung.com>
 <2460ac80ee51e759c7d4d552112c2e816db7c83b.1274187425.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A short documentation of the g_multi driver along with INF
files for Windows XP SP3 are provided.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/usb/gadget_multi.txt        |  129 +++++++++++++++++++
 Documentation/usb/gadget_multi_rndis.inf  |  200 +++++++++++++++++++++++++++++
 Documentation/usb/gadget_multi_serial.inf |   44 +++++++
 3 files changed, 373 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt
 create mode 100644 Documentation/usb/gadget_multi_rndis.inf
 create mode 100644 Documentation/usb/gadget_multi_serial.inf

diff --git a/Documentation/usb/gadget_multi.txt b/Documentation/usb/gadget_multi.txt
new file mode 100644
index 0000000..7365521
--- /dev/null
+++ b/Documentation/usb/gadget_multi.txt
@@ -0,0 +1,129 @@
+                                                             -*- org -*-
+
+* Overview
+
+The Multifunction Composite Gadget (or g_multi) is a customisable
+composite gadget that makes extensive use of the composite framework
+to provide a... multifunction gadget.
+
+In it's standard configuration it provides a single USB configuration
+with RNDIS[1] (that is Ethernet), USB CDC[2] ACM (that is serial) and
+USB Mass Storage functions.
+
+Each function can be disabled via a Kconfig option.  There's also
+a CDC ECM (Ethernet) function which can be turned on.  If, however,
+CDC ECM and RNDIS are enabled the gadget will have two configurations
+-- one with RNDIS and another with CDC ECM[3].
+
+Please not, however, that if you use non-standard configuration you
+may need to change vendor and/or product ID.
+
+* Linux host drivers
+
+Since the gadget uses standard composite framework and appears as such
+to Linux host it does not need any additional drivers on Linux host
+side.  All the functions are handled by respective drivers designed
+for them.
+
+This is also true for two configuration set-up with RNDIS
+configuration being the first one.  Linux host will use the second
+configuration with CDC ECM which should work better under Linux.
+
+* Windows host drivers
+
+For the gadget two work under Windown two conditions have to be met:
+
+** Detecting as composite gadget
+
+First of all, Windows need to detect the gadget as an USB composite
+gadget (Microsoft calls it USB Generic Parent Driver[4]).  This on its
+own have some conditions[5].  The good news is that you don't have to
+worry about most of them.
+
+The only thing to worry is that Windows won't use its USB Generic
+Parent Driver unless the gadget has a single configuration so a dual
+RNDIS and CDC ECM gadget won't work unless you create an INF.  And of
+course, if you do submit it!
+
+** Attaching drivers for each function
+
+The other, trickier thing is making Windows attach drivers to each
+individual function.
+
+For mass storage it is trivial since Windows detect it's an USB Mass
+Storage class and selects appropriate driver.
+
+Things are harder with RDNIS and CDC ACM.
+
+*** RNDIS
+
+To make Windows select RNDIS drivers for the first function in the
+gadget, one needs to use the [[file:gadget_multi_rndis.inf]] file
+provided with this document.  It "attaches" Window's RNDIS driver to
+the first interface of the gadget.
+
+*** CDC ACM
+
+Similarly, [[file:gadget_multi_serial.inf]] is provided for CDC ACM.
+Note, however that it also requires an usbser.sys file which can be
+extracted form Windows XP SP3 cab files.
+
+It is important to note that this works only with this particular
+version of the usbser.sys file and not the other versions that can be
+found on the Internet.
+
+*** Customising the gadget
+
+It is important to note, that after customising g_multi interface
+numbers change and so provided INF files will most likely stop working
+due to interface number mismatch.
+
+This also means, that after changing the set of functions available in
+g_multi one should change gadget's vendor and/or product ID so there
+will be no collision with other customised gadgets or the original
+gadget.
+
+*** Improvements in INF files
+
+It needs to be noted that we are not Windows driver experts and as
+such we do not claim that provided INF files are the flawless or that
+they will work on each and every Windows versions (they were tested on
+Windows XP SP3 only).
+
+The bottom line is, if you can improve the INF files, please do and
+share the results. :)
+
+* Other systems
+
+At this moment, drivers for any other systems have not been tested.
+Knowing how MacOS is based on BSD and BSD is an Open Source it is
+believed that (read: "I have no idea whether"), unlike under Windows,
+it should work out-of-the-box.
+
+For more exotic systems I have even less to say...
+
+Any testing and drivers *are* *welcome*!
+
+* Authors
+
+This document has been written by Michal Nazarewicz
+([[mailto:m.nazarewicz@samsung.com]]) and the INF files have been
+hacked by Marek Szyprowski ([[mailto:m.szyprowski@samsung.com]])
+basing on the [[file:linux.inf]] file provided for Ethernet gadget
+and description from [[file:gadget_serial.txt]].
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
+[4] [[http://msdn.microsoft.com/en-us/library/ff539234(v=VS.85).aspx]].
+
+[5] [[http://msdn.microsoft.com/en-us/library/ff537109(v=VS.85).aspx]].
+
diff --git a/Documentation/usb/gadget_multi_rndis.inf b/Documentation/usb/gadget_multi_rndis.inf
new file mode 100644
index 0000000..9bd13a9
--- /dev/null
+++ b/Documentation/usb/gadget_multi_rndis.inf
@@ -0,0 +1,200 @@
+; MS-Windows driver config matching some basic modes of the
+; Linux-USB Ethernet/RNDIS gadget firmware:
+;
+;  - RNDIS plus CDC Ethernet ... this may be familiar as a DOCSIS
+;    cable modem profile, and supports most non-Microsoft USB hosts
+;
+;  - RNDIS plus CDC Subset ... used by hardware that incapable of
+;    full CDC Ethernet support.
+;
+; Microsoft only directly supports RNDIS drivers, and bundled them into XP.
+; The Microsoft "Remote NDIS USB Driver Kit" is currently found at:
+;   http://www.microsoft.com/whdc/hwdev/resources/HWservices/rndis.mspx
+
+
+[Version]
+Signature           = "$CHICAGO$"
+Class               = Net
+ClassGUID           = {4d36e972-e325-11ce-bfc1-08002be10318}
+Provider            = %Linux%
+Compatible          = 1
+MillenniumPreferred = .ME
+DriverVer           = 03/30/2004,0.0.0.0
+; catalog file would be used by WHQL
+;CatalogFile         = Linux.cat
+
+[Manufacturer]
+%Linux%          = LinuxDevices,NT.5.1
+
+[LinuxDevices]
+; NetChip IDs, used by both firmware modes
+%LinuxDevice%    = RNDIS, USB\VID_0525&PID_a4ab&MI_00
+
+[LinuxDevices.NT.5.1]
+%LinuxDevice%    = RNDIS.NT.5.1, USB\VID_0525&PID_a4ab&MI_00
+
+[ControlFlags]
+ExcludeFromSelect=*
+
+; Windows 98, Windows 98 Second Edition specific sections --------
+
+[RNDIS]
+DeviceID        = usb8023
+MaxInstance     = 512
+DriverVer           = 03/30/2004,0.0.0.0
+AddReg          = RNDIS_AddReg_98, RNDIS_AddReg_Common
+
+[RNDIS_AddReg_98]
+HKR, ,               DevLoader,        0, *ndis
+HKR, ,               DeviceVxDs,       0, usb8023.sys
+HKR, NDIS,           LogDriverName,    0, "usb8023"
+HKR, NDIS,           MajorNdisVersion, 1, 5
+HKR, NDIS,           MinorNdisVersion, 1, 0
+HKR, Ndi\Interfaces, DefUpper,         0, "ndis3,ndis4,ndis5"
+HKR, Ndi\Interfaces, DefLower,         0, "ethernet"
+HKR, Ndi\Interfaces, UpperRange,       0, "ndis3,ndis4,ndis5"
+HKR, Ndi\Interfaces, LowerRange,       0, "ethernet"
+HKR, Ndi\Install,    ndis3,            0, "RNDIS_Install_98"
+HKR, Ndi\Install,    ndis4,            0, "RNDIS_Install_98"
+HKR, Ndi\Install,    ndis5,            0, "RNDIS_Install_98"
+HKR, Ndi,            DeviceId,         0, "USB\VID_0525&PID_a4ab&MI_00"
+
+[RNDIS_Install_98]
+CopyFiles=RNDIS_CopyFiles_98
+
+[RNDIS_CopyFiles_98]
+usb8023.sys, usb8023w.sys, , 0 
+rndismp.sys, rndismpw.sys, , 0 
+
+; Windows Millennium Edition specific sections --------------------
+
+[RNDIS.ME]
+DeviceID        = usb8023
+MaxInstance     = 512
+DriverVer           = 03/30/2004,0.0.0.0
+AddReg          = RNDIS_AddReg_ME, RNDIS_AddReg_Common
+Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
+BusType         = 15
+
+[RNDIS_AddReg_ME]
+HKR, ,               DevLoader,        0, *ndis
+HKR, ,               DeviceVxDs,       0, usb8023.sys
+HKR, NDIS,           LogDriverName,    0, "usb8023"
+HKR, NDIS,           MajorNdisVersion, 1, 5
+HKR, NDIS,           MinorNdisVersion, 1, 0
+HKR, Ndi\Interfaces, DefUpper,         0, "ndis3,ndis4,ndis5"
+HKR, Ndi\Interfaces, DefLower,         0, "ethernet"
+HKR, Ndi\Interfaces, UpperRange,       0, "ndis3,ndis4,ndis5"
+HKR, Ndi\Interfaces, LowerRange,       0, "ethernet"
+HKR, Ndi\Install,    ndis3,            0, "RNDIS_Install_ME"
+HKR, Ndi\Install,    ndis4,            0, "RNDIS_Install_ME"
+HKR, Ndi\Install,    ndis5,            0, "RNDIS_Install_ME"
+HKR, Ndi,            DeviceId,         0, "USB\VID_0525&PID_a4ab&MI_00"
+
+[RNDIS_Install_ME]
+CopyFiles=RNDIS_CopyFiles_ME
+
+[RNDIS_CopyFiles_ME]
+usb8023.sys, usb8023m.sys, , 0 
+rndismp.sys, rndismpm.sys, , 0 
+
+; Windows 2000 specific sections ---------------------------------
+
+[RNDIS.NT]
+Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
+BusType         = 15
+DriverVer           = 03/30/2004,0.0.0.0
+AddReg          = RNDIS_AddReg_NT, RNDIS_AddReg_Common
+CopyFiles       = RNDIS_CopyFiles_NT
+
+[RNDIS.NT.Services]
+AddService = USB_RNDIS, 2, RNDIS_ServiceInst_NT, RNDIS_EventLog
+
+[RNDIS_CopyFiles_NT]
+; no rename of files on Windows 2000, use the 'k' names as is
+usb8023k.sys, , , 0 
+rndismpk.sys, , , 0 
+
+[RNDIS_ServiceInst_NT]
+DisplayName     = %ServiceDisplayName%
+ServiceType     = 1 
+StartType       = 3 
+ErrorControl    = 1 
+ServiceBinary   = %12%\usb8023k.sys    
+LoadOrderGroup  = NDIS
+AddReg          = RNDIS_WMI_AddReg_NT
+
+[RNDIS_WMI_AddReg_NT]
+HKR, , MofImagePath, 0x00020000, "System32\drivers\rndismpk.sys"
+
+; Windows XP specific sections -----------------------------------
+
+[RNDIS.NT.5.1]
+Characteristics = 0x84   ; NCF_PHYSICAL + NCF_HAS_UI
+BusType         = 15
+DriverVer           = 03/30/2004,0.0.0.0
+AddReg          = RNDIS_AddReg_NT, RNDIS_AddReg_Common
+; no copyfiles - the files are already in place
+
+[RNDIS.NT.5.1.Services]
+AddService      = USB_RNDIS, 2, RNDIS_ServiceInst_51, RNDIS_EventLog
+
+[RNDIS_ServiceInst_51]
+DisplayName     = %ServiceDisplayName%
+ServiceType     = 1 
+StartType       = 3 
+ErrorControl    = 1 
+ServiceBinary   = %12%\usb8023.sys    
+LoadOrderGroup  = NDIS
+AddReg          = RNDIS_WMI_AddReg_51
+
+[RNDIS_WMI_AddReg_51]
+HKR, , MofImagePath, 0x00020000, "System32\drivers\rndismp.sys"
+
+; Windows 2000 and Windows XP common sections --------------------
+
+[RNDIS_AddReg_NT]
+HKR, Ndi,               Service,        0, "USB_RNDIS"
+HKR, Ndi\Interfaces,    UpperRange,     0, "ndis5" 
+HKR, Ndi\Interfaces,    LowerRange,     0, "ethernet"
+
+[RNDIS_EventLog]
+AddReg = RNDIS_EventLog_AddReg
+
+[RNDIS_EventLog_AddReg]
+HKR, , EventMessageFile, 0x00020000, "%%SystemRoot%%\System32\netevent.dll"
+HKR, , TypesSupported,   0x00010001, 7
+
+; Common Sections -------------------------------------------------
+
+[RNDIS_AddReg_Common]
+HKR, NDI\params\NetworkAddress, ParamDesc,  0, %NetworkAddress%
+HKR, NDI\params\NetworkAddress, type,       0, "edit"
+HKR, NDI\params\NetworkAddress, LimitText,  0, "12"
+HKR, NDI\params\NetworkAddress, UpperCase,  0, "1"
+HKR, NDI\params\NetworkAddress, default,    0, " "
+HKR, NDI\params\NetworkAddress, optional,   0, "1"
+
+[SourceDisksNames]
+1=%SourceDisk%,,1
+
+[SourceDisksFiles]
+usb8023m.sys=1
+rndismpm.sys=1
+usb8023w.sys=1
+rndismpw.sys=1
+usb8023k.sys=1
+rndismpk.sys=1
+
+[DestinationDirs]
+RNDIS_CopyFiles_98    = 10, system32/drivers
+RNDIS_CopyFiles_ME    = 10, system32/drivers
+RNDIS_CopyFiles_NT    = 12
+
+[Strings]
+ServiceDisplayName    = "USB Remote NDIS Network Device Driver"
+NetworkAddress        = "Network Address"
+Linux                 = "Linux Developer Community"
+LinuxDevice           = "RNDIS Gadget/Linux Multifunction Gadget"
+SourceDisk            = "Linux RNDIS Gadget Driver Install Disk"
+
diff --git a/Documentation/usb/gadget_multi_serial.inf b/Documentation/usb/gadget_multi_serial.inf
new file mode 100644
index 0000000..984232f
--- /dev/null
+++ b/Documentation/usb/gadget_multi_serial.inf
@@ -0,0 +1,44 @@
+[Version]
+Signature="$Windows NT$"
+Class=Ports
+ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
+Provider=%LINUX%
+DriverVer=08/17/2004,0.0.2.1
+; Copyright (C) 2004 Al Borchers (alborchers@steinerpoint.com)
+
+[Manufacturer]
+%LINUX%=GSerialDeviceList
+
+[GSerialDeviceList]
+%GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4AB&MI_02
+
+[DestinationDirs]
+DefaultDestDir=10,System32\Drivers
+
+[GSerialInstall]
+CopyFiles=GSerialCopyFiles
+AddReg=GSerialAddReg
+
+[GSerialCopyFiles]
+usbser.sys
+
+[GSerialAddReg]
+HKR,,DevLoader,,*ntkern
+HKR,,NTMPDriver,,usbser.sys
+HKR,,EnumPropPages32,,"MsPorts.dll,SerialPortPropPageProvider"
+
+[GSerialInstall.Services]
+AddService = usbser,0x0002,GSerialService
+
+[GSerialService]
+DisplayName = %GSERIAL_DISPLAY_NAME%
+ServiceType = 1                  ; SERVICE_KERNEL_DRIVER
+StartType = 3                    ; SERVICE_DEMAND_START
+ErrorControl = 1                 ; SERVICE_ERROR_NORMAL
+ServiceBinary = %10%\System32\Drivers\usbser.sys
+LoadOrderGroup = Base
+
+[Strings]
+LINUX = "Linux"
+GSERIAL = "Serial Gadget/Linux Multifunction Gadget"
+GSERIAL_DISPLAY_NAME = "Serial Gadget/Linux Multifunction Gadget"
-- 
1.7.1

