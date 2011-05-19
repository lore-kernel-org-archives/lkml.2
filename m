Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab1ESRJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:09:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab1ESRI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:08:58 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=0D7m8ADXWtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=-X2q0GmM04VV6-h6-IcA:9 a=OGnNkXVyXp7csUeOqGYA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=4Sb2Aq4J3WL08v87:21 a=tXHoBcW0jMw8iIvs:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC][PATCH] maccess,probe_kernel: Make write/read src const void *
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 19 May 2011 13:08:56 -0400
Message-ID: <1305824936.1465.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I get Acked-by's from the S390 and Blackfin maintainers please.

Thanks!

-- Steve



maccess,probe_kernel: Make src const void *

The functions probe_kernel_write() and probe_kernel_read() do not modify
the src pointer. Allow const pointers to be passed in without the need
of a typecast.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

 arch/blackfin/mm/maccess.c |    4 ++--
 arch/s390/mm/maccess.c     |    4 ++--
 include/linux/uaccess.h    |    8 ++++----
 mm/maccess.c               |    8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-trace.git/arch/blackfin/mm/maccess.c
===================================================================
--- linux-trace.git.orig/arch/blackfin/mm/maccess.c
+++ linux-trace.git/arch/blackfin/mm/maccess.c
@@ -16,7 +16,7 @@ static int validate_memory_access_addres
 	return bfin_mem_access_type(addr, size);
 }
 
-long probe_kernel_read(void *dst, void *src, size_t size)
+long probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	unsigned long lsrc = (unsigned long)src;
 	int mem_type;
@@ -55,7 +55,7 @@ long probe_kernel_read(void *dst, void *
 	return -EFAULT;
 }
 
-long probe_kernel_write(void *dst, void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	unsigned long ldst = (unsigned long)dst;
 	int mem_type;
Index: linux-trace.git/arch/s390/mm/maccess.c
===================================================================
--- linux-trace.git.orig/arch/s390/mm/maccess.c
+++ linux-trace.git/arch/s390/mm/maccess.c
@@ -19,7 +19,7 @@
  * using the stura instruction.
  * Returns the number of bytes copied or -EFAULT.
  */
-static long probe_kernel_write_odd(void *dst, void *src, size_t size)
+static long probe_kernel_write_odd(void *dst, const void *src, size_t size)
 {
 	unsigned long count, aligned;
 	int offset, mask;
@@ -45,7 +45,7 @@ static long probe_kernel_write_odd(void 
 	return rc ? rc : count;
 }
 
-long probe_kernel_write(void *dst, void *src, size_t size)
+long probe_kernel_write(void *dst, const void *src, size_t size)
 {
 	long copied = 0;
 
Index: linux-trace.git/include/linux/uaccess.h
===================================================================
--- linux-trace.git.orig/include/linux/uaccess.h
+++ linux-trace.git/include/linux/uaccess.h
@@ -93,8 +93,8 @@ static inline unsigned long __copy_from_
  * Safely read from address @src to the buffer at @dst.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long probe_kernel_read(void *dst, void *src, size_t size);
-extern long __probe_kernel_read(void *dst, void *src, size_t size);
+extern long probe_kernel_read(void *dst, const void *src, size_t size);
+extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 
 /*
  * probe_kernel_write(): safely attempt to write to a location
@@ -105,7 +105,7 @@ extern long __probe_kernel_read(void *ds
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long notrace probe_kernel_write(void *dst, void *src, size_t size);
-extern long notrace __probe_kernel_write(void *dst, void *src, size_t size);
+extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
+extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
 #endif		/* __LINUX_UACCESS_H__ */
Index: linux-trace.git/mm/maccess.c
===================================================================
--- linux-trace.git.orig/mm/maccess.c
+++ linux-trace.git/mm/maccess.c
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


