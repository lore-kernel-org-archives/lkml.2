Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0HTIrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:47:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab0HTIrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:47:09 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 19/19] Finally, add the /dev/crypto device.
Date: Fri, 20 Aug 2010 10:46:03 +0200
Message-Id: <1282293963-27807-21-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 crypto/userspace/cryptodev_main.c |  130 +++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/crypto/userspace/cryptodev_main.c b/crypto/userspace/cryptodev_main.c
index a6712db..6ba9bd6 100644
--- a/crypto/userspace/cryptodev_main.c
+++ b/crypto/userspace/cryptodev_main.c
@@ -98,3 +98,133 @@ int __get_userbuf(uint8_t __user *addr, uint32_t len, int write,
 	return 0;
 }
 
+/* ====== /dev/crypto ====== */
+
+static int
+cryptodev_open(struct inode *inode, struct file *filp)
+{
+	struct ncr_lists *ncr;
+	int ret;
+
+	ncr = ncr_init_lists();
+	if (ncr == NULL) {
+		return -ENOMEM;
+	}
+
+	ret = audit_log_crypto_op(AUDIT_CRYPTO_OP_CONTEXT_NEW, ncr->id, -1,
+				  NULL, NULL, -1, NULL, 0, -1, NULL, 0);
+	if (ret < 0) {
+		ncr_deinit_lists(ncr);
+		return ret;
+	}
+
+	filp->private_data = ncr;
+	return 0;
+}
+
+static int
+cryptodev_release(struct inode *inode, struct file *filp)
+{
+	struct ncr_lists *ncr = filp->private_data;
+
+	if (ncr) {
+		audit_log_crypto_op(AUDIT_CRYPTO_OP_CONTEXT_DEL, ncr->id, -1,
+				    NULL, NULL, -1, NULL, 0, -1, NULL, 0);
+		ncr_deinit_lists(ncr);
+		filp->private_data = NULL;
+	}
+
+	return 0;
+}
+
+static int
+cryptodev_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	void *ncr = filp->private_data;
+
+	if (unlikely(!ncr))
+		BUG();
+
+	return ncr_ioctl(ncr, cmd, arg);
+}
+
+/* compatibility code for 32bit userlands */
+#ifdef CONFIG_COMPAT
+
+static long
+cryptodev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	void *ncr = file->private_data;
+
+	if (unlikely(!ncr))
+		BUG();
+
+	return ncr_compat_ioctl(ncr, cmd, arg);
+}
+
+#endif /* CONFIG_COMPAT */
+
+static const struct file_operations cryptodev_fops = {
+	.owner = THIS_MODULE,
+	.open = cryptodev_open,
+	.release = cryptodev_release,
+	.ioctl = cryptodev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = cryptodev_compat_ioctl,
+#endif /* CONFIG_COMPAT */
+};
+
+static struct miscdevice cryptodev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "crypto",
+	.fops = &cryptodev_fops,
+};
+
+static int __init
+cryptodev_register(void)
+{
+	int rc;
+
+	ncr_limits_init();
+	ncr_master_key_reset();
+	
+	rc = misc_register (&cryptodev);
+	if (unlikely(rc)) {
+		ncr_limits_deinit();
+		printk(KERN_ERR PFX "registration of /dev/crypto failed\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void __exit
+cryptodev_deregister(void)
+{
+	misc_deregister(&cryptodev);
+	ncr_limits_deinit();
+}
+
+/* ====== Module init/exit ====== */
+static int __init init_cryptodev(void)
+{
+	int rc;
+
+	rc = cryptodev_register();
+	if (unlikely(rc))
+		return rc;
+
+	printk(KERN_INFO PFX "driver loaded.\n");
+
+	return 0;
+}
+
+static void __exit exit_cryptodev(void)
+{
+	cryptodev_deregister();
+	printk(KERN_INFO PFX "driver unloaded.\n");
+}
+
+module_init(init_cryptodev);
+module_exit(exit_cryptodev);
-- 
1.7.2.1

