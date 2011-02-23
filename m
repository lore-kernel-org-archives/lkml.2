Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1BWU0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:26:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34377 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab1BWU0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:26:20 -0500
Message-ID: <4D656D1A.7030006@kernel.org>
Date: Wed, 23 Feb 2011 12:24:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org>
In-Reply-To: <20110223171945.GI26065@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D656D57.0076,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 09:19 AM, Tejun Heo wrote:
> Hello, guys.
> 
> I've been looking at init_memory_mapping_high() added by commit
> 1411e0ec31 (x86-64, numa: Put pgtable to local node memory) and I got
> curious about several things.
> 
> 1. The only rationale given in the commit description is that a
>    RED-PEN is killed, which was the following.
> 
> 	/*
> 	 * RED-PEN putting page tables only on node 0 could
> 	 * cause a hotspot and fill up ZONE_DMA. The page tables
> 	 * need roughly 0.5KB per GB.
> 	 */
> 
>    This already wasn't true with top-down memblock allocation.
> 
>    The 0.5KB per GiB comment is for 32bit w/ 3 level mapping.  On
>    64bit, it's ~4KiB per GiB when using 2MiB mappings and, well, very
>    small per GiB if 1GiB mapping is used.  Even with 2MiB mapping,
>    1TiB mapping would only be 4MiB.  Under ZONE_DMA, this could be
>    problematic but with top-down this can't be a problem in any
>    realistic way in foreseeable future.

before that patch set:
page table for [0, 4g) is just under and near 512M.
page table for [4g, 128) is just under and near 2g ( assume 0-2g is ram under 4g)

first patch in the patch set will
page table for [0, 4g) is just under and near 2g.( assume 0-2g is ram under 4g)
page table for [4g, 128) is just under and near 128g 

so top down could put most page table on last node.

for debug purpose case, 2M and 1G page could be disabled.

code excerpt from init_memory_mapping()

        printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);

#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
        /*
         * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
         * This will simplify cpa(), which otherwise needs to support splitting
         * large pages into small in interrupt context, etc.
         */
        use_pse = use_gbpages = 0;
#else
        use_pse = cpu_has_pse;
        use_gbpages = direct_gbpages;
#endif


> 
> 2. In most cases, the kernel mapping ends up using 1GiB mappings and
>    when using 1GiB mappings, a single second level table would cover
>    512GiB of memory.  IOW, little, if any, is gained by trying to
>    allocate the page table on node local memory when 1GiB mappings are
>    used, they end up sharing the same page somewhere anyway.
> 
>    I guess this was the reason why the commit message showed usage of
>    2MiB mappings so that each node would end up with their own third
>    level page tables.  Is this something we need to optimize for?  I
>    don't recall seeing recent machines which don't use 1GiB pages for
>    the linear mapping.  Are there NUMA machines which can't use 1GiB
>    mappings?
> 
>    Or was this for the future where we would be using a lot more than
>    512GiB of memory?  If so, wouldn't that be a bit over-reaching?
>    Wouldn't we be likely to have 512GiB mappings if we get to a point
>    where NUMA locality of such mappings actually become a problem?


till now:
amd 64 cpu does support 1gb page.

Intel CPU Nehalem-EX does not. and several vendors do provide 8 sockets
NUMA system with 1024g and 2048g RAM

cpu after Nehalem-EX looks support 1gb page.



> 
> 3. The new code creates linear mapping only for memory regions where
>    e820 actually says there is memory as opposed to mapping from base
>    to top.  Again, I'm not sure what the intention of this change was.
>    Having larger mappings over holes is much cheaper than having to
>    break down the mappings into smaller sized mappings around the
>    holes both in terms of memory and run time overhead.  Why would we
>    want to match the linear address mapping to the e820 map exactly?

we don't need to map those holes if there is any.

for hotplug case, they should map new added memory later.

> 
> Also, Yinghai, can you please try to write commit descriptions with
> more details?  It really sucks for other people when they have to
> guess what the actual changes and underlying intentions are.  The
> commit adding init_memory_mapping_high() is very anemic on details
> about how the behavior changes and the only intention given there is
> RED-PEN removal even which is largely a miss.

i don't know what you are talking about. that changelog is clear enough.

Yinghai
