Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0DINBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:01:49 -0400
Received: from mout2.freenet.de ([195.4.92.92]:48467 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0DINBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:01:45 -0400
To: linux-kernel@vger.kernel.org
From: t.m.gerlach@freenet.de
Subject: [PATCH] drivers/video/efifb.c: Framebuffer for NVIDIA 9400M in MacBook Pro 5,1
Cc: akpm@linux-foundation.org, linux-fbdev@vger.kernel.org
X-Priority: 3
X-Abuse: 305211200 / 147.142.42.125
User-Agent: freenetMail
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1O0Dq7-0005Fc-MW@www5.emo.freenet-rz.de>
Date: Fri, 09 Apr 2010 15:01:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description of patch:
---------------------
This is a patch for the EFI framebuffer driver to enable the framebuffer of the
NVIDIA 9400M as found in MacBook Pro (MBP) 5,1 and up.
The framebuffer of the NVIDIA graphic cards are located at the following
addresses in memory:

9400M:    0xC0010000
9600M GT: 0xB0030000

The patch delivered right here only provides the memory location of the
framebuffer of the 9400M device. The 9600M GT is not covered. It is assumed that
the 9400M is used when powered up the MBP.
The information which device is currently powered and in use is stored in the
64 bytes large EFI variable "gpu-power-prefs". More specifically, byte 0x3B
indicates whether 9600M GT (0x00) or 9400M (0x01) is online.

The PCI bus IDs are the following:
9400M:    PCI 03:00:00
9600M GT: PCI 02:00:00

The EFI variables can be easily read-out and manipulated with "rEFIt", an MBP
specific bootloader tool. For more information on how handle rEFIt and EFI
variables please consult "http://refit.sourceforge.net" and
"http://ubuntuforums.org/archive/index.php/t-1076879.html".

IMPORTANT NOTE: The information on how to activate the 9400M device given at
"ubuntuforums.org" is not correct, since it states

gpu-power-prefs[0x3B] = 0x00 -> 9400M (PCI 02:00:00)
gpu-power-prefs[0x3B] = 0x01 -> 9600M GT (PCI 03:00:00)

Actually, the assignment of the values and the PCI bus IDs are swapped.

Suggestions:
------------
To cover framebuffers of both 9400M and 9600M GT, I would suggest to implement
a conditional on "gpu-power-prefs". Depending on the value of byte 0x3B, the
according framebuffer is selected. However, this requires kernel access to the
EFI variables.

Patch:
------

--- linux-2.6.31//drivers/video/efifb.c.orig    2010-03-31 09:22:39.000000000 +0200
+++ linux-2.6.31//drivers/video/efifb.c    2010-03-31 09:26:05.000000000 +0200
@@ -49,6 +49,7 @@ enum {
     M_MBP_2,    /* MacBook Pro 2nd gen */
     M_MBP_SR,    /* MacBook Pro (Santa Rosa) */
     M_MBP_4,    /* MacBook Pro, 4th gen */
+    M_MBP_5_1,    /* MacBook Pro, 5,1th gen */
     M_UNKNOWN    /* placeholder */
 };
 
@@ -70,6 +71,7 @@ static struct efifb_dmi_info {
     [M_MBP_2] = { "mbp2", 0, 0, 0, 0 }, /* placeholder */
     [M_MBP_SR] = { "mbp3", 0x80030000, 2048 * 4, 1440, 900 },
     [M_MBP_4] = { "mbp4", 0xc0060000, 2048 * 4, 1920, 1200 },
+    [M_MBP_5_1] = { "mbp5,1", 0xc0010000, 2048 * 4, 1440, 900 },
     [M_UNKNOWN] = { NULL, 0, 0, 0, 0 }
 };
 
@@ -106,6 +108,7 @@ static struct dmi_system_id __initdata d
     EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
     EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
     EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
+    EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
     {},
 };


Signed-off-by: Thomas Gerlach <t.m.gerlach@freenet.de>



Gratis: Jeden Monat 3 SMS versenden-
Mit freenetMail - Ihrer kostenlose E-Mail-Adresse
http://email.freenet.de/dienste/emailoffice/produktuebersicht/basic/sms/index.html?pid=6830

