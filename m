Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab0LIU22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:28:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755972Ab0LIU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:28:27 -0500
Date: Thu, 9 Dec 2010 12:28:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tavis Ormandy <taviso@cmpxchg8b.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, security@kernel.org,
        kees@ubuntu.com, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, eugene@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [Security] [PATCH] install_special_mapping skips
 security_file_mmap check.
Message-Id: <20101209122802.939938ca.akpm@linux-foundation.org>
In-Reply-To: <20101209191637.GD9267@cmpxchg8b.com>
References: <20101209142942.GB9267@cmpxchg8b.com>
	<20101209103853.89bd577b.randy.dunlap@oracle.com>
	<20101209191637.GD9267@cmpxchg8b.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010 20:16:37 +0100
Tavis Ormandy <taviso@cmpxchg8b.com> wrote:

> On Thu, Dec 09, 2010 at 10:38:53AM -0800, Randy Dunlap wrote:
> > 
> > Uh, something happened to the tabs at the beginning of each line...
> > I.e., the original file content has been mucked up.
> > 
> 
> Gah. Apologies, second attempt...
> 
> The install_special_mapping routine (used, for example, to setup the vdso)
> skips the security check before insert_vm_struct, allowing a local attacker to
> bypass the mmap_min_addr security restriction by limiting the available pages
> for special mappings. bprm_mm_init() also skips the check, although I don't
> think this can be used to bypass any restrictions, I don't see any reason not
> to have the security check.
> 
> $ uname -m
> x86_64
> $ cat /proc/sys/vm/mmap_min_addr
> 65536
> $ cat install_special_mapping.s
> section .bss
>     resb BSS_SIZE
> section .text
>     global _start
>     _start:
>         mov     eax, __NR_pause
>         int     0x80
> $ nasm -D__NR_pause=29 -DBSS_SIZE=0xfffed000 -f elf -o install_special_mapping.o install_special_mapping.s
> $ ld -m elf_i386 -Ttext=0x10000 -Tbss=0x11000 -o install_special_mapping install_special_mapping.o
> $ ./install_special_mapping &
> [1] 14303
> $ cat /proc/14303/maps 
> 0000f000-00010000 r-xp 00000000 00:00 0                                  [vdso]
> 00010000-00011000 r-xp 00001000 00:19 2453665                            /home/taviso/install_special_mapping
> 00011000-ffffe000 rwxp 00000000 00:00 0                                  [stack]
> 
> It's worth noting that Red Hat are shipping with mmap_min_addr set to 4096.
> 
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2479,6 +2479,11 @@ int install_special_mapping(struct mm_struct *mm,
>  	vma->vm_ops = &special_mapping_vmops;
>  	vma->vm_private_data = pages;
>  
> +	if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
> +		kmem_cache_free(vm_area_cachep, vma);
> +		return -EPERM;
> +	}

This should return the security_file_mmap() errno rather than assuming
EPERM.  Although it happens to be the case that EPERM is the only errno
which security_file_mmap() presently returns, afacit.

Ditto insert_vm_struct(), with s/EPERM/ENOMEM/

Please review and test?


--- a/mm/mmap.c~mm-install_special_mapping-skips-security_file_mmap-check-fix
+++ a/mm/mmap.c
@@ -2463,6 +2463,7 @@ int install_special_mapping(struct mm_st
 			    unsigned long vm_flags, struct page **pages)
 {
 	struct vm_area_struct *vma;
+	int ret;
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
@@ -2479,21 +2480,21 @@ int install_special_mapping(struct mm_st
 	vma->vm_ops = &special_mapping_vmops;
 	vma->vm_private_data = pages;
 
-	if (security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1)) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -EPERM;
-	}
-
-	if (unlikely(insert_vm_struct(mm, vma))) {
-		kmem_cache_free(vm_area_cachep, vma);
-		return -ENOMEM;
-	}
+	ret = security_file_mmap(NULL, 0, 0, 0, vma->vm_start, 1);
+	if (ret < 0)
+		goto out;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret < 0)
+		goto out;
 
 	mm->total_vm += len >> PAGE_SHIFT;
 
 	perf_event_mmap(vma);
-
 	return 0;
+out:
+	kmem_cache_free(vm_area_cachep, vma);
+	return ret;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
_

