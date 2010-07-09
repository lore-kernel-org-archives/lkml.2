Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0GIVfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:35:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0GIVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:35:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] lirc: use unlocked_ioctl
Date: Fri, 9 Jul 2010 23:35:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092335.39250.arnd@arndb.de>
X-Provags-ID: V02:K0:ZwYamDo9BDDHjdJtizEyCvZW4KeQAqG1OpaKzmu1NgT
 a9ganpBKS1kxHyUNG7hk3WU57D4CbYrR/qvY7/yy35ONu0EUV/
 Op2giqFRLNtAPYnWX+qG26ImMsqGWMb2CFDGANJG4rPg8xCl5Y
 9JdbkPCYFGXrIG4nh0w3t2wPt052FICl80MtKTzVp3wfJG1V3y
 nsCAwfLMX+xdpL4z6l/qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New code should not rely on the big kernel lock,
so use the unlocked_ioctl file operation in lirc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The lirc code currently conflicts with my removal of the .ioctl
operation, which I'd like to get into linux-next.

 drivers/media/IR/ir-lirc-codec.c |    7 +++----
 drivers/media/IR/lirc_dev.c      |   12 ++++++------
 drivers/media/IR/lirc_dev.h      |    3 +--
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index aff31d1..178bc5b 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -97,8 +97,7 @@ out:
 	return ret;
 }
 
-static int ir_lirc_ioctl(struct inode *node, struct file *filep,
-			 unsigned int cmd, unsigned long arg)
+static long ir_lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct lirc_codec *lirc;
 	struct ir_input_dev *ir_dev;
@@ -154,7 +153,7 @@ static int ir_lirc_ioctl(struct inode *node, struct file *filep,
 		break;
 
 	default:
-		return lirc_dev_fop_ioctl(node, filep, cmd, arg);
+		return lirc_dev_fop_ioctl(filep, cmd, arg);
 	}
 
 	return ret;
@@ -173,7 +172,7 @@ static void ir_lirc_close(void *data)
 static struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
-	.ioctl		= ir_lirc_ioctl,
+	.unlocked_ioctl	= ir_lirc_ioctl,
 	.read		= lirc_dev_fop_read,
 	.poll		= lirc_dev_fop_poll,
 	.open		= lirc_dev_fop_open,
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 9e141d5..3fd6150 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -160,7 +160,7 @@ static struct file_operations fops = {
 	.read		= lirc_dev_fop_read,
 	.write		= lirc_dev_fop_write,
 	.poll		= lirc_dev_fop_poll,
-	.ioctl		= lirc_dev_fop_ioctl,
+	.unlocked_ioctl	= lirc_dev_fop_ioctl,
 	.open		= lirc_dev_fop_open,
 	.release	= lirc_dev_fop_close,
 };
@@ -242,9 +242,9 @@ int lirc_register_driver(struct lirc_driver *d)
 		goto out;
 	} else if (!d->rbuf) {
 		if (!(d->fops && d->fops->read && d->fops->poll &&
-		      d->fops->ioctl)) {
+		      d->fops->unlocked_ioctl)) {
 			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
-				"neither read, poll nor ioctl can be NULL!\n");
+				"neither read, poll nor unlocked_ioctl can be NULL!\n");
 			err = -EBADRQC;
 			goto out;
 		}
@@ -425,6 +425,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 		retval = -ENODEV;
 		goto error;
 	}
+	file->private_data = ir;
 
 	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
 
@@ -516,12 +517,11 @@ unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 }
 EXPORT_SYMBOL(lirc_dev_fop_poll);
 
-int lirc_dev_fop_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
+long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long mode;
 	int result = 0;
-	struct irctl *ir = irctls[iminor(inode)];
+	struct irctl *ir = file->private_data;
 
 	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
 		ir->d.name, ir->d.minor, cmd);
diff --git a/drivers/media/IR/lirc_dev.h b/drivers/media/IR/lirc_dev.h
index 4afd96a..b1f6066 100644
--- a/drivers/media/IR/lirc_dev.h
+++ b/drivers/media/IR/lirc_dev.h
@@ -216,8 +216,7 @@ void *lirc_get_pdata(struct file *file);
 int lirc_dev_fop_open(struct inode *inode, struct file *file);
 int lirc_dev_fop_close(struct inode *inode, struct file *file);
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
-int lirc_dev_fop_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg);
+long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 ssize_t lirc_dev_fop_read(struct file *file, char *buffer, size_t length,
 			  loff_t *ppos);
 ssize_t lirc_dev_fop_write(struct file *file, const char *buffer, size_t length,
-- 
1.7.1

