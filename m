Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0LHAxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:53:48 -0500
Received: from kroah.org ([198.145.64.141]:58625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab0LHAsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:05 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:34 2010
Message-Id: <20101208004434.620503686@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gerlach <t.m.gerlach@freenet.de>,
        Peter Jones <pjones@redhat.com>, maximilian attems <max@stro.at>
Subject: [103/127] drivers/video/efifb.c: support framebuffer for NVIDIA 9400M in MacBook Pro 5,1
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gerlach <t.m.gerlach@freenet.de>

commit 8a3bdfe6cd841880a5d849c40f90093b3817f6e0 upstream.

Description of patch:
---------------------

This is a patch for the EFI framebuffer driver to enable the framebuffer
of the NVIDIA 9400M as found in MacBook Pro (MBP) 5,1 and up.  The
framebuffer of the NVIDIA graphic cards are located at the following
addresses in memory:

9400M:    0xC0010000
9600M GT: 0xB0030000

The patch delivered right here only provides the memory location of the
framebuffer of the 9400M device.  The 9600M GT is not covered.  It is
assumed that the 9400M is used when powered up the MBP.

The information which device is currently powered and in use is stored in
the 64 bytes large EFI variable "gpu-power-prefs".  More specifically,
byte 0x3B indicates whether 9600M GT (0x00) or 9400M (0x01) is online.

The PCI bus IDs are the following:
9400M:    PCI 03:00:00
9600M GT: PCI 02:00:00

The EFI variables can be easily read-out and manipulated with "rEFIt", an
MBP specific bootloader tool.  For more information on how handle rEFIt
and EFI variables please consult "http://refit.sourceforge.net" and
"http://ubuntuforums.org/archive/index.php/t-1076879.html".

IMPORTANT NOTE: The information on how to activate the 9400M device given
at "ubuntuforums.org" is not correct, since it states

gpu-power-prefs[0x3B] = 0x00 -> 9400M (PCI 02:00:00)
gpu-power-prefs[0x3B] = 0x01 -> 9600M GT (PCI 03:00:00)

Actually, the assignment of the values and the PCI bus IDs are swapped.

Suggestions:
------------

To cover framebuffers of both 9400M and 9600M GT, I would suggest to
implement a conditional on "gpu-power-prefs".  Depending on the value of
byte 0x3B, the according framebuffer is selected.  However, this requires
kernel access to the EFI variables.

[akpm@linux-foundation.org: rename optname, per Peter Jones]
Signed-off-by: Thomas Gerlach <t.m.gerlach@freenet.de>
Acked-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/efifb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -49,6 +49,7 @@ enum {
 	M_MBP_2,	/* MacBook Pro 2nd gen */
 	M_MBP_SR,	/* MacBook Pro (Santa Rosa) */
 	M_MBP_4,	/* MacBook Pro, 4th gen */
+	M_MBP_5_1,    /* MacBook Pro, 5,1th gen */
 	M_UNKNOWN	/* placeholder */
 };
 
@@ -70,6 +71,7 @@ static struct efifb_dmi_info {
 	[M_MBP_2] = { "mbp2", 0, 0, 0, 0 }, /* placeholder */
 	[M_MBP_SR] = { "mbp3", 0x80030000, 2048 * 4, 1440, 900 },
 	[M_MBP_4] = { "mbp4", 0xc0060000, 2048 * 4, 1920, 1200 },
+	[M_MBP_5_1] = { "mbp51", 0xc0010000, 2048 * 4, 1440, 900 },
 	[M_UNKNOWN] = { NULL, 0, 0, 0, 0 }
 };
 
@@ -106,6 +108,7 @@ static struct dmi_system_id __initdata d
 	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
 	{},
 };
 


