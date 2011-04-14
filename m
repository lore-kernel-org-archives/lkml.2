Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab1DNSBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:01:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:42414 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965084Ab1DNR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tavis Ormandy <taviso@cmpxchg8b.com>,
        Tavis Ormandy <taviso@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 184/209] install_special_mapping skips security_file_mmap check.
Date: Thu, 14 Apr 2011 13:55:42 -0400
Message-Id: <1302803767-9715-71-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tavis Ormandy <taviso@cmpxchg8b.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 462e635e5b73ba9a4c03913b77138cd57ce4b050 upstream.

The install_special_mapping routine (used, for example, to setup the
vdso) skips the security check before insert_vm_struct, allowing a local
attacker to bypass the mmap_min_addr security restriction by limiting
the available pages for special mappings.

bprm_mm_init() also skips the check, and although I don't think this can
be used to bypass any restrictions, I don't see any reason not to have
the security check.

  $ uname -m
  x86_64
  $ cat /proc/sys/vm/mmap_min_addr
  65536
  $ cat install_special_mapping.s
  section .bss
      resb BSS_SIZE
  section .text
      global _start
      _start:
          mov     eax, __NR_pause
          int     0x80
  $ nasm -D__NR_pause=29 -DBSS_SIZE=0xfffed000 -f elf -o install_special_mapping.o install_special_mapping.s
  $ ld -m elf_i386 -Ttext=0x10000 -Tbss=0x11000 -o install_special_mapping install_special_mapping.o
  $ ./install_special_mapping &
  [1] 14303
  $ cat /proc/14303/maps
  0000f000-00010000 r-xp 00000000 00:00 0                                  [vdso]
  00010000-00011000 r-xp 00001000 00:19 2453665                            /home/taviso/install_special_mapping
  00011000-ffffe000 rwxp 00000000 00:00 0                                  [stack]

It's worth noting that Red Hat are shipping with mmap_min_addr set to
4096.

Signed-off-by: Tavis Ormandy <taviso@google.com>
Acked-by: Kees Cook <kees@ubuntu.com>
Acked-by: Robert Swiecki <swiecki@google.com>
[ Changed to not drop the error code - akpm ]
Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/exec.c |    5 +++++
 mm/mmap.c |   16 ++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8d4912f..5bc2413 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -268,6 +268,11 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+
+	err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (err)
+		goto err;
+
 	err = insert_vm_struct(mm, vma);
 	if (err)
 		goto err;
diff --git a/mm/mmap.c b/mm/mmap.c
index 10cb197..b42b469 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2443,6 +2443,7 @@ int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
+	int ret;
 	struct vm_area_struct *vma;
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
@@ -2460,16 +2461,23 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
-	if (unlikely(insert_vm_struct(mm, vma))) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -ENOMEM;
-	}
+	ret = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (ret)
+		goto out;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret)
+		goto out;
 
 	mm->total_vm += len >> PAGE_SHIFT;
 
 	perf_event_mmap(vma);
 
 	return 0;
+
+out:
+	kmem_cache_free(vm_area_cachep, vma);
+	return ret;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
-- 
1.7.4.4

