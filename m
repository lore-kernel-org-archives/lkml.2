Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0KZRGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:45 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42343 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab0KZRGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OunNQfm9oFmeV7C8O5zFJLKLY6DY5baVINIYoelzDoBtCzpcs6KqoFBdl2T+MZCgtC
         xX7TDQR1ZdBw+WDsTej+A3cFAmomXQsfAnJzC9dKFfHBbJUiLvMZ/5r0UGgXMvstSobq
         fHSqA5n11dJOdrZ79d+Egn4V3LRZTyT+iGWcI=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: rc: ir-lirc-codec: fix potential integer overflow
Date: Fri, 26 Nov 2010 20:06:35 +0300
Message-Id: <1290791197-21403-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'n' may be bigger than MAX_INT*sizeof(int), if so checking of truncated
(int)(n/sizeof(int)) for LIRCBUF_SIZE overflow and then using nontruncated 'count'
doesn't make sense.  Also n may be up to sizeof(int)-1 bytes bigger than expected,
so check value of (n % sizeof(int)) too.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/media/rc/ir-lirc-codec.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1e87ee8..f011c5d 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -100,7 +100,8 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
 	int *txbuf; /* buffer with values to transmit */
-	int ret = 0, count;
+	int ret = 0;
+	size_t count;
 
 	lirc = lirc_get_pdata(file);
 	if (!lirc)
@@ -110,7 +111,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 		return -EINVAL;
 
 	count = n / sizeof(int);
-	if (count > LIRCBUF_SIZE || count % 2 == 0)
+	if (count > LIRCBUF_SIZE || count % 2 == 0 || n % sizeof(int) != 0)
 		return -EINVAL;
 
 	txbuf = memdup_user(buf, n);
-- 
1.7.0.4

