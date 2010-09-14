Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0INUYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:24:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab0INUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/15] lirc: make chardev nonseekable
Date: Tue, 14 Sep 2010 22:22:38 +0200
Message-Id: <1284495763-7506-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DOl+SkoKYOFFK+6AZCnjY1xon8OcqGTlDN/6T6n8+Ba
 5K9DyfjLvVVKJaq/ZQnnZUnn6E+oiuSMELHmVquFo3av83iJxw
 DXRa6FGV2PbkiNOauBQeejid9UwFhBZkomkhDRn1bJ7CQAGcgJ
 Y6spkJiQtJNEVnVw25888cfVqvPQNRAR+AHOkOh5GVLHNytv3g
 aQ8iCUpfyINzcwbGCd9sg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There does not seem to be a need for lirc to
allow seeking on the file descriptor, so let's
just disallow this before users start relying
on it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/IR/ir-lirc-codec.c   |    1 +
 drivers/media/IR/lirc_dev.c        |    2 ++
 drivers/staging/lirc/lirc_serial.c |    1 +
 drivers/staging/lirc/lirc_sir.c    |    1 +
 4 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 77b5946..8a12893 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -235,6 +235,7 @@ static struct file_operations lirc_fops = {
 	.poll		= lirc_dev_fop_poll,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
+	.llseek		= no_llseek,
 };
 
 static int ir_lirc_register(struct input_dev *input_dev)
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 899891b..5b145e8 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -460,6 +460,8 @@ error:
 
 	mutex_unlock(&lirc_dev_lock);
 
+	nonseekable_open(inode, file);
+
 	return retval;
 }
 EXPORT_SYMBOL(lirc_dev_fop_open);
diff --git a/drivers/staging/lirc/lirc_serial.c b/drivers/staging/lirc/lirc_serial.c
index 9456f8e..8da3824 100644
--- a/drivers/staging/lirc/lirc_serial.c
+++ b/drivers/staging/lirc/lirc_serial.c
@@ -1058,6 +1058,7 @@ static const struct file_operations lirc_fops = {
 	.poll		= lirc_dev_fop_poll,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
+	.llseek		= no_llseek,
 };
 
 static struct lirc_driver driver = {
diff --git a/drivers/staging/lirc/lirc_sir.c b/drivers/staging/lirc/lirc_sir.c
index eb08fa7..2478871 100644
--- a/drivers/staging/lirc/lirc_sir.c
+++ b/drivers/staging/lirc/lirc_sir.c
@@ -459,6 +459,7 @@ static const struct file_operations lirc_fops = {
 	.unlocked_ioctl	= lirc_ioctl,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
+	.llseek		= no_llseek,
 };
 
 static int set_use_inc(void *data)
-- 
1.7.1

