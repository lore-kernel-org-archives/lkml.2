Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2BXMdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:33:09 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59696 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2BXMdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:33:08 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] vt: lock the accent table
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 24 Feb 2012 12:47:11 +0000
Message-ID: <20120224124541.32569.24165.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

First step to debletcherising the vt console layer - pick a victim and fix
the locking

This is a nice simple object with its own rules so lets pick it out for
treatment. The user of the table already has a lock so we will also use the
same lock for updates.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/keyboard.c |  162 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/tty/vt/vt_ioctl.c |   81 +----------------------
 include/linux/vt_kern.h   |    3 +
 3 files changed, 168 insertions(+), 78 deletions(-)


diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a605549..bdf838d 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1452,3 +1452,165 @@ int __init kbd_init(void)
 
 	return 0;
 }
+
+/* Ioctl support code */
+
+/**
+ *	vt_do_diacrit		-	diacritical table updates
+ *	@cmd: ioctl request
+ *	@up: pointer to user data for ioctl
+ *	@perm: permissions check computed by caller
+ *
+ *	Update the diacritical tables atomically and safely. Lock them
+ *	against simultaneous keypresses
+ */
+int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
+{
+	struct kbdiacrs __user *a = up;
+	unsigned long flags;
+	int asize;
+	int ret = 0;
+
+	switch (cmd) {
+	case KDGKBDIACR:
+	{
+		struct kbdiacr *diacr;
+		int i;
+
+		diacr = kmalloc(MAX_DIACR * sizeof(struct kbdiacr),
+								GFP_KERNEL);
+		if (diacr == NULL)
+			return -ENOMEM;
+
+		/* Lock the diacriticals table, make a copy and then
+		   copy it after we unlock */
+		spin_lock_irqsave(&kbd_event_lock, flags);
+
+		asize = accent_table_size;
+		for (i = 0; i < asize; i++) {
+			diacr[i].diacr = conv_uni_to_8bit(
+						accent_table[i].diacr);
+			diacr[i].base = conv_uni_to_8bit(
+						accent_table[i].base);
+			diacr[i].result = conv_uni_to_8bit(
+						accent_table[i].result);
+		}
+		spin_unlock_irqrestore(&kbd_event_lock, flags);
+
+		if (put_user(asize, &a->kb_cnt))
+			ret = -EFAULT;
+		else  if (copy_to_user(a->kbdiacr, diacr,
+				asize * sizeof(struct kbdiacr)))
+			ret = -EFAULT;
+		kfree(diacr);
+		return ret;
+	}
+	case KDGKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a = up;
+		void *buf;
+
+		buf = kmalloc(MAX_DIACR * sizeof(struct kbdiacruc),
+								GFP_KERNEL);
+		if (buf == NULL)
+			return -ENOMEM;
+
+		/* Lock the diacriticals table, make a copy and then
+		   copy it after we unlock */
+		spin_lock_irqsave(&kbd_event_lock, flags);
+
+		asize = accent_table_size;
+		memcpy(buf, accent_table, asize * sizeof(struct kbdiacruc));
+
+		spin_unlock_irqrestore(&kbd_event_lock, flags);
+
+		if (put_user(asize, &a->kb_cnt))
+			ret = -EFAULT;
+		else if (copy_to_user(a->kbdiacruc, buf,
+				asize*sizeof(struct kbdiacruc)))
+			ret = -EFAULT;
+		kfree(buf);
+		return ret;
+	}
+
+	case KDSKBDIACR:
+	{
+		struct kbdiacrs __user *a = up;
+		struct kbdiacr *diacr = NULL;
+		unsigned int ct;
+		int i;
+
+		if (!perm)
+			return -EPERM;
+		if (get_user(ct, &a->kb_cnt))
+			return -EFAULT;
+		if (ct >= MAX_DIACR)
+			return -EINVAL;
+
+		if (ct) {
+			diacr = kmalloc(sizeof(struct kbdiacr) * ct,
+								GFP_KERNEL);
+			if (diacr == NULL)
+				return -ENOMEM;
+
+			if (copy_from_user(diacr, a->kbdiacr,
+					sizeof(struct kbdiacr) * ct)) {
+				kfree(diacr);
+				return -EFAULT;
+			}
+		}
+
+		spin_lock_irqsave(&kbd_event_lock, flags);
+		accent_table_size = ct;
+		for (i = 0; i < ct; i++) {
+			accent_table[i].diacr =
+					conv_8bit_to_uni(diacr[i].diacr);
+			accent_table[i].base =
+					conv_8bit_to_uni(diacr[i].base);
+			accent_table[i].result =
+					conv_8bit_to_uni(diacr[i].result);
+		}
+		spin_unlock_irqrestore(&kbd_event_lock, flags);
+		kfree(diacr);
+		return 0;
+	}
+
+	case KDSKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a = up;
+		unsigned int ct;
+		void *buf = NULL;
+
+		if (!perm)
+			return -EPERM;
+
+		if (get_user(ct, &a->kb_cnt))
+			return -EFAULT;
+
+		if (ct >= MAX_DIACR)
+			return -EINVAL;
+
+		if (ct) {
+			buf = kmalloc(ct * sizeof(struct kbdiacruc),
+								GFP_KERNEL);
+			if (buf == NULL)
+				return -ENOMEM;
+
+			if (copy_from_user(buf, a->kbdiacruc,
+					ct * sizeof(struct kbdiacruc))) {
+				kfree(buf);
+				return -EFAULT;
+			}
+		} 
+		spin_lock_irqsave(&kbd_event_lock, flags);
+		if (ct)
+			memcpy(accent_table, buf,
+					ct * sizeof(struct kbdiacruc));
+		accent_table_size = ct;
+		spin_unlock_irqrestore(&kbd_event_lock, flags);
+		kfree(buf);
+		return 0;
+	}
+	}
+	return ret;
+}
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 65447c5..80af0f9 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -753,89 +753,14 @@ int vt_ioctl(struct tty_struct *tty,
 		ret = do_kdgkb_ioctl(cmd, up, perm);
 		break;
 
+	/* Diacritical processing. Handled in keyboard.c as it has
+	   to operate on the keyboard locks and structures */
 	case KDGKBDIACR:
-	{
-		struct kbdiacrs __user *a = up;
-		struct kbdiacr diacr;
-		int i;
-
-		if (put_user(accent_table_size, &a->kb_cnt)) {
-			ret = -EFAULT;
-			break;
-		}
-		for (i = 0; i < accent_table_size; i++) {
-			diacr.diacr = conv_uni_to_8bit(accent_table[i].diacr);
-			diacr.base = conv_uni_to_8bit(accent_table[i].base);
-			diacr.result = conv_uni_to_8bit(accent_table[i].result);
-			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr))) {
-				ret = -EFAULT;
-				break;
-			}
-		}
-		break;
-	}
 	case KDGKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = up;
