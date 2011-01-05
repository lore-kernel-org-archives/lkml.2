Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1AEXsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:48:13 -0500
Received: from kroah.org ([198.145.64.141]:41048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644Ab1AEXpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:16 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:27 2011
Message-Id: <20110105230327.076718056@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tavis Ormandy <taviso@google.com>, Kees Cook <kees@ubuntu.com>,
        Robert Swiecki <swiecki@google.com>
Subject: [36/49] install_special_mapping skips security_file_mmap check.
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Tavis Ormandy <taviso@cmpxchg8b.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    5 +++++
 mm/mmap.c |   16 ++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -247,6 +247,11 @@ static int __bprm_mm_init(struct linux_b
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (err)
+		goto err;
+
 	err = insert_vm_struct(mm, vma);
 	if (err)
 		goto err;
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2290,6 +2290,7 @@ int install_special_mapping(struct mm_st
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
+	int ret;
 	struct vm_area_struct *vma;
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
@@ -2306,16 +2307,23 @@ int install_special_mapping(struct mm_st
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


