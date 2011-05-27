Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1E0PhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:37:16 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34238 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1E0PhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:37:13 -0400
Date: Fri, 27 May 2011 21:07:00 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        crash-utility@redhat.com, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        anderson@redhat.com, Wang Chao <wang.chao@cn.fujitsu.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: [RFC Patch 6/6] Crash: Recognise slim coredumps and process
 new elf-note sections
Message-ID: <20110527153700.GA13007@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172618.GB18295@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526172618.GB18295@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-26 22:56:18 Thu, K.Prasad wrote:
> 
> Crash: Recognise slim coredumps and process new elf-note sections
> 
> The Linux kernel will begin to support SlimDump for certain types of crashes
> and the 'crash' tool needs to recognise them. For these types of coredumps, it
> need not lookout for usual elf-structures and start gdb. Also process new
> elf-note sections that contain additional information about the crash.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  diskdump.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  netdump.c  |    8 +++++
>  x86.h      |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 183 insertions(+)
> 
> Index: crash-5.1.5.slim_kdump/x86.h
> ===================================================================
> --- /dev/null
> +++ crash-5.1.5.slim_kdump/x86.h
> @@ -0,0 +1,91 @@
> +/*
> + * x86.h - x86 Architecture specific definitions
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2011
> + *
> + * Author: K.Prasad <prasad@linux.vnet.ibm.com>
> + */
> +
> +typedef unsigned long long u64;
> +typedef unsigned int u32;
> +typedef unsigned short u16;
> +typedef unsigned char u8;
> +
> +#define __u64 u64
> +#define __u32 u32
> +#define __u16 u16
> +#define __u8  u8
> +
> +/* Mask for finding the address mode in IA32_MCi_MISC[8:6] register */
> +#define MCI_MISC_ADDR_MODE	0X1C0
> +/* Number of bits to shift the IA32_MCi_MISC to read the address-mode bits */
> +#define MISC_ADDR_MODE_POS	6
> +
> +/* Address Modes in IA32_MCi_MISC[8:6] */
> +#define MCM_ADDR_SEGOFF  0      /* segment offset */
> +#define MCM_ADDR_LINEAR  1      /* linear address */
> +#define MCM_ADDR_PHYS    2      /* physical address */
> +#define MCM_ADDR_MEM     3      /* memory address */
> +#define MCM_ADDR_GENERIC 7      /* generic */
> +
> +#define MCI_STATUS_MISCV (1ULL<<59)  /* misc error reg. valid */
> +#define MCI_STATUS_ADDRV (1ULL<<58)  /* addr reg. valid */
> +
> +#define PAGE_SHIFT 12
> +
> +static const char *mce_addr_mode[] =
> +{
> +	"Segment offset",	/* MCM_ADDR_SEGOFF */
> +	"Linear address",	/* MCM_ADDR_LINEAR */
> +	"Physical address",	/* MCM_ADDR_PHYS */
> +	"Memory address",	/* MCM_ADDR_MEM */
> +	"",			/* reserved */
> +	"",			/* reserved */
> +	"",			/* reserved */
> +	"Generic"		/* MCM_ADDR_GENERIC */
> +};
> +
> +/*
> + * kernel structure: Keep this in sync with the definition in
> + * arch/x86/include/asm/mce.h of linux source code.
> + *
> + * Fields are zero when not available
> + *
> + */
> +struct mce {
> +	__u64 status;
> +	__u64 misc;
> +	__u64 addr;
> +	__u64 mcgstatus;
> +	__u64 ip;
> +	__u64 tsc;	/* cpu time stamp counter */
> +	__u64 time;	/* wall time_t when error was detected */
> +	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
> +	__u8  pad1;
> +	__u16 pad2;
> +	__u32 cpuid;	/* CPUID 1 EAX */
> +	__u8  cs;		/* code segment */
> +	__u8  bank;	/* machine check bank */
> +	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
> +	__u8  finished;   /* entry is valid */
> +	__u32 extcpu;	/* linux cpu number that detected the error */
> +	__u32 socketid;	/* CPU socket ID */
> +	__u32 apicid;	/* CPU initial apic ID */
> +	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
> +	__u64 aux0;
> +	__u64 aux1;
> +};
> Index: crash-5.1.5.slim_kdump/netdump.c
> ===================================================================
> --- crash-5.1.5.slim_kdump.orig/netdump.c
> +++ crash-5.1.5.slim_kdump/netdump.c
> @@ -331,6 +331,10 @@ is_netdump(char *file, ulong source_quer
>  		}
>          	nd->notes32 = (Elf32_Phdr *)
>  		    &nd->elf_header[sizeof(Elf32_Ehdr)];
> +		if (machdep->process_elf_notes)
> +			machdep->process_elf_notes((char *)nd->elf32 +
> +							nd->notes32->p_offset,
> +							nd->notes32->p_filesz);
>          	nd->load32 = (Elf32_Phdr *)
>  		    &nd->elf_header[sizeof(Elf32_Ehdr)+sizeof(Elf32_Phdr)];
>  		if (DUMPFILE_FORMAT(nd->flags) == NETDUMP_ELF32)
> @@ -360,6 +364,10 @@ is_netdump(char *file, ulong source_quer
>                  }
>                  nd->notes64 = (Elf64_Phdr *)
>                      &nd->elf_header[sizeof(Elf64_Ehdr)];
> +		if (machdep->process_elf_notes)
> +			machdep->process_elf_notes((char *)nd->elf64 +
> +							nd->notes64->p_offset,
> +							nd->notes64->p_filesz);

