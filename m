Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1HLNuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:50:22 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52724 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1HLNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:49:22 -0400
Message-Id: <20110812134907.485280669@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 12 Aug 2011 15:48:53 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v3 4/8] s390: Add real memory access functions
References: <20110812134849.748973593@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-maccess.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Add access function for real memory needed by s390 kdump backend.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/system.h |    2 +
 arch/s390/mm/maccess.c         |   57 +++++++++++++++++++++++++++++++++++++++++
 drivers/s390/char/zcore.c      |   20 +-------------
 3 files changed, 61 insertions(+), 18 deletions(-)

--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -114,6 +114,8 @@ extern void pfault_fini(void);
 extern void cmma_init(void);
 extern int memcpy_real(void *, void *, size_t);
 extern void copy_to_absolute_zero(void *dest, void *src, size_t count);
+extern int copy_to_user_real(void __user *dest, void *src, size_t count);
+extern int copy_from_user_real(void *dest, void __user *src, size_t count);
 
 #define finish_arch_switch(prev) do {					     \
 	set_fs(current->thread.mm_segment);				     \
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/gfp.h>
 #include <asm/system.h>
 
 /*
@@ -60,6 +61,9 @@ long probe_kernel_write(void *dst, const
 	return copied < 0 ? -EFAULT : 0;
 }
 
+/*
+ * Copy memory in real mode (kernel to kernel)
+ */
 int memcpy_real(void *dest, void *src, size_t count)
 {
 	register unsigned long _dest asm("2") = (unsigned long) dest;
@@ -101,3 +105,56 @@ void copy_to_absolute_zero(void *dest, v
 	__ctl_load(cr0, 0, 0);
 	preempt_enable();
 }
+
+/*
+ * Copy memory from kernel (real) to user (virtual)
+ */
+int copy_to_user_real(void __user *dest, void *src, size_t count)
+{
+	int offs = 0, size, rc;
+	char *buf;
+
+	buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	rc = -EFAULT;
+	while (offs < count) {
+		size = min(PAGE_SIZE, count - offs);
+		if (memcpy_real(buf, src + offs, size))
+			goto out;
+		if (copy_to_user(dest + offs, buf, size))
+			goto out;
+		offs += size;
+	}
+	rc = 0;
+out:
+	free_page((unsigned long) buf);
+	return rc;
+}
+
+/*
+ * Copy memory from user (virtual) to kernel (real)
+ */
+int copy_from_user_real(void *dest, void __user *src, size_t count)
+{
+	int offs = 0, size, rc;
+	char *buf;
+
+	buf = (char *) __get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	rc = -EFAULT;
+	while (offs < count) {
+		size = min(PAGE_SIZE, count - offs);
+		if (copy_from_user(buf, src + offs, size))
+			goto out;
+		if (memcpy_real(dest + offs, buf, size))
+			goto out;
+		offs += size;
+	}
+	rc = 0;
+out:
+	free_page((unsigned long) buf);
+	return rc;
+}
+
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -142,22 +142,6 @@ static int memcpy_hsa_kernel(void *dest,
 	return memcpy_hsa(dest, src, count, TO_KERNEL);
 }
 
-static int memcpy_real_user(void __user *dest, unsigned long src, size_t count)
-{
-	static char buf[4096];
-	int offs = 0, size;
-
-	while (offs < count) {
-		size = min(sizeof(buf), count - offs);
-		if (memcpy_real(buf, (void *) src + offs, size))
-			return -EFAULT;
-		if (copy_to_user(dest + offs, buf, size))
-			return -EFAULT;
-		offs += size;
-	}
-	return 0;
-}
-
 static int __init init_cpu_info(enum arch_id arch)
 {
 	struct save_area *sa;
@@ -346,8 +330,8 @@ static ssize_t zcore_read(struct file *f
 
 	/* Copy from real mem */
 	size = count - mem_offs - hdr_count;
-	rc = memcpy_real_user(buf + hdr_count + mem_offs, mem_start + mem_offs,
-			      size);
+	rc = copy_to_user_real(buf + hdr_count + mem_offs,
+			       (void *) mem_start + mem_offs, size);
 	if (rc)
 		goto fail;
 