-
-		if (put_user(accent_table_size, &a->kb_cnt))
-			ret = -EFAULT;
-		else if (copy_to_user(a->kbdiacruc, accent_table,
-				accent_table_size*sizeof(struct kbdiacruc)))
-			ret = -EFAULT;
-		break;
-	}
-
 	case KDSKBDIACR:
-	{
-		struct kbdiacrs __user *a = up;
-		struct kbdiacr diacr;
-		unsigned int ct;
-		int i;
-
-		if (!perm)
-			goto eperm;
-		if (get_user(ct,&a->kb_cnt)) {
-			ret = -EFAULT;
-			break;
-		}
-		if (ct >= MAX_DIACR) {
-			ret = -EINVAL;
-			break;
-		}
-		accent_table_size = ct;
-		for (i = 0; i < ct; i++) {
-			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr))) {
-				ret = -EFAULT;
-				break;
-			}
-			accent_table[i].diacr = conv_8bit_to_uni(diacr.diacr);
-			accent_table[i].base = conv_8bit_to_uni(diacr.base);
-			accent_table[i].result = conv_8bit_to_uni(diacr.result);
-		}
-		break;
-	}
-
 	case KDSKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = up;
-		unsigned int ct;
-
-		if (!perm)
-			goto eperm;
-		if (get_user(ct,&a->kb_cnt)) {
-			ret = -EFAULT;
-			break;
-		}
-		if (ct >= MAX_DIACR) {
-			ret = -EINVAL;
-			break;
-		}
-		accent_table_size = ct;
-		if (copy_from_user(accent_table, a->kbdiacruc, ct*sizeof(struct kbdiacruc)))
-			ret = -EFAULT;
+		ret = vt_do_diacrit(cmd, up, perm);
 		break;
-	}
 
 	/* the ioctls below read/set the flags usually shown in the leds */
 	/* don't use them - they will go away without warning */
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index c2164fa..5d8726a 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -167,4 +167,7 @@ extern int unregister_vt_notifier(struct notifier_block *nb);
 
 extern void hide_boot_cursor(bool hide);
 
+/* keyboard  provided interfaces */
+extern int vt_do_diacrit(unsigned int cmd, void __user *up, int eperm);
+
 #endif /* _VT_KERN_H */