Now that machdep->process_elf_notes() is invoked in generic KDUMP
processing code path, please remove the separate invocation of
machdep->dumpfile_init() which was introduced for s390x architecture in
dump_Elf64_Nhdr() function. The reason is, machdep->process_elf_notes()
on s390x internally invokes machdep->dumpfile_init(). Hence we can
safely remove it.

>                  nd->load64 = (Elf64_Phdr *)
>                      &nd->elf_header[sizeof(Elf64_Ehdr)+sizeof(Elf64_Phdr)];
>  		if (DUMPFILE_FORMAT(nd->flags) == NETDUMP_ELF64)
> Index: crash-5.1.5.slim_kdump/diskdump.c
> ===================================================================
> --- crash-5.1.5.slim_kdump.orig/diskdump.c
> +++ crash-5.1.5.slim_kdump/diskdump.c
> @@ -231,6 +231,27 @@ open_dump_file(char *file)
>  	dd->dfd = fd;
>  	return TRUE;
>  }
> +#if defined(X86_64) || defined(X86)
> +#include "x86.h"
> +
> +/*
> + * Check if the address reported by the CPU is in a format we can parse.
> + * It would be possible to add code for most other cases, but all would
> + * be somewhat complicated (e.g. segment offset would require an instruction
> + * parser). So only support physical addresses up to page granuality for now.
> + *
> + * Function derived from arch/x86/kernel/cpu/mcheck/mce.c in Linux source
> + *
> + */
> +static int mce_usable_address(struct mce *m)
> +{
> +	if (!(m->status & MCI_STATUS_MISCV) || !(m->status & MCI_STATUS_ADDRV))
> +		return 0;
> +	if ((m->misc & 0x3f) > PAGE_SHIFT)
> +		return 0;
> +	return 1;
> +}
> +#endif /* defined(X86_64) || defined(X86) */
> 
>  void 
>  x86_process_elf_notes(void *note_ptr, unsigned long size_note)
> @@ -239,10 +260,43 @@ x86_process_elf_notes(void *note_ptr, un
>  	Elf64_Nhdr *note64 = NULL;
>  	size_t tot, len = 0;
>  	int num = 0;
> +#if defined(X86_64) || defined(X86)
> +	struct mce *mce;
> +	ushort addr_mode;
> +#endif /* defined(X86_64) || defined(X86) */
> 
>  	for (tot = 0; tot < size_note; tot += len) {
>  		if (machine_type("X86_64")) {
>  			note64 = note_ptr + tot;
> +#ifdef X86_64
> +			/*
> +			 * If vmcore is generated due to fatal Machine Check
> +			 * Exception, we only have a 'slim' crashdump. Don't
> +			 * analyse further, inform the user about it and exit.
> +			 */
> +			if (note64->n_type == NT_MCE) {
> +				fprintf(fp, "\"System crashed due to a hardware"
> +					" memory error. No coredump"
> +					" available.\"\n");
> +
> +				/* Do we have a copy of 'struct mce'? */
> +				if (note64->n_descsz == 0)
> +					goto exit;
> +
> +				mce = (struct mce *)((char *)note64 +
> +					sizeof(Elf64_Nhdr) + note64->n_namesz);
> +				if (!mce_usable_address(mce))
> +					goto exit;
> +
> +				addr_mode = (mce->misc >> MISC_ADDR_MODE_POS) &
> +						MCI_MISC_ADDR_MODE;
> +				fprintf(fp, "Memory error occured at %llx "
> +					"(address type: %s\n)", mce->addr,
> +					mce_addr_mode[addr_mode]);
> +exit:
> +				clean_exit(0);
> +			}
> +#endif /* X86_64 */

The function x86_process_elf_notes() is invoked through
machdep->process_elf_notes function pointer, which makes it arch
dependent code. How about moving this function (x86_process_elf_notes)
to an arch dependent file say x86_common.c ? By doing so we can get rid of
all "#ifdefs" here.

Hi Dave, what do you say?

> 
>  			if (note64->n_type == NT_PRSTATUS) {
>  				dd->nt_prstatus_percpu[num] = note64;
> @@ -255,6 +309,36 @@ x86_process_elf_notes(void *note_ptr, un
>  		} else if (machine_type("X86")) {
>  			note32 = note_ptr + tot;
> 
> +#ifdef X86
> +			/*
> +			 * If vmcore is generated due to fatal Machine Check
> +			 * Exception, we only have a 'slim' crashdump. Don't
> +			 * analyse further, inform the user about it and exit.
> +			 */
> +			if (note32->n_type == NT_MCE) {
> +				fprintf(fp, "\"System crashed due to a hardware"
> +					" memory error. No coredump"
> +					" available.\"\n");
> +
> +				/* Do we have a copy of 'struct mce'? */
> +				if (note32->n_descsz == 0)
> +					goto exit;
> +
> +				mce = (struct mce *)((char *)note32 +
> +					sizeof(Elf32_Nhdr) + note32->n_namesz);
> +				if (!mce_usable_address(mce))
> +					goto exit;
> +
> +				addr_mode = (mce->misc >> MISC_ADDR_MODE_POS) &
> +						MCI_MISC_ADDR_MODE;
> +				fprintf(fp, "Memory error occured at %llx "
> +					"(address type: %s\n)", mce->addr,
> +					mce_addr_mode[addr_mode]);
> +exit:
> +				clean_exit(0);
> +			}
> +#endif /* X86 */
> +
>  			if (note32->n_type == NT_PRSTATUS) {
>  				dd->nt_prstatus_percpu[num] = note32;
>  				num++;

-- 
Mahesh J Salgaonkar
