Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0CZMpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:45:54 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:60668 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab0CZMpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:45:52 -0400
Date: Fri, 26 Mar 2010 13:45:30 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
Message-ID: <20100326124530.GA29222@cmpxchg.org>
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com> <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com> <20100323113551.GA3862@dhcp-lab-161.englab.brq.redhat.com> <4BA98FA8.1040600@kernel.org> <20100324090438.GA7512@dhcp-lab-161.englab.brq.redhat.com> <4BAC6C03.3030801@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAC6C03.3030801@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 01:10:43AM -0700, Yinghai Lu wrote:
> On 03/24/2010 02:04 AM, Stanislaw Gruszka wrote:
> > On Tue, Mar 23, 2010 at 09:06:00PM -0700, Yinghai Lu wrote:
> >> On 03/23/2010 04:35 AM, Stanislaw Gruszka wrote:
> >>> On Sat, Mar 20, 2010 at 11:26:06AM -0700, Yinghai Lu wrote:
> >>>>> After update to 2.6.34-rc1, I was experimented by strange oopses during
> >>>>> boot, what looked like memory corruption. Bisection shows that first bad
> >>>>> commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
> >>>>> support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
> >>>>> system. Not sure what info is need to track down this issue, so please
> >>>>> let me know.
> >>>>
> >>>> can you check patch
> >>>>
> >>>> https://patchwork.kernel.org/patch/87081/
> >>>
> >>> Patch helps somehow. Instead of many random oopses, now I have one and
> >>> the same oops, here is photo:
> >>> http://people.redhat.com/sgruszka/20100322_001.jpg
> >>
> >> how does e820 look like?
> > 
> > dmesg below, I hope everything you asked for is here:
> > 
> > Linux version 2.6.34-rc1 (stasiu@yellow) (gcc version 4.4.2 20091222 (Red Hat 4.4.2-20) (GCC) ) #26 SMP Tue Mar 23 11:31:22 CET 2010
> > BIOS-provided physical RAM map:
> >  BIOS-e820: 0000000000000000 - 0000000000096400 (usable)
> >  BIOS-e820: 0000000000096400 - 00000000000a0000 (reserved)
> >  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> >  BIOS-e820: 0000000000100000 - 00000000cffc2840 (usable)
> >  BIOS-e820: 00000000cffc2840 - 00000000d0000000 (reserved)
> >  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> >  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
> ...
> > initial memory mapped : 0 - 01000000
> > found SMP MP-table at [c00fe700] fe700
> > init_memory_mapping: 0000000000000000-00000000373fe000
> >  0000000000 - 0000400000 page 4k
> >  0000400000 - 0037000000 page 2M
> >  0037000000 - 00373fe000 page 4k
> > kernel direct mapping tables up to 373fe000 @ 7000-d000
> > RAMDISK: 373b8000 - 37fef224
> > Allocated new RAMDISK: 00b2f000 - 01766224
> > Move RAMDISK from 00000000373b8000 - 0000000037fef223 to 00b2f000 - 01766223
> > Reserving 256MB of memory at 32MB for crashkernel (System RAM: 3327MB)
> 
> Please check if this one helps
> 
> Thanks
> 
> Yinghai
> 
> ---
> [PATCH] x86: Make sure free_init_pages() free pages in boundary
> 
> When CONFIG_NO_BOOTMEM, it could use memory more efficient, or more compact.
> 
> Example is:
> Allocated new RAMDISK: 00ec2000 - 0248ce57
> Move RAMDISK from 000000002ea04000 - 000000002ffcee56 to 00ec2000 - 0248ce56
> 
> The new RAMDISK's end is not page aligned.
> Last page could use shared with other user.
> 
> When free_init_pages are called for initrd or .init, the page could be freed
> could have chance to corrupt other data.
> 
> code segment in free_init_pages()
> |        for (; addr < end; addr += PAGE_SIZE) {
> |                ClearPageReserved(virt_to_page(addr));
> |                init_page_count(virt_to_page(addr));
> |                memset((void *)(addr & ~(PAGE_SIZE-1)),
> |                        POISON_FREE_INITMEM, PAGE_SIZE);
> |                free_page(addr);
> |                totalram_pages++;
> |        }
> last half page could be used as one whole free page.
> 
> Try to make the boundaries to be page aligned.

Makes sense to align the addresses, but not in free_init_pages().  The
name says 'pages' and all callers but free_initrd_mem() get it right.

Could you maybe move the fixup to that function instead?

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  arch/x86/mm/init.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/arch/x86/mm/init.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init.c
> +++ linux-2.6/arch/x86/mm/init.c
> @@ -334,6 +334,10 @@ void free_init_pages(char *what, unsigne
>  {
>  	unsigned long addr = begin;
>  
> +	/* Make sure boundaries are page aligned */
> +	addr = PFN_UP(addr) << PAGE_SHIFT;
> +	end = PFN_DOWN(end) << PAGE_SHIFT;
> +
>  	if (addr >= end)
>  		return;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
