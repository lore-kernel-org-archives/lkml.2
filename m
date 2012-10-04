Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2JDVxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:53:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab2JDVxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:53:00 -0400
Message-ID: <506E052D.7060101@zytor.com>
Date: Thu, 04 Oct 2012 14:52:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <20121003165105.GA30214@jshin-Toonie> <20121004135646.GE9158@phenom.dumpdata.com>
In-Reply-To: <20121004135646.GE9158@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 06:56 AM, Konrad Rzeszutek Wilk wrote:
>
> What Peter had in mind is a nice system where we get rid of
> this linear allocation of page-tables (so pgt_buf_start -> pgt_buf
> _end are linearly allocated). His thinking (and Peter if I mess
> up please correct me), is that we can stick the various pagetables
> in different spots in memory. Mainly that as we look at mapping
> a region (say 0GB->1GB), we look at in chunks (2MB?) and allocate
> a page-table at the _end_ of the newly mapped chunk if we have
> filled all entries in said pagetable.
>
> For simplicity, lets say we are just dealing with PTE tables and
> we are mapping the region 0GB->1GB with 4KB pages.
>
> First we stick a page-table (or if there is a found one reuse it)
> at the start of the region (so 0-2MB).
>
> 0MB.......................2MB
> /-----\
> |PTE_A|
> \-----/
>
> The PTE entries in it will cover 0->2MB (PTE table #A) and once it is
> finished, it will stick a new pagetable at the end of the 2MB region:
>
> 0MB.......................2MB...........................4MB
> /-----\                /-----\
> |PTE_A|                |PTE_B|
> \-----/                \-----/
>
>
> The PTE_B page table will be used to map 2MB->4MB.
>
> Once that is finished .. we repeat the cycle.
>
> That should remove the utter duct-tape madness and make this a lot
> easier.
>

You got the basic idea right but the details slightly wrong.  Let me try 
to explain.

When we start up, we know we have a set of page tables which maps the 
kernel text, data, bss and brk.  This is set up by the startup code on 
native and by the domain builder on Xen.

We can reserve an arbitrary chunk of brk that is (a) big enough to map 
the kernel text+data+bss+brk itself plus (b) some arbitrary additional 
chunk of memory (perhaps we reserve another 256K of brk or so, enough to 
map 128 MB in the worst case of 4K PAE pages.)

Step 1:

- Create page table mappings for kernel text+data+bss+brk out of the
   brk region.

Step 2:

- Start creating mappings for the topmost memory region downward, until
   the brk reserved area is exhaused.

Step 3:

- Call a paravirt hook on the page tables created so far.  On native
   this does nothing, on Xen it can map it readonly and tell the
   hypervisor it is a page table.

Step 4:

- Switch to the newly created page table.  The bootup page table is now
   obsolete.

Step 5:

- Moving downward from the last address mapped, create new page tables
   for any additional unmapped memory region until either we run out of
   unmapped memory regions, or we run out of mapped memory for
   the memory regions to map.

Step 6:

- Call the paravirt hook for the new page tables, then add them to the
   page table tree.

Step 7:

- Repeat from step 5 until there are no more unmapped memory regions.


This:

a) removes any need to guesstimate how much page tables are going to
    consume.  We simply construct them; they may not be contiguous but
    that's okay.

b) very cleanly solves the Xen problem of not wanting to status-flip
    pages any more than necessary.


The only reason for moving downward rather than upward is that we want 
the page tables as high as possible in memory, since memory at low 
addresses is precious (for stupid DMA devices, for things like 
kexec/kdump, and so on.)

	-hpa





-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

