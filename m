Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab1EZPdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:33:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab1EZP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:29:58 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=TrBTAdWbWgUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=SmLqPcwJMorV1wg6L0QA:9 a=36RqBmZCrAxBpM8EeUMA:7 a=jEp0ucaQiEUA:10 a=WeOa-AV5lc8A:10 a=jeBq3FmKZ4MA:10 a=r04YyNQmxQEyeCc_:21 a=MwtuLC5QivM3fG4O:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110526152955.205695000@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 11:25:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 01/12] maccess,probe_kernel: Make write/read src const void *
References: <20110526152541.995963172@goodmis.org>
Content-Disposition: inline; filename=0001-maccess-probe_kernel-Make-write-read-src-const-void.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

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
-- 
1.7.4.4


