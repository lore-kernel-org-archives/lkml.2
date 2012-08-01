Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2HAKLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:11:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab2HAKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:11:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/13] perf, x86: Add copy_from_user_nmi_nochk for best effort copy
Date: Wed,  1 Aug 2012 12:10:55 +0200
Message-Id: <1343815865-5511-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1343815865-5511-1-git-send-email-jolsa@redhat.com>
References: <1343815865-5511-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding copy_from_user_nmi_nochk that provides the best effort
copy regardless the requesting size crossing the task boundary.

This is going to be useful for stack dump we need in post
DWARF CFI based unwind, where we have predefined size of
the user stack to dump, and we need to store the most of
the requested dump size, regardless this size is crossing
the task boundary.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/include/asm/uaccess.h |    2 ++
 arch/x86/lib/usercopy.c        |   15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e1f3a17..d8d6bcd 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -562,6 +562,8 @@ struct __large_struct { unsigned long buf[100]; };
 #endif /* CONFIG_X86_WP_WORKS_OK */
 
 extern unsigned long
+copy_from_user_nmi_nochk(void *to, const void __user *from, unsigned long n);
+extern unsigned long
 copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 4f74d94..29ca1c7 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -14,7 +14,7 @@
  * best effort, GUP based copy_from_user() that is NMI-safe
  */
 unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+copy_from_user_nmi_nochk(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
 	unsigned long size, len = 0;
@@ -22,9 +22,6 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
-	if (__range_not_ok(from, n, TASK_SIZE))
-		return len;
-
 	do {
 		ret = __get_user_pages_fast(addr, 1, 0, &page);
 		if (!ret)
@@ -46,4 +43,14 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(copy_from_user_nmi_nochk);
+
+unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+		return 0;
+
+	return copy_from_user_nmi_nochk(to, from, n);
+}
 EXPORT_SYMBOL_GPL(copy_from_user_nmi);
-- 
1.7.7.6

