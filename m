Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0LFPV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:21:28 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44431 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0LFPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:21:27 -0500
Date: Mon, 6 Dec 2010 10:21:21 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, nhorman@tuxdriver.com
Subject: [PATCH] add additional audit info (read/write length & rng name) for
 RNG devices
Message-ID: <20101206152121.GA13235@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -3.6 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add /dev/[u]random auditing

Patch to enhance auditing of user visible random number generators.  Allows us to
determine how many bytes of random data were obtained on each read from an RNG
device

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 drivers/char/random.c |   18 +++++++++++++++---
 include/linux/audit.h |   11 +++++++++++
 kernel/auditsc.c      |   29 +++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 3 deletions(-)


diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5a1aa64..94ee4a6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -241,6 +241,7 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
+#include <linux/audit.h>
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 # include <linux/irq.h>
@@ -1000,7 +1001,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	ssize_t n, retval = 0, count = 0;
 
 	if (nbytes == 0)
-		return 0;
+		goto out;
 
 	while (nbytes > 0) {
 		n = nbytes;
@@ -1047,13 +1048,22 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 				/* like a named pipe */
 	}
 
+out:
+	audit_rng("random", count);
 	return (count ? count : retval);
 }
 
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	return extract_entropy_user(&nonblocking_pool, buf, nbytes);
+	ssize_t count;
+
+	count = extract_entropy_user(&nonblocking_pool, buf, nbytes);
+
+	if (count >= 0)
+		audit_rng("urandom", count);
+
+	return count;
 }
 
 static unsigned int
@@ -1101,10 +1111,12 @@ static ssize_t random_write(struct file *file, const char __user *buffer,
 	ret = write_pool(&blocking_pool, buffer, count);
 	if (ret)
 		return ret;
+	audit_rng("random", count);
+
 	ret = write_pool(&nonblocking_pool, buffer, count);
 	if (ret)
 		return ret;
-
+	audit_rng("urandom", count);
 	return (ssize_t)count;
 }
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 8b5c062..2f90d9e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -123,6 +123,8 @@
 #define AUDIT_MAC_UNLBL_STCADD	1416	/* NetLabel: add a static label */
 #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label */
 
+#define AUDIT_RNG		1601	/* usage of /dev/random and /dev/urandom */
+
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
@@ -428,6 +430,7 @@ extern void __audit_inode(const char *name, const struct dentry *dentry);
 extern void __audit_inode_child(const struct dentry *dentry,
 				const struct inode *parent);
 extern void __audit_ptrace(struct task_struct *t);
+extern int __audit_rng(const char *name, size_t len);
 
 static inline int audit_dummy_context(void)
 {
@@ -456,6 +459,13 @@ static inline void audit_ptrace(struct task_struct *t)
 		__audit_ptrace(t);
 }
 
+static inline int audit_rng(const char *name, size_t len)
+{
+	if (likely(audit_dummy_context()))
+		return 0;
+	return __audit_rng(name, len);
+}
+
 				/* Private API (for audit.c only) */
 extern unsigned int audit_serial(void);
 extern int auditsc_get_stamp(struct audit_context *ctx,
@@ -574,6 +584,7 @@ extern int audit_signals;
 #define audit_log_capset(pid, ncr, ocr) ((void)0)
 #define audit_mmap_fd(fd, flags) ((void)0)
 #define audit_ptrace(t) ((void)0)
+#define audit_rng(c, l) (0)
 #define audit_n_rules 0
 #define audit_signals 0
 #endif
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f49a031..1236cf4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -157,6 +157,12 @@ struct audit_aux_data_capset {
 	struct audit_cap_data	cap;
 };
 
+struct audit_aux_data_rng {
+	struct audit_aux_data d;
+	const char *name;
+	size_t len;
+};
+
 struct audit_tree_refs {
 	struct audit_tree_refs *next;
 	struct audit_chunk *c[31];
@@ -1410,6 +1416,13 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			audit_log_cap(ab, "new_pe", &axs->new_pcap.effective);
 			break; }
 
+		case AUDIT_RNG: {
+			struct audit_aux_data_rng *axr = (void *)aux;
+			audit_log_format(ab, "name=");
+			audit_log_string(ab, axr->name);
+			audit_log_format(ab, " len=%zu", axr->len);
+			break; }
+
 		}
 		audit_log_end(ab);
 	}
@@ -2285,6 +2298,22 @@ int audit_bprm(struct linux_binprm *bprm)
 	return 0;
 }
 
+int __audit_rng(const char *name, size_t len)
+{
+	struct audit_aux_data_rng *ax;
+	struct audit_context *context = current->audit_context;
+
+	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
+	if (!ax)
+		return -ENOMEM;
+
+	ax->name = name;
+	ax->len = len;
+	ax->d.type = AUDIT_RNG;
+	ax->d.next = context->aux;
+	context->aux = (void *)ax;
+	return 0;
+}
 
 /**
  * audit_socketcall - record audit data for sys_socketcall
