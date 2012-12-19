Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2LSVad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:30:33 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51414 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2LSVa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:30:26 -0500
Message-ID: <50D231EC.2000804@gmail.com>
Date: Thu, 20 Dec 2012 08:30:20 +1100
From: Michael Cassaniti <m.cassaniti@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux Security Module mailing list 
	<linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Security: hooks for seccomp as extended attribute
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From Michael Cassaniti <m.cassaniti@gmail.com>

Superficial patch showing hooks for seccomp extended attribute filter code
Written against Linux 3.5

Signed-off-by: Michael Cassaniti <m.cassaniti@gmail.com>
---

diff -uprN -X linux-3.5-rp1/Documentation/dontdiff linux-3.5/fs/exec.c 
linux-3.5-rp1/fs/exec.c
--- linux-3.5/fs/exec.c    2012-07-22 06:58:29.000000000 +1000
+++ linux-3.5-rp1/fs/exec.c    2012-09-13 12:27:14.966076904 +1000
@@ -1537,6 +1537,10 @@ static int do_execve_common(const char *
      if (retval < 0)
          goto out;

+    retval = security_seccomp_from_vfs(bprm);
+    if (retval < 0)
+        goto out;
+
      retval = copy_strings_kernel(1, &bprm->filename, bprm);
      if (retval < 0)
          goto out;
diff -uprN -X linux-3.5-rp1/Documentation/dontdiff 
linux-3.5/include/linux/seccomp.h linux-3.5-rp1/include/linux/seccomp.h
--- linux-3.5/include/linux/seccomp.h    2012-07-22 06:58:29.000000000 
+1000
+++ linux-3.5-rp1/include/linux/seccomp.h    2012-09-21 
12:43:28.215772113 +1000
@@ -119,6 +119,14 @@ static inline int seccomp_mode(struct se
  extern void put_seccomp_filter(struct task_struct *tsk);
  extern void get_seccomp_filter(struct task_struct *tsk);
  extern u32 seccomp_bpf_load(int off);
+
+#define SECCOMP_XATTR_NAME "security.seccomp"
+#define SECCOMP_XATTR_LEN        128
+#define SECCOMP_XATTR_BIT_EN        0
+#define SECCOMP_XATTR_BIT_DEF_ACTION    1
+#define SECCOMP_XATTR_BIT_DEF_RETURN    2
+#define SECCOMP_XATTR_BITMAP_START    3
+
  #else  /* CONFIG_SECCOMP_FILTER */
  static inline void put_seccomp_filter(struct task_struct *tsk)
  {
diff -uprN -X linux-3.5-rp1/Documentation/dontdiff 
linux-3.5/include/linux/security.h linux-3.5-rp1/include/linux/security.h
--- linux-3.5/include/linux/security.h    2012-07-22 06:58:29.000000000 
+1000
+++ linux-3.5-rp1/include/linux/security.h    2012-09-21 
12:00:24.026007169 +1000
@@ -3023,5 +3023,23 @@ static inline void free_secdata(void *se
  { }
  #endif /* CONFIG_SECURITY */

+#ifdef CONFIG_SECCOMP_FILTER
+
+extern int append_seccomp_from_vfs(struct linux_binprm *bprm);
+
+static inline int security_seccomp_from_vfs(struct linux_binprm *bprm)
+{
+    return append_seccomp_from_vfs(bprm);
+}
+
+#else
+
+static inline int security_seccomp_from_vfs(struct linux_binprm *bprm)
+{
+    return 0;
+}
+
+#endif /* CONFIG_SECCOMP_FILTER */
+
  #endif /* ! __LINUX_SECURITY_H */

diff -uprN -X linux-3.5-rp1/Documentation/dontdiff 
linux-3.5/kernel/seccomp.c linux-3.5-rp1/kernel/seccomp.c
--- linux-3.5/kernel/seccomp.c    2012-07-22 06:58:29.000000000 +1000
+++ linux-3.5-rp1/kernel/seccomp.c    2012-09-21 13:23:52.254969072 +1000
@@ -502,3 +502,9 @@ long prctl_set_seccomp(unsigned long sec
  out:
      return ret;
  }
+
+int append_seccomp_from_vfs(struct linux_binprm *bprm)
+{
+    pr_debug("Entered stub %s\n", __func__);
+    return 0;
+}

