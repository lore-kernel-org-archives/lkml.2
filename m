Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2BRCBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 21:01:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40289 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2BRCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 21:01:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.237.106 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 17 Feb 2012 18:00:50 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH] mm: mmap() sometimes succeeds even if the region to map
 is invalid.
In-Reply-To: <4F3E1319.6050304@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1202171703260.24948@eggly.anvils>
References: <4F3E1319.6050304@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012, Naotaka Hamaguchi wrote:
> This patch fixes two bugs of mmap():
>  1. mmap() succeeds even if "offset" argument is a negative value, although
>     it should return EINVAL in such case. Currently I have only checked
>     it on x86_64 because (a) x86 seems to OK to accept a negative offset
>     for mapping 2GB-4GB regions, and (b) I don't know about other
>     architectures at all (I'll make it if needed).
> 
>  2. mmap() would succeed if "offset" + "length" get overflow, although
>     it should return EOVERFLOW.

I'm not convinced that either of these is a problem.  Do you see an
actual bug arising from these, or is it just that you think the Linux
mmap() permits more than you expect from your reading of POSIX?

1. Should a negative offset necessarily return -EINVAL?  At present I
   can mmap() /dev/kmem on x86_64 and see what's at 0xffff880000000000:
   why should that say -EINVAL?  (I admit that my example wanted to say
   0xffffffff81000000, where /proc/kallsyms locates _text, but that did
   disappoint me with -EINVAL, because mmap_kmem() only understands the
   direct map, not the further layouts which architectures may use.)

2. We will have bugs if you manage to mmap an area crossing from pgoff
   -1 to pgoff 0, but I thought the existing checks prevented that.

mmap() should be permitting as far as it safely can; but it's a bug
if a fault on an offset beyond (page-rounded-up) end-of-file does not
then give SIGBUS.

> 
> The detail of these problems is as follows:
> 
> 1. mmap() succeeds even if "offset" argument is a negative value, although
>    it should return EINVAL in such case.
> 
> POSIX says the type of the argument "off" is "off_t", which
> is equivalent to "long" for all architecture, so it is allowed to
> give a negative "off" to mmap().
> 
> In such case, it is actually regarded as big positive value
> because the type of "off" is "unsigned long" in the kernel. 
> For example, off=-4096 (-0x1000) is regarded as 
> off = 0xfffffffffffff000 (x86_64) and as off = 0xfffff000 (x86).
> It results in mapping too big offset region.
> 
> 2. mmap() would succeed if "offset" + "length" get overflow, although
>    it should return EOVERFLOW.
> 
> The overflow check of mmap() almost doesn't work.
> 
> In do_mmap_pgoff(file, addr, len, prot, flags, pgoff),
> the existing overflow check logic is as follows.
> 
> ------------------------------------------------------------------------
> do_mmap_pgoff(struct file *file, unsigned long addr,
> 		unsigned long len, unsigned long prot,
> 		unsigned long flags, unsigned long pgoff)
> {
> 	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
> 		return -EOVERFLOW;
> }
> ------------------------------------------------------------------------
> 
> However, for example on x86_64, if we give off=0x1000 and
> len=0xfffffffffffff000, but EOVERFLOW is not returned.
> It is because the checking is based on the page offset,
> not on the byte offset.
> 
> To fix this bug, I convert this overflow check from page
> offset base to byte offset base. 
> 
> Signed-off-by: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/sys_x86_64.c |    3 +++
>  mm/mmap.c                    |    3 ++-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
> index 0514890..ddefd6c 100644
> --- a/arch/x86/kernel/sys_x86_64.c
> +++ b/arch/x86/kernel/sys_x86_64.c
> @@ -90,6 +90,9 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
>         if (off & ~PAGE_MASK)
>                 goto out;
> 
> +       if ((off_t) off < 0)
> +               goto out;
> +
>         error = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
>  out:
>         return error;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 3f758c7..2fa99cd 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -948,6 +948,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>         vm_flags_t vm_flags;
>         int error;
>         unsigned long reqprot = prot;
> +       unsigned long off = pgoff << PAGE_SHIFT;
> 
>         /*
>          * Does the application expect PROT_READ to imply PROT_EXEC?
> @@ -971,7 +972,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>                 return -ENOMEM;
> 
>         /* offset overflow? */
> -       if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
> +       if ((off + len) < off)
>                 return -EOVERFLOW;

I think you are taking away the 32-bit kernel's ability to mmap() files
up to MAX_LFS_FILESIZE.

Hugh

> 
>         /* Too many mappings? */
> --
> 1.7.7.4
> 
> Best Regards,
> Naotaka Hamaguchi
