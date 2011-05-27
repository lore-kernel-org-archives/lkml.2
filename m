Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1E0Moe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:44:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab1E0Mo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:44:29 -0400
Date: Fri, 27 May 2011 12:44:15 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-f29c50419c8d1998edd759f1990c4243a248f469@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org, srostedt@redhat.com,
        vapier@gentoo.org, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, rostedt@goodmis.org, srostedt@redhat.com,
        vapier@gentoo.org, heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <1305824936.1465.4.camel@gandalf.stny.rr.com>
References: <1305824936.1465.4.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] maccess,probe_kernel: Make write/read src const void *
Git-Commit-ID: f29c50419c8d1998edd759f1990c4243a248f469
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 12:44:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f29c50419c8d1998edd759f1990c4243a248f469
Gitweb:     http://git.kernel.org/tip/f29c50419c8d1998edd759f1990c4243a248f469
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 19 May 2011 14:35:33 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 May 2011 19:56:23 -0400

maccess,probe_kernel: Make write/read src const void *

The functions probe_kernel_write() and probe_kernel_read() do not modify
the src pointer. Allow const pointers to be passed in without the need
of a typecast.

Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1305824936.1465.4.camel@gandalf.stny.rr.com
---
 arch/blackfin/mm/maccess.c |    4 ++--
 arch/s390/mm/maccess.c     |    4 ++--
 include/linux/uaccess.h    |    8 ++++----
 mm/maccess.c               |    8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/mm/maccess.c b/arch/blackfin/mm/maccess.c
index b71cebc..e253211 100644
--- a/arch/blackfin/mm/maccess.c
+++ b/arch/blackfin/mm/maccess.c
@@ -16,7 +16,7 @@ static int validate_memory_access_address(unsigned long addr, int size)
 	return bfin_mem_access_type(addr, size);
 }
 
-long probe_kernel_read(void *dst, void *src, size_t size)
+long probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	unsigned long lsrc = (unsigned long)src;
 	int mem_type;
@@ -55,7 +55,7 @@ long probe_kernel_read(void *dst, void *src, size_t size)
 	return -EFAULT;
 }
 
-long probe_kernel_write(void *dst, void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	unsigned long ldst = (unsigned long)dst;
 	int mem_type;
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 71a4b0d..51e5cd9 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -19,7 +19,7 @@
  * using the stura instruction.
  * Returns the number of bytes copied or -EFAULT.
  */
-static long probe_kernel_write_odd(void *dst, void *src, size_t size)
+static long probe_kernel_write_odd(void *dst, const void *src, size_t size)
 {
 	unsigned long count, aligned;
 	int offset, mask;
@@ -45,7 +45,7 @@ static long probe_kernel_write_odd(void *dst, void *src, size_t size)
 	return rc ? rc : count;
 }
 
-long probe_kernel_write(void *dst, void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	long copied = 0;
 
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index d512d98..5ca0951 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -93,8 +93,8 @@ static inline unsigned long __copy_from_user_nocache(void *to,
  * Safely read from address @src to the buffer at @dst.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long probe_kernel_read(void *dst, void *src, size_t size);
-extern long __probe_kernel_read(void *dst, void *src, size_t size);
+extern long probe_kernel_read(void *dst, const void *src, size_t size);
+extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 
 /*
  * probe_kernel_write(): safely attempt to write to a location
@@ -105,7 +105,7 @@ extern long __probe_kernel_read(void *dst, void *src, size_t size);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long notrace probe_kernel_write(void *dst, void *src, size_t size);
-extern long notrace __probe_kernel_write(void *dst, void *src, size_t size);
+extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
+extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/mm/maccess.c b/mm/maccess.c
index e2b6f56..4cee182 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -15,10 +15,10 @@
  * happens, handle that and return -EFAULT.
  */
 
-long __weak probe_kernel_read(void *dst, void *src, size_t size)
+long __weak probe_kernel_read(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
-long __probe_kernel_read(void *dst, void *src, size_t size)
+long __probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
@@ -43,10 +43,10 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long __weak probe_kernel_write(void *dst, void *src, size_t size)
+long __weak probe_kernel_write(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_write")));
 
-long __probe_kernel_write(void *dst, void *src, size_t size)
+long __probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
