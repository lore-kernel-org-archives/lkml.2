Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3AHCtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:49:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27708 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3AHCtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:49:10 -0500
Date: Mon, 7 Jan 2013 21:48:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130108024830.GE9865@phenom.dumpdata.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-27-git-send-email-yinghai@kernel.org>
 <CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
 <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
 <CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
 <CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
 <20130107152622.GD3219@phenom.dumpdata.com>
 <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
 <8762382z2c.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762382z2c.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 06:22:51PM -0800, Eric W. Biederman wrote:
> Shuah Khan <shuahkhan@gmail.com> writes:
> 
> > On Mon, Jan 7, 2013 at 8:26 AM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> >> On Fri, Jan 04, 2013 at 02:10:25PM -0800, Yinghai Lu wrote:
> >>> On Fri, Jan 4, 2013 at 1:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> >>> > Pani'cing the system doesn't sound like a good option to me in this
> >>> > case. This change to disable swiotlb is made for kdump. However, with
> >>> > this change several system fail to boot, unless crashkernel_low=72M is
> >>> > specified.
> >>>
> >>> this patchset is new feature to put second kdump kernel above 4G.
> >>>
> >>> >
> >>> > I would the say the right approach to solve this would be to not
> >>> > change the current pci_swiotlb_detect_override() behavior and treat
> >>> > swiotlb =1 upon entry equivalent to swiotlb_force set.
> >>>
> >>> that will make intel system have to take crashkernel_low=72M too.
> >>> otherwise intel system will get panic during swiotlb allocation.
> >>
> >> Two things:
> >>
> >>  1). You need to wrap the 'is_enough_..' in CONFIG_KEXEC, which means
> >>     that the function needs to go in a header file.
> >>  2). The check for 1MB is suspect. Why only 1MB? You mentioned it is
> >>      b/c of crashkernel_low=72M (which I am not seeing in v3.8 kernel-parameters.txt?
> >>      Is that part of your mega-patchset?). Anyhow, there seems to be a disconnect -
> >>      what if the user supplied crashkernel_low=27M? Perhaps the 'is_enough'
> >>      should also parse the bootparams to double-check that there is enough
> >>      low-mem space? But then if the kernel grows then 72M might not be enough -
> >>      you might need 82M with 3.9.
> >>
> >>      Perhaps a better way for this is to do:
> >>         1). Change 'is_enough' to check only for 4MB.
> >>         2). When booting as kexec, the SWIOTLB would only use 4MB instead of 64MB?
> >>
> >>      Or, we could also use the post-late SWIOTLB initialization similiary to how it was
> >>      done on ia64. This would mean that the AMD VI code would just call the
> >>      .. something like this - NOT tested or even compile tested:
> >>
> >> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> >> index c1c74e0..e7fa8f7 100644
> >> --- a/drivers/iommu/amd_iommu.c
> >> +++ b/drivers/iommu/amd_iommu.c
> >> @@ -3173,6 +3173,24 @@ int __init amd_iommu_init_dma_ops(void)
> >>         if (unhandled && max_pfn > MAX_DMA32_PFN) {
> >>                 /* There are unhandled devices - initialize swiotlb for them */
> >>                 swiotlb = 1;
> >> +               /* Late (so no bootmem allocator) usage and only if the early SWIOTLB
> >> +                * hadn't been allocated (which can happen on kexec kernels booted
> >> +                * above 4GB). */
> >> +               if (!swiotlb_nr_tbl()) {
> >> +                       int retry = 3;
> >> +                       int mb_size = 64;
> >> +                       int rc = 0;
> >> +retry_me:
> >> +                       if (retry < 0)
> >> +                               panic("We tried setting %dMB for SWIOTLB but got -ENOMEM", mb_size << 1);
> >> +                       rc = swiotlb_late_init_with_default_size(mb_size * (1<<20));
> >> +                       if (rc) {
> >> +                               retry --;
> >> +                               mb_size >> 1;
> >> +                               goto retry_me;
> >> +                       }
> >> +                       dma_ops = &swiotlb_dma_ops;
> >> +               }
> >>         }
> >>
> >>         amd_iommu_stats_init();
> >>
> >> And then the early SWIOTLB initialization for 64MB can fail and we are still OK.
> >>>
> >
> > Yinghai/Konrad,
> >
> > Did more testing. btw this patch depends on your [v7u1,25/31]
> > memblock: add memblock_mem_size(). Here are the test results:
> >
> > 1. When there is not enough memory: (enough_mem_for_swiotlb() returns false)
> > system will panic in amd_iommu_init_dma_ops().
> >
> > 2. When there is enough memory: (enough_mem_for_swiotlb() returns true):
> > swiotlb is reserved
> > pci_swiotlb_late_init() leaves the buffer allocated since swiotlb=1
> > with that getting changed in amd_iommu_init_dma_ops().
> >
> > I agree with Konrad that the logic should be wrapped in CONFIG_KEXEC.
> 
> If enough_mem_for_swiotlb needs to be conditional on CONFIG_KEXEC the
> code is architected wrong.  None of this logic has anything to do with
> kexec except that the kexec path is one way to get this condition to
> happen.  Especially since the kexec'd kernel where this condition occurs
> does not need kexec support built in.

Fair enough - with the 'memmap' command line options one can trigger
this.
> 
> Yinghai I sat down and read your patch and the approach you are taking
> is totally wrong.
> 
> The problem is that swiotlb_init() in lib/swiotlb.c does not know how to
> fail without panic'ing the system.
> 
> Which leaves two valid approaches.
> - Create a variant of swiotlb_init that can fail for use on x86 and
>   handle the failure.

As an safe-fail step we could retry with an smaller size until a fit is found.

> - Delay initializing the swiotlb until someone actually needs a mapping
>   from it.  

So late init the SWIOTLB and perhaps have multiple "segments" of 4MB
of SWIOTLB that can grow as we exhaust its memory. Could work.
> 
> Delaying the initialization of the swiotlb is out because the code
> needs an early memory allocation to get a large chunk of contiguous
> memory for the bounce buffers.

Or it can use the late init, but with a smaller chunk of memory.

> 
> Which means the panics that occurr in swiotlb_init() need to be delayed
> until someone something actually needs bounce buffers from the swiotlb.
> 
> Although arguably what should actually happen instead of panic() is that
> swiotlb_map_single should simply fail early when it was not possible to
> preallocate bounce buffers.

This sounds like a Catch-22. Fail early implies that it would have to do
this when using the bootmem allocator. But the swiotlb_map_single is not
called at that time - it is called _after_ the bootmem allocator has been
de-activated. Actually it is called pretty late - when built-in PCI devices
start off or when 'udev' starts scanning the PCI bus and loading modules.

I think I am misunderstanding you - could you clarify please?

