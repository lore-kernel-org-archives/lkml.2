Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2LRJoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:44:04 -0500
Received: from www84.your-server.de ([213.133.104.84]:50079 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2LRJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:04 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 4/6] Add new base function _install_special_mapping() to mmap.c
Date: Tue, 18 Dec 2012 10:40:54 +0100
Message-Id: <1355823656-13902-5-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355823656-13902-1-git-send-email-stefani@seibold.net>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

The _install_special_mapping() is the new base function for
install_special_mapping(). This function will return a pointer to the vma
which was created or a error code in an ERR_PTR()

The install_special_mapping() will unscramble this to the old behaviour,
returning an int.

This new function will be needed by the X86_64/IA32_EMULATION to map the
hpet into the 32 bit address space. This will be done with
io_remap_pfn_range() which requieres a vm_area_struct.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/mm.h |  3 +++
 mm/mmap.c          | 20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcaab4e..82a992b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1435,6 +1435,9 @@ extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
+				   unsigned long addr, unsigned long len,
+				   unsigned long flags, struct page **pages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/mm/mmap.c b/mm/mmap.c
index 9a796c4..dd85d21 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2515,7 +2515,7 @@ static const struct vm_operations_struct special_mapping_vmops = {
  * The array pointer and the pages it points to are assumed to stay alive
  * for as long as this mapping might exist.
  */
-int install_special_mapping(struct mm_struct *mm,
+struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
@@ -2524,7 +2524,7 @@ int install_special_mapping(struct mm_struct *mm,
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_mm = mm;
@@ -2545,11 +2545,23 @@ int install_special_mapping(struct mm_struct *mm,
 
 	perf_event_mmap(vma);
 
-	return 0;
+	return vma;
 
 out:
 	kmem_cache_free(vm_area_cachep, vma);
-	return ret;
+	return ERR_PTR(ret);
+}
+
+int install_special_mapping(struct mm_struct *mm,
+			    unsigned long addr, unsigned long len,
+			    unsigned long vm_flags, struct page **pages)
+{
+	struct vm_area_struct *vma = _install_special_mapping(mm,
+			    addr, len, vm_flags, pages);
+
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
+	return 0;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
-- 
1.8.0

