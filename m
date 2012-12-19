Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2LSVid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:38:33 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:33506 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2LSViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:38:25 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 16:38:25 EST
Message-ID: <50D23223.6020505@gmail.com>
Date: Thu, 20 Dec 2012 08:31:15 +1100
From: Michael Cassaniti <m.cassaniti@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux Security Module mailing list 
	<linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] security: seccomp as extended attribute
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From Michael Cassaniti <m.cassaniti@gmail.com>

Add seccomp filter via extended attribute
Written against Linux 3.5

Signed-off-by: Michael Cassaniti <m.cassaniti@gmail.com>
---
diff -uprN -X linux-3.5-rp1/Documentation/dontdiff 
linux-3.5-rp1/include/linux/seccomp.h linux-3.5-rp2/include/linux/seccomp.h
--- linux-3.5-rp1/include/linux/seccomp.h    2012-09-21 
12:43:28.215772113 +1000
+++ linux-3.5-rp2/include/linux/seccomp.h    2012-09-21 
12:44:09.915410558 +1000
@@ -127,6 +127,11 @@ extern u32 seccomp_bpf_load(int off);
  #define SECCOMP_XATTR_BIT_DEF_RETURN    2
  #define SECCOMP_XATTR_BITMAP_START    3

+#define SECCOMP_FILTER_LOAD_SYSCALL BPF_STMT(BPF_LD|BPF_W|BPF_ABS, 
BPF_DATA(nr))
+#define SECCOMP_FILTER_ALLOW BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW)
+#define SECCOMP_FILTER_KILL  BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL)
+#define SECCOMP_FILTER_DENY BPF_STMT(BPF_RET|BPF_K, 
(SECCOMP_RET_ERRNO|EPERM))
+
  #else  /* CONFIG_SECCOMP_FILTER */
  static inline void put_seccomp_filter(struct task_struct *tsk)
  {
diff -uprN -X linux-3.5-rp1/Documentation/dontdiff 
linux-3.5-rp1/kernel/seccomp.c linux-3.5-rp2/kernel/seccomp.c
--- linux-3.5-rp1/kernel/seccomp.c    2012-09-21 13:23:52.254969072 +1000
+++ linux-3.5-rp2/kernel/seccomp.c    2012-09-21 14:43:27.687445601 +1000
@@ -18,6 +18,9 @@
  #include <linux/compat.h>
  #include <linux/sched.h>
  #include <linux/seccomp.h>
+#include <linux/dcache.h>    /* for dget() and struct dentry */
+#include <linux/binfmts.h>    /* for struct binprm */
+#include <linux/fs.h>        /* for struct inode */

  /* #define SECCOMP_DEBUG 1 */

@@ -224,7 +227,7 @@ static u32 seccomp_run_filters(int sysca
   *
   * Returns 0 on success or an errno on failure.
   */
-static long seccomp_attach_filter(struct sock_fprog *fprog)
+static long seccomp_attach_filter(struct sock_fprog *fprog, int copy_mode)
  {
      struct seccomp_filter *filter;
      unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
@@ -252,16 +255,22 @@ static long seccomp_attach_filter(struct

      /* Allocate a new seccomp_filter */
      filter = kzalloc(sizeof(struct seccomp_filter) + fp_size,
-             GFP_KERNEL|__GFP_NOWARN);
+                    GFP_KERNEL|__GFP_NOWARN);
      if (!filter)
          return -ENOMEM;
+
      atomic_set(&filter->usage, 1);
      filter->len = fprog->len;

      /* Copy the instructions from fprog. */
      ret = -EFAULT;
-    if (copy_from_user(filter->insns, fprog->filter, fp_size))
-        goto fail;
+    if (copy_mode) {
+        if (memcpy(filter->insns, fprog->filter, fp_size))
+            goto fail;
+    } else {
+        if (copy_from_user(filter->insns, fprog->filter, fp_size))
+            goto fail;
+    }

      /* Check and rewrite the fprog via the skb checker */
      ret = sk_chk_filter(filter->insns, filter->len);
@@ -307,7 +316,7 @@ long seccomp_attach_user_filter(char __u
  #endif
      if (copy_from_user(&fprog, user_filter, sizeof(fprog)))
          goto out;
-    ret = seccomp_attach_filter(&fprog);
+    ret = seccomp_attach_filter(&fprog, 0);
  out:
      return ret;
  }
@@ -503,8 +512,168 @@ out:
      return ret;
  }

-int append_seccomp_from_vfs(struct linux_binprm *bprm)
+int get_seccomp_xattr_from_vfs(struct linux_binprm *bprm,
+                        unsigned char *bitmap)
  {
-    pr_debug("Entered stub %s\n", __func__);
+    int size;
+    struct dentry *dentry;
+    struct inode *inode;
+
+    dentry = dget(bprm->file->f_dentry);
+    if (!dentry)
+        return -EINVAL;
+
+    inode = dentry->d_inode;
+    if (!inode || !inode->i_op->getxattr)
+        return -EOPNOTSUPP;
+
+    size = inode->i_op->getxattr((struct dentry *)dentry,
+                    SECCOMP_XATTR_NAME, bitmap,
+                    SECCOMP_XATTR_LEN);
+
+    if (size == -ENODATA || size == -EOPNOTSUPP)
+        return -EOPNOTSUPP;
+
+    if (size != SECCOMP_XATTR_LEN) {
+        pr_notice("%s: Got invalid seccomp xattr for %s\n",
+                        __func__, bprm->filename);
+        return -EINVAL;
+    }
+
      return 0;
  }
+
+void seccomp_add_bpf_rule(struct sock_filter *filter, unsigned int 
syscall,
+                unsigned int rule, unsigned int rules)
+{
+
+    /* Adds the appropriate rule to the filter list
+     * Second last rule is default action
+     * Last rule is opposite of default action
+    */
+
+    unsigned int opp_rule = rules - rule - 2;
+
+    /* If syscall matches then jump to opposing rule, else continue */
+    filter[rule] = (struct sock_filter)
+        BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, syscall, opp_rule, 0);
+}
+
+void append_seccomp_default_vfs_filters(struct sock_filter *filter,
+                        unsigned int rule,
+                        unsigned int def_action,
+                        unsigned int def_return)
+{
+    /* Add default rule at index rule, opposite rule at index rule+1 */
+    rule++;
+    if (def_action) {
+        filter[rule] = (struct sock_filter)SECCOMP_FILTER_ALLOW;
+        if (def_return)
+            filter[rule+1] = (struct sock_filter)
+                            SECCOMP_FILTER_KILL;
+        else
+            filter[rule+1] = (struct sock_filter)
+                            SECCOMP_FILTER_DENY;
+    } else {
+        if (def_return)
+            filter[rule] = (struct sock_filter)SECCOMP_FILTER_KILL;
+        else
+            filter[rule] = (struct sock_filter)SECCOMP_FILTER_DENY;
+        filter[rule+1] = (struct sock_filter)SECCOMP_FILTER_ALLOW;
+    }
+}
+
+int append_seccomp_from_vfs(struct linux_binprm *bprm)
+{
+    unsigned int i = (unsigned int)SECCOMP_XATTR_BITMAP_START;
+    unsigned int rules = 1;        /* There is 1 starting rule */
+    unsigned int rule = 0;
+    unsigned int bit;
+    unsigned int byte;
+    unsigned char curr_byte;
+    unsigned int def_action;
+    unsigned int def_return;
+    unsigned int curr_action;
+    unsigned int loop_mode = 1;
+    int rc = 0;
+    struct sock_filter *filter;
+    struct sock_fprog fprog;
+    unsigned char *bitmap = kmalloc(SECCOMP_XATTR_LEN * sizeof(*bitmap),
+                                GFP_KERNEL);
+    if (!bitmap)
+        return -ENOMEM;
+    if (get_seccomp_xattr_from_vfs(bprm, bitmap)) {
+        /* Doesn't matter if nothing returned */
+        goto out;
+    }
+
+    if (!(bitmap[0] & (1 << SECCOMP_XATTR_BIT_EN)))
+        /* Seccomp extended attribute is disabled */
+        goto out;
+
+    /* Isolate default and return bits */
+    def_action = (unsigned int)((bitmap[0] &
+                    (1 << SECCOMP_XATTR_BIT_DEF_ACTION))
+                    >> SECCOMP_XATTR_BIT_DEF_ACTION);
+    def_return  = (unsigned int)((bitmap[0] &
+                    (1 << SECCOMP_XATTR_BIT_DEF_RETURN))
+                    >> SECCOMP_XATTR_BIT_DEF_RETURN);
+
+    while (i != SECCOMP_XATTR_LEN * 8) {
+        bit = i % 8;
+        byte = i / 8;
+        curr_byte = bitmap[byte];
+        curr_action = (unsigned int) ((curr_byte >> bit) & 0x01);
+
+        if ((bit == 0) && (
+                (def_action && ((0xFF ^ curr_byte) == 0)) ||
+                ((def_action == 0) && (curr_byte == 0))
+                )) {
+            /* All byte aligned bits match default action */
+            /* Skip checking these bits */
+            i = i + 8;
+        }
+
+        if (curr_action != def_action) {
+            if (loop_mode) {
+                /* Count the number of set bits */
+                rules++;
+            } else {
+                rule++;
+                seccomp_add_bpf_rule(filter,
+                i-SECCOMP_XATTR_BITMAP_START, rule, rules);
+            }
+        }
+
+        i++;
+        if (i >= SECCOMP_XATTR_LEN * 8) {
+            if (loop_mode) {
+                /* Go through the loop again, adding filters */
+                loop_mode = 0;
+                i = (unsigned int)SECCOMP_XATTR_BITMAP_START;
+                /* Add allow/deny rules */
+                rules = rules + 2;
+                filter = kmalloc(rules * sizeof(*filter),
+                                GFP_KERNEL);
+                if (!filter) {
+                    rc = -ENOMEM;
+                    goto out;
+                }
+                filter[0] = (struct sock_filter)
+                        SECCOMP_FILTER_LOAD_SYSCALL;
+            } else {
+                break;
+            }
+        }
+    }
+
+    append_seccomp_default_vfs_filters(filter, rule, def_action,
+                                def_return);
+    fprog.len = rules;
+    fprog.filter = filter;
+    rc = seccomp_attach_filter(&fprog, 1);
+    kfree(filter);
+out:
+    kfree(bitmap);
+    return rc;
+}
