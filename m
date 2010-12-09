Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab0LITRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:17:12 -0500
Received: from lock.cmpxchg8b.com ([89.16.178.151]:57638 "EHLO
	lock.cmpxchg8b.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0LITRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:17:09 -0500
Date: Thu, 9 Dec 2010 20:16:37 +0100
From: Tavis Ormandy <taviso@cmpxchg8b.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org,
        kees@ubuntu.com, eugene@redhat.com
Subject: Re: [PATCH] install_special_mapping skips security_file_mmap check.
Message-ID: <20101209191637.GD9267@cmpxchg8b.com>
References: <20101209142942.GB9267@cmpxchg8b.com>
 <20101209103853.89bd577b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209103853.89bd577b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 10:38:53AM -0800, Randy Dunlap wrote:
> 
> Uh, something happened to the tabs at the beginning of each line...
> I.e., the original file content has been mucked up.
> 

Gah. Apologies, second attempt...

The install_special_mapping routine (used, for example, to setup the vdso)
skips the security check before insert_vm_struct, allowing a local attacker to
bypass the mmap_min_addr security restriction by limiting the available pages
for special mappings. bprm_mm_init() also skips the check, although I don't
think this can be used to bypass any restrictions, I don't see any reason not
to have the security check.

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

It's worth noting that Red Hat are shipping with mmap_min_addr set to 4096.

Signed-off-by: Tavis Ormandy <taviso@google.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Robert Swiecki <swiecki@google.com>
Cc: stable@kernel.org
---
 fs/exec.c |    7 +++++++
 mm/mmap.c |    5 +++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index d68c378..7e8c4b6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -275,7 +275,14 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+
+	err = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+
+	if (err)
+		goto err;
+
 	err = insert_vm_struct(mm, vma);
+
 	if (err)
 		goto err;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index b179abb..1de3f4b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2479,6 +2479,11 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
+	if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
+		kmem_cache_free(vm_area_cachep, vma);
+		return -EPERM;
+	}
+
 	if (unlikely(insert_vm_struct(mm, vma))) {
 		kmem_cache_free(vm_area_cachep, vma);
 		return -ENOMEM;


-- 
-------------------------------------
taviso@cmpxchg8b.com | pgp encrypted mail preferred
-------------------------------------------------------
