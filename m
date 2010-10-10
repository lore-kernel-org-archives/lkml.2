Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0JJR27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab0JJR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bTkexE97g9+goc161v3ArpwyECsCcdReIKEnI7driBw7k7NgHvwGg+vKWrlPNbdkl/
         asFMjPlxU67dVw+GqREu1kBtQnHxNaDANRlSMWpqdkc/8g37HGBvOg+FHzkjQwZWPCqx
         YnkrJMdgcpaZTWmj8cX0cLOwdzn0CKP7cL+vg=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: stradis: fix error handling and information leak to userland
Date: Sun, 10 Oct 2010 21:28:51 +0400
Message-Id: <1286731732-18082-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

configure_saa7146() didn't free irq on error.
saa_open() didn't decrease reference count of saa on error.
saa_ioctl() leaked information from the kernel stack to userland as it
didn't fill copied structs with zeros.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/stradis/stradis.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/stradis/stradis.c b/drivers/staging/stradis/stradis.c
index a057824..807dd7e 100644
--- a/drivers/staging/stradis/stradis.c
+++ b/drivers/staging/stradis/stradis.c
@@ -1286,6 +1286,7 @@ static long saa_ioctl(struct file *file,
 	case VIDIOCGCAP:
 		{
 			struct video_capability b;
+			memset(&b, 0, sizeof(b));
 			strcpy(b.name, saa->video_dev.name);
 			b.type = VID_TYPE_CAPTURE | VID_TYPE_OVERLAY |
 				VID_TYPE_CLIPPING | VID_TYPE_FRAMERAM |
@@ -1416,6 +1417,7 @@ static long saa_ioctl(struct file *file,
 	case VIDIOCGWIN:
 		{
 			struct video_window vw;
+			memset(&vw, 0, sizeof(vw));
 			vw.x = saa->win.x;
 			vw.y = saa->win.y;
 			vw.width = saa->win.width;
@@ -1448,6 +1450,7 @@ static long saa_ioctl(struct file *file,
 	case VIDIOCGFBUF:
 		{
 			struct video_buffer v;
+			memset(&v, 0, sizeof(v));
 			v.base = (void *)saa->win.vidadr;
 			v.height = saa->win.sheight;
 			v.width = saa->win.swidth;
@@ -1492,6 +1495,7 @@ static long saa_ioctl(struct file *file,
 	case VIDIOCGAUDIO:
 		{
 			struct video_audio v;
+			memset(&v, 0, sizeof(v));
 			v = saa->audio_dev;
 			v.flags &= ~(VIDEO_AUDIO_MUTE | VIDEO_AUDIO_MUTABLE);
 			v.flags |= VIDEO_AUDIO_MUTABLE | VIDEO_AUDIO_VOLUME;
@@ -1534,6 +1538,7 @@ static long saa_ioctl(struct file *file,
 	case VIDIOCGUNIT:
 		{
 			struct video_unit vu;
+			memset(&vu, 0, sizeof(vu));
 			vu.video = saa->video_dev.minor;
 			vu.vbi = VIDEO_NO_UNIT;
 			vu.radio = VIDEO_NO_UNIT;
@@ -1888,6 +1893,7 @@ static int saa_open(struct file *file)
 
 	saa->user++;
 	if (saa->user > 1) {
+		saa->user--;
 		unlock_kernel();
 		return 0;	/* device open already, don't reset */
 	}
@@ -2000,10 +2006,13 @@ static int __devinit configure_saa7146(struct pci_dev *pdev, int num)
 	if (retval < 0) {
 		dev_err(&pdev->dev, "%d: error in registering video device!\n",
 			num);
-		goto errio;
+		goto errirq;
 	}
 
 	return 0;
+
+errirq:
+	free_irq(saa->irq, saa);
 errio:
 	iounmap(saa->saa7146_mem);
 err:
-- 
1.7.0.4

