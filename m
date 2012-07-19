Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2GSMVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:21:12 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39265 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2GSMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:21:02 -0400
Date: Thu, 19 Jul 2012 14:20:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org, luto@mit.edu,
        yinghai@kernel.org, riel@redhat.com, avi@redhat.com,
        len.brown@intel.com, tj@kernel.org, akpm@linux-foundation.org,
        cl@gentwo.org, borislav.petkov@amd.com, ak@linux.intel.com,
        jbeulich@suse.com, eric.dumazet@gmail.com, akinobu.mita@gmail.com,
        vapier@gentoo.org, cpw@sgi.com, steiner@sgi.com,
        viro@zeniv.linux.org.uk, kamezawa.hiroyu@jp.fujitsu.com,
        rientjes@google.com, aarcange@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 7/9] x86/tlb: enable tlb flush range support for x86
Message-ID: <20120719122057.GA21666@aftab.osrc.amd.com>
References: <1340845344-27557-1-git-send-email-alex.shi@intel.com>
 <1340845344-27557-8-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340845344-27557-8-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 09:02:22AM +0800, Alex Shi wrote:
> Not every tlb_flush execution moment is really need to evacuate all
> TLB entries, like in munmap, just few 'invlpg' is better for whole
> process performance, since it leaves most of TLB entries for later
> accessing.
> 
> This patch also rewrite flush_tlb_range for 2 purposes:
> 1, split it out to get flush_blt_mm_range function.
> 2, clean up to reduce line breaking, thanks for Borislav's input.
> 
> My micro benchmark 'mummap' http://lkml.org/lkml/2012/5/17/59
> show that the random memory access on other CPU has 0~50% speed up
> on a 2P * 4cores * HT NHM EP while do 'munmap'.
> 
> Thanks Yongjie's testing on this patch:
> -------------
> I used Linux 3.4-RC6 w/ and w/o his patches as Xen dom0 and guest
> kernel.
> After running two benchmarks in Xen HVM guest, I found his patches
> brought about 1%~3% performance gain in 'kernel build' and 'netperf'
> testing, though the performance gain was not very stable in 'kernel
> build' testing.
> 
> Some detailed testing results are below.
> 
> Testing Environment:
> 	Hardware: Romley-EP platform
> 	Xen version: latest upstream
> 	Linux kernel: 3.4-RC6
> 	Guest vCPU number: 8
> 	NIC: Intel 82599 (10GB bandwidth)
> 
> In 'kernel build' testing in guest:
> 	Command line  |  performance gain
>     make -j 4      |    3.81%
>     make -j 8      |    0.37%
>     make -j 16     |    -0.52%
> 
> In 'netperf' testing, we tested TCP_STREAM with default socket size
> 16384 byte as large packet and 64 byte as small packet.
> I used several clients to add networking pressure, then 'netperf' server
> automatically generated several threads to response them.
> I also used large-size packet and small-size packet in the testing.
> 	Packet size  |  Thread number | performance gain
> 	16384 bytes  |      4       |   0.02%
> 	16384 bytes  |      8       |   2.21%
> 	16384 bytes  |      16      |   2.04%
> 	64 bytes     |      4       |   1.07%
> 	64 bytes     |      8       |   3.31%
> 	64 bytes     |      16      |   0.71%
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Tested-by: Ren, Yongjie <yongjie.ren@intel.com>
> ---
>  arch/x86/include/asm/tlb.h      |    9 +++-
>  arch/x86/include/asm/tlbflush.h |   17 +++++-
>  arch/x86/mm/tlb.c               |  112 ++++++++++++++++-----------------------
>  3 files changed, 68 insertions(+), 70 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 829215f..4fef207 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h
> @@ -4,7 +4,14 @@
>  #define tlb_start_vma(tlb, vma) do { } while (0)
>  #define tlb_end_vma(tlb, vma) do { } while (0)
>  #define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
> -#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
> +
> +#define tlb_flush(tlb)							\
> +{									\
> +	if (tlb->fullmm == 0)						\
> +		flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end, 0UL);	\
> +	else								\
> +		flush_tlb_mm_range(tlb->mm, 0UL, TLB_FLUSH_ALL, 0UL);	\
> +}
>  
>  #include <asm-generic/tlb.h>
>  
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index 33608d9..621b959 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -105,6 +105,13 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
>  		__flush_tlb();
>  }
>  
> +static inline void flush_tlb_mm_range(struct vm_area_struct *vma,
> +	   unsigned long start, unsigned long end, unsigned long vmflag)
> +{
> +	if (vma->vm_mm == current->active_mm)
> +		__flush_tlb();
> +}

There's a problem with this in one of my randconfig tests. It has
!CONFIG_SMP and the warning is:

mm/memory.c: In function ‘tlb_flush_mmu’:
mm/memory.c:230:2: warning: passing argument 1 of ‘flush_tlb_mm_range’ from incompatible pointer type
/usr/src/linux-2.6/arch/x86/include/asm/tlbflush.h:108:20: note: expected ‘struct vm_area_struct *’ but argument is of type ‘struct mm_struct *’
mm/memory.c:230:2: warning: passing argument 1 of ‘flush_tlb_mm_range’ from incompatible pointer type
/usr/src/linux-2.6/arch/x86/include/asm/tlbflush.h:108:20: note: expected ‘struct vm_area_struct *’ but argument is of type ‘struct mm_struct *’


Due to the fact that the macro flush_tlb actually resolves to
flush_tlb_mm_range and this function has a different signature based on
CONFIG_SMP. On !SMP expects struct vm_area_struct * as a first argument
but on SMP its first argument is struct mm_struct *.

So two different function signatures based on a config option? Now
that's a first. What is going on?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
