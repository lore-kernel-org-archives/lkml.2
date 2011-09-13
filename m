Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1IMNLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab1IMNLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:11:14 -0400
Date: Tue, 13 Sep 2011 09:11:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [RFC][patch 1/2] kdump: Add infrastructure for unmapping
 crashkernel memory
Message-ID: <20110913131106.GA29194@redhat.com>
References: <20110908132609.177038405@linux.vnet.ibm.com>
 <20110908132652.189920773@linux.vnet.ibm.com>
 <20110909182325.GD15748@redhat.com>
 <1315842902.3602.9.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315842902.3602.9.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 05:55:02PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> On Fri, 2011-09-09 at 14:23 -0400, Vivek Goyal wrote:
> > On Thu, Sep 08, 2011 at 03:26:10PM +0200, Michael Holzheu wrote:
> > > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > > 
> > > This patch introduces a mechanism that allows architecture backends to
> > > remove page tables for the crashkernel memory. This can protect the loaded
> > > kdump kernel from being overwritten by broken kernel code.
> > > A new function crash_map_pages() is added that can be implemented by
> > > architecture code. This function has the following syntax:
> > 
> > I guess having separate functions for mapping and unmapping pages might
> > look cleaner. Because we are not passing a page range, so specifying
> > what pages we are talking about in function name might make it more
> > clear.
> > 
> > crash_map_reserved_pages()
> > crash_unmap_reserved_pages().
> 
> Ok fine, no problem.
> 
> > Secondly, what happens to the code which runs after crash (crash_kexec()).
> > Current x86 code assumes that reserved region is mapped at the time of
> > crash and does few things with control page there. 
> 
> For s390, purgatory code can run in real mode. No page tables are
> required.
> 
> > So this generic approach is not valid atleast for x86, because it does
> > not tackle the scenario about how to map reserved range again once 
> > kernel crashes. It will only work if there is assumption that after
> > a crash, we don't expect reserved range/pages to be mapped.
> 
> All architectures that support unmapping of crashkernel memory have to
> deal with this problem somehow. Either remap the crashkernel memory in
> machine_kexec() again or be able to run in real mode.
> 
> I adjusted that patch regarding your comment above. Will the following
> patch be ok for you?

I guess it is fine. Atleast conceptually it makes sense to unmap
the reserved memory pages to avoid accidental corruption from some
kernel code. It does not take care of some kind of DMA happening
to this memory location though.

I am not an memory management expert so not sure if this is best way
to call unmap/map pages for some calls already exist which can do
the job.

Anyway, this change is not visible to user and changes can be done
later also without impacting anything else so it is a low risk change
that way.

So yes, please repost the series (as you need to change second patch
also to reflect new function names). I will ack the first patch.

Thanks
Vivek 


> ---
> Subject: kdump: Add infrastructure for unmapping crashkernel memory
> 
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> This patch introduces a mechanism that allows architecture backends to
> remove page tables for the crashkernel memory. This can protect the loaded
> kdump kernel from being overwritten by broken kernel code.  Two new
> functions crash_map_reserved_pages() and crash_unmap_reserved_pages() are
> added that can be implemented by architecture code.  The
> crash_map_reserved_pages() function is called before and
> crash_unmap_reserved_pages() after the crashkernel segments are loaded.  The
> functions are also called in crash_shrink_memory() to create/remove page
> tables when the crashkernel memory size is reduced.
> 
> To support architectures that have large pages this patch also introduces
> a new define KEXEC_CRASH_MEM_ALIGN. The crashkernel start and size must 
> always be aligned with KEXEC_CRASH_MEM_ALIGN.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  include/linux/kexec.h |    6 ++++++
>  kernel/kexec.c        |   21 +++++++++++++++++++--
>  2 files changed, 25 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -37,6 +37,10 @@
>  #define KEXEC_CRASH_CONTROL_MEMORY_LIMIT KEXEC_CONTROL_MEMORY_LIMIT
>  #endif
>  
> +#ifndef KEXEC_CRASH_MEM_ALIGN
> +#define KEXEC_CRASH_MEM_ALIGN PAGE_SIZE
> +#endif
> +
>  #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
>  #define KEXEC_CORE_NOTE_NAME "CORE"
>  #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
> @@ -133,6 +137,8 @@ extern void crash_kexec(struct pt_regs *
>  int kexec_should_crash(struct task_struct *);
>  void crash_save_cpu(struct pt_regs *regs, int cpu);
>  void crash_save_vmcoreinfo(void);
> +void crash_map_reserved_pages(void);
> +void crash_unmap_reserved_pages(void);
>  void arch_crash_save_vmcoreinfo(void);
>  void vmcoreinfo_append_str(const char *fmt, ...)
>  	__attribute__ ((format (printf, 1, 2)));
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -999,6 +999,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
>  			kimage_free(xchg(&kexec_crash_image, NULL));
>  			result = kimage_crash_alloc(&image, entry,
>  						     nr_segments, segments);
> +			crash_map_reserved_pages();
>  		}
>  		if (result)
>  			goto out;
> @@ -1015,6 +1016,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
>  				goto out;
>  		}
>  		kimage_terminate(image);
> +		if (flags & KEXEC_ON_CRASH)
> +			crash_unmap_reserved_pages();
>  	}
>  	/* Install the new kernel, and  Uninstall the old */
>  	image = xchg(dest_image, image);
> @@ -1026,6 +1029,18 @@ out:
>  	return result;
>  }
>  
> +/*
> + * Add and remove page tables for crashkernel memory
> + *
> + * Provide an empty default implementation here -- architecture
> + * code may override this
> + */
> +void __weak crash_map_reserved_pages(void)
> +{}
> +
> +void __weak crash_unmap_reserved_pages(void)
> +{}
> +
>  #ifdef CONFIG_COMPAT
>  asmlinkage long compat_sys_kexec_load(unsigned long entry,
>  				unsigned long nr_segments,
> @@ -1134,14 +1149,16 @@ int crash_shrink_memory(unsigned long ne
>  		goto unlock;
>  	}
>  
> -	start = roundup(start, PAGE_SIZE);
> -	end = roundup(start + new_size, PAGE_SIZE);
> +	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
> +	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
>  
> +	crash_map_reserved_pages();
>  	crash_free_reserved_phys_range(end, crashk_res.end);
>  
>  	if ((start == end) && (crashk_res.parent != NULL))
>  		release_resource(&crashk_res);
>  	crashk_res.end = end - 1;
> +	crash_unmap_reserved_pages();
>  
>  unlock:
>  	mutex_unlock(&kexec_mutex);
> 
