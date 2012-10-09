Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2JIHWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:22:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:61257 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2JIHWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,558,1344236400"; 
   d="scan'208";a="231584499"
Message-ID: <5073D0C1.4020606@zytor.com>
Date: Tue, 09 Oct 2012 15:22:41 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 08/10] x86, xen, mm: fix mapping_pagetable_reserve logic
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org> <1349757558-10856-9-git-send-email-yinghai@kernel.org> <5073C05E.5020402@zytor.com> <CAE9FiQXa9fqLOyqzap6o_0HA=oBRKqkcWm9bdpK9M6R5cQMU-A@mail.gmail.com>
In-Reply-To: <CAE9FiQXa9fqLOyqzap6o_0HA=oBRKqkcWm9bdpK9M6R5cQMU-A@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 02:33 PM, Yinghai Lu wrote:
>>
>> make_range_readwrite is particularly toxic, though, because it makes it
>> sound like it something along the lines of set_memory_rw(), which it
>> most distinctly is not.
> 
> it just change some page range from RO back to RW.
> 
> so how about update_range_ro_to_rw?
> 

You're focusing on what the low-level mechanics of one particular
implementation (Xen) of the hook, and then try to make it describe the
hook itself.

What the hook does, if I am reading it correctly, is take a range that
used to be page tables and turn it back to "ordinary memory".  As such,
assuming I'm following the logic correctly, something like
pagetable_unreserve() seems like a reasonable name.

However, why during initialization, why do we have to unreserve memory
that has already been reserved for pagetables?  (Keep in mind there may
very well be an entirely sensible answer for that question -- I just
can't tell from the patchset without a much more in-depth analysis.
Keep in mind that that in-depth analysis sucks up time, and it doesn't
scale to expect the maintainer to have to do that.)

>>
>> Magic variables augmented with more magic variables.  Why?  This also
>> seems to assume that we still do all the kernel page tables in one
>> chunk, which is exactly what we don't want to do.
> 
> for 64bit, page table will be three parts
> 1. initial page table from arch/x86/kernel/head_64.S
> 2. page table from BRK.
> 3. page near end of RAM.
> 
> verified from /sys/kernel/debug/kernel_page_tables
> 
> only range E820_RAM is mapped.
> 
> all initial page table for hole between [0, 1G) get cleared too.
> 

No, this is wrong, and more importantly, your choice of data structures
encode this.  There should not be any requirement for the page tables
near the end of RAM to be contiguous -- consider the case of a memory
hole near the end of RAM, or a large-memory machine where memory is
highly discontiguous and we have to use more than one chunk before we
run out.  Then the questions become:

1. do we *have* to have this tracking at all?  Obviously we have to know
this memory is in use, but memblock reserve should take care of that.

2. if we do, please use a data structure which can handle an arbitrary
number of ranges.

	-hpa
