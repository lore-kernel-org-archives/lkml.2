Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab1IITa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759852Ab1IITaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:30:24 -0400
Date: Fri, 9 Sep 2011 15:30:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Huang Ying <ying.huang@intel.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [RFC][patch 1/2] kdump: Add infrastructure for unmapping
 crashkernel memory
Message-ID: <20110909193008.GE15748@redhat.com>
References: <20110908132609.177038405@linux.vnet.ibm.com>
 <20110908132652.189920773@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908132652.189920773@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 03:26:10PM +0200, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> This patch introduces a mechanism that allows architecture backends to
> remove page tables for the crashkernel memory. This can protect the loaded
> kdump kernel from being overwritten by broken kernel code.
> A new function crash_map_pages() is added that can be implemented by
> architecture code. This function has the following syntax:
> 
> void crash_map_pages(int enable);

CCing Huang Ying. I am not sure if preserve context thing will be impacted
by this in anyway.

Hyuang,

While I am looking at x86 code, I had a question. gitblame tells you
changed that code last, so here I go.

What is init_transition_pgtable() and why do we need it. I see that 
init_pgtable() sets up identity mapped page table from 0 to max_pfn.
Code running in control page (identity_mapped onwards) will make use
of identity mapped page tables. Then I see that init_transition_pgtable()
goes ahead and seems to be modifying identity mapped page tables to
map address relocate_kernel to control code physical address. Why
do we have to do that?

Thanks
Vivek

> 
> "enable" can be 0 for removing or 1 for adding page tables.  The function is
> called before and after the crashkernel segments are loaded. It is also
> called in crash_shrink_memory() to create new page tables when the
> crashkernel memory size is reduced.
> 
> To support architectures that have large pages this patch also introduces
> a new define KEXEC_CRASH_MEM_ALIGN. The crashkernel start and size must 
> always be aligned with KEXEC_CRASH_MEM_ALIGN.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  include/linux/kexec.h |    5 +++++
>  kernel/kexec.c        |   16 ++++++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
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
> @@ -133,6 +137,7 @@ extern void crash_kexec(struct pt_regs *
>  int kexec_should_crash(struct task_struct *);
>  void crash_save_cpu(struct pt_regs *regs, int cpu);
>  void crash_save_vmcoreinfo(void);
> +void crash_map_pages(int enable);
>  void arch_crash_save_vmcoreinfo(void);
>  void vmcoreinfo_append_str(const char *fmt, ...)
>  	__attribute__ ((format (printf, 1, 2)));
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -999,6 +999,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
>  			kimage_free(xchg(&kexec_crash_image, NULL));
>  			result = kimage_crash_alloc(&image, entry,
>  						     nr_segments, segments);
> +			crash_map_pages(1);
>  		}
>  		if (result)
>  			goto out;
> @@ -1015,6 +1016,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
>  				goto out;
>  		}
>  		kimage_terminate(image);
> +		if (flags & KEXEC_ON_CRASH)
> +			crash_map_pages(0);
>  	}
>  	/* Install the new kernel, and  Uninstall the old */
>  	image = xchg(dest_image, image);
> @@ -1026,6 +1029,13 @@ out:
>  	return result;
>  }
>  
> +/*
> + * provide an empty default implementation here -- architecture
> + * code may override this
> + */
> +void __weak crash_map_pages(int enable)
> +{}
> +
>  #ifdef CONFIG_COMPAT
>  asmlinkage long compat_sys_kexec_load(unsigned long entry,
>  				unsigned long nr_segments,
> @@ -1134,14 +1144,16 @@ int crash_shrink_memory(unsigned long ne
>  		goto unlock;
>  	}
>  
> -	start = roundup(start, PAGE_SIZE);
> -	end = roundup(start + new_size, PAGE_SIZE);
> +	start = roundup(start, KEXEC_CRASH_MEM_ALIGN);
> +	end = roundup(start + new_size, KEXEC_CRASH_MEM_ALIGN);
>  
> +	crash_map_pages(1);
>  	crash_free_reserved_phys_range(end, crashk_res.end);
>  
>  	if ((start == end) && (crashk_res.parent != NULL))
>  		release_resource(&crashk_res);
>  	crashk_res.end = end - 1;
> +	crash_map_pages(0);
>  
>  unlock:
>  	mutex_unlock(&kexec_mutex);
