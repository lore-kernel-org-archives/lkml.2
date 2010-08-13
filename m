Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab0HMJbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:31:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50105 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934042Ab0HMJbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qPBBj9rj4rCAld249TehLCvdNwuyzZzFwKnJpdtEGHgoW37KCQcNMmCJ8KVdWVi3qq
         7mi0cW/usAE9oiiXBDw7aC88DJm4DXxYZCeueYGa8DZHBXOeml6W6JtzN85GhwoCRUoj
         l1PPt7AYplqrGf6HEN/BIIHTzuDfc2mAeBcas=
From: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>
To: linux-usb@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Xiaofan Chen <xiaofanc@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Nazarewicz?= <m.nazarewicz@samsung.com>,
        =?UTF-8?q?Micha=C5=82=20Nazarewicz?= <mina86@mina86.com>,
        Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: Gadget: g_multi: added INF file for gadget with multiple configurations
Date: Fri, 13 Aug 2010 11:31:14 +0200
Message-Id: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a mutlifunctional gadget has more than 1 configuration, Windows does not
use its generic driver for multifunctional USB devices.

This commit adds an INF file that will load the required Windows driver
as well as a short description in gadget_multi.txt

Signed-off-by: Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>
---
I based the INF file on linux.inf. I tested it and it works, but perhaps
the style could be improved. Comments/suggestions welcome!

 Documentation/usb/gadget_multi.txt |    8 ++++--
 Documentation/usb/linux-multi.inf  |   47 ++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/usb/linux-multi.inf

diff --git a/Documentation/usb/gadget_multi.txt b/Documentation/usb/gadget_multi.txt
index 80f4ef0..0a6dba6 100644
--- a/Documentation/usb/gadget_multi.txt
+++ b/Documentation/usb/gadget_multi.txt
@@ -49,9 +49,11 @@ get into too many details).
 The good news is: you do not have to worry about most of the
 conditions!
 
-The only thing to worry is that the gadget has to have a single
-configuration so a dual RNDIS and CDC ECM gadget won't work unless you
-create a proper INF -- and of course, if you do submit it!
+The only thing to worry about is that Windows won't use its USB Generic
+Parent Driver unless the gadget has a single configuration.
+Therefore, a dual RNDIS and CDC ECM gadget will need the
+[[file:linux-multi.inf]] file included alongside this document
+to work correctly.
 
 *** Installing drivers for each function
 
diff --git a/Documentation/usb/linux-multi.inf b/Documentation/usb/linux-multi.inf
new file mode 100644
index 0000000..836c79b
--- /dev/null
+++ b/Documentation/usb/linux-multi.inf
@@ -0,0 +1,47 @@
+; MS-Windows driver that can install usbccgp.sys
+;(generic driver for composite devices)
+; For use with composite devices that have more than 1 configuration
+; Based on linux.inf
+
+[Version]
+Signature           = "$WINDOWS NT$"
+Class               = USB
+ClassGUID           = {36fc9e60-c465-11cf-8056-444553540000}
+Provider            = %Linux%
+DriverVer           = 07/29/2010,0.0.0.0
+
+[Manufacturer]
+%Linux%	 = CCGPLoader,NTx86,NTamd64,NTia64
+
+; Decoration for x86 architecture
+[CCGPLoader.NTx86]
+%LinuxCompositeDevice% = Composite.Device,USB\VID_0525&PID_a4ab
+
+; Decoration for x64 architecture
+[LinuxDevices.NTamd64]
+%LinuxCompositeDevice% = Composite.Device,USB\VID_0525&PID_a4ab
+
+; Decoration for ia64 architecture
+[LinuxDevices.NTia64]
+%LinuxCompositeDevice% = Composite.Device,USB\VID_0525&PID_a4ab
+
+[ControlFlags]
+ExcludeFromSelect=*
+
+; Common Class Generic Parent for root ID
+[Composite.Device.NTx86]
+Include=usb.inf
+Needs=Composite.Dev.NT
+
+[Composite.Device.NTx86.Services]
+Include=usb.inf
+Needs=Composite.Dev.NT.Services
+
+[SourceDisksNames]
+1=%SourceDisk%,,1
+
+[Strings]
+ServiceDisplayName    = "USB Composite Device Driver"
+Linux                 = "Linux Developer Community"
+LinuxCompositeDevice  = "Linux Multifunction Gadget with multiple configurations"
+SourceDisk            = "Linux Composite Gadget Driver Install Disk"
-- 
1.7.0.4

