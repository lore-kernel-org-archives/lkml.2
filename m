Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0G1QmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:42:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33864 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0G1QmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Wcd1fvkJySXJLno4bwoeB9Yz1FTP0/SRbI52EmAyQTu8ZUrj5/z7PqPKQI9hfCK1ya
         f72uws3hUFIvAqgDyCs2cT2U9bpm/F24253wUIlG00+oiQASzqdQgkRbVYKwOOln5bgD
         KUE2vaD0sb2DITzdtBFnDS6StySN/TL0pNgUM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eliot Blennerhassett <eblennerhassett@audioscience.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] ALSA: asihpi: check return value of get_user()
Date: Wed, 28 Jul 2010 20:41:56 +0400
Message-Id: <1280335316-23515-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/pci/asihpi/hpioctl.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 3114999..62895a7 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -121,11 +121,17 @@ long asihpi_hpi_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	phpi_ioctl_data = (struct hpi_ioctl_linux __user *)arg;
 
 	/* Read the message and response pointers from user space.  */
-	get_user(puhm, &phpi_ioctl_data->phm);
-	get_user(puhr, &phpi_ioctl_data->phr);
+	if (get_user(puhm, &phpi_ioctl_data->phm) ||
+	    get_user(puhr, &phpi_ioctl_data->phr)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	/* Now read the message size and data from user space.  */
-	get_user(hm->h.size, (u16 __user *)puhm);
+	if (get_user(hm->h.size, (u16 __user *)puhm)) {
+		err = -EFAULT;
+		goto out;
+	}
 	if (hm->h.size > sizeof(*hm))
 		hm->h.size = sizeof(*hm);
 
@@ -138,7 +144,10 @@ long asihpi_hpi_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		goto out;
 	}
 
-	get_user(res_max_size, (u16 __user *)puhr);
+	if (get_user(res_max_size, (u16 __user *)puhr)) {
+		err = -EFAULT;
+		goto out;
+	}
 	/* printk(KERN_INFO "user response size %d\n", res_max_size); */
 	if (res_max_size < sizeof(struct hpi_response_header)) {
 		HPI_DEBUG_LOG(WARNING, "small res size %d\n", res_max_size);
-- 
1.7.0.4

