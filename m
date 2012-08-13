Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2HMOcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:32:09 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3037 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab2HMOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:32:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI103dK1432I853kzz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah)
X-WSS-ID: 0M8P71E-01-RW1-02
X-M-MSG: 
Date: Mon, 13 Aug 2012 09:31:59 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 1/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120813143159.GB8441@jshin-Toonie>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-2-git-send-email-jacob.shin@amd.com>
 <20120811194948.GC2874@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120811194948.GC2874@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 12:49:48PM -0700, Tejun Heo wrote:
> Hello, Jacob.

Hi,

> 
> On Thu, Aug 09, 2012 at 04:23:05PM -0500, Jacob Shin wrote:
> > +struct range pfn_mapped[E820_X_MAX];
> > +int nr_pfn_mapped;
> 
> Why aren't these __initdata?  Are they gonna be used for other
> purposes?

Yes, the thought was that later code may want to know what pfns are direct
mapped or not. For example, memory hotplug has to call init_memory_mapping and
updates direct mapping.

> 
> > +void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
> > +{
> > +	nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
> > +					     nr_pfn_mapped, start_pfn, end_pfn);
> > +
> > +	if (end_pfn > max_pfn_mapped)
> > +		max_pfn_mapped = end_pfn;
> 
> Maybe use max()?

Okay,

> 
> > +	if ((end_pfn <= (1UL << (32 - PAGE_SHIFT))) &&
> > +	    (end_pfn > max_low_pfn_mapped))
> > +		max_low_pfn_mapped = end_pfn;
> > +}
> > +
> > +int pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
> 
> bool?

Okay, will change to bool.

> 
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr_pfn_mapped; i++)
> > +		if ((start_pfn >= pfn_mapped[i].start) &&
> > +		    (end_pfn <= pfn_mapped[i].end))
> > +			break;
> > +
> > +	return i < nr_pfn_mapped;
> > +}
> 
> 	for (...)
> 		if (xxx)
> 			return true;
> 	return false;
> 
> > +int pfn_is_mapped(unsigned long pfn)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr_pfn_mapped; i++)
> > +		if ((pfn >= pfn_mapped[i].start) &&
> > +		    (pfn <  pfn_mapped[i].end))
> > +			break;
> > +
> > +	return i < nr_pfn_mapped;
> > +}
> 
> How about...
> 
> 	return pfn_range_is_mapped(pfn, pfn + 1);

Okay,

> 
> > @@ -913,14 +958,40 @@ void __init setup_arch(char **cmdline_p)
> >  
> >  	init_gbpages();
> >  
> > -	/* max_pfn_mapped is updated here */
> > -	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> > -	max_pfn_mapped = max_low_pfn_mapped;
> > +	init_pfn = max_pfn_mapped;
> > +
> > +	memset(pfn_mapped, 0, sizeof(pfn_mapped));
> > +	nr_pfn_mapped = 0;
> 
> Are these necessary?  We clear .bss way before control reaches here.

Ah okay, I'll remove them, and test to double check.

> 
> > +
> > +	add_pfn_range_mapped(0, max_pfn_mapped);
> > +
> > +	for (i = 0; i < e820.nr_map; i++) {
> > +		struct e820entry *ei = &e820.map[i];
> > +		u64 start = ei->addr;
> > +		u64 end = ei->addr + ei->size;
> > +
> > +		if (ei->type != E820_RAM)
> > +			continue;
> > +
> > +		if (end <= (init_pfn << PAGE_SHIFT))
> > +			continue;
> > +
> > +		if (start < (init_pfn << PAGE_SHIFT))
> > +			start = init_pfn << PAGE_SHIFT;
> > +
> > +#ifdef CONFIG_X86_32
> > +		if ((start >> PAGE_SHIFT) >= max_low_pfn)
> > +			continue;
> > +
> > +		if ((end >> PAGE_SHIFT) > max_low_pfn)
> > +			end = max_low_pfn << PAGE_SHIFT;
> > +#endif
> > +		pfn = init_memory_mapping(start, end);
> > +		add_pfn_range_mapped(start >> PAGE_SHIFT, pfn);
> > +	}
> 
> Some comments please?  Also, while this may be the right thing to do,
> if I'm not mistaken, this is also likely to make linear space to use
> smaller mappings depending on how the physical memory is laid out,
> which could be a trade off we're willing to make, but that *should* be
> explicit.  Please describe what's going on and provide rationale.

Ah .. okay, so you are concerned about BIOSes with E820 that break up a
large linear memory range into 2 different E820 entries? But if I'm not
mistaken, the E820 code does some cleansing of the values it gets from
the BIOS, in arch/x86/kernel/e820.c: sanitize_e820_map

But yes, I'll add comments, as well as break this logic out to its own
function as Yinghai suggested.

Thanks!

-Jacob

> 
> Thanks.
> 
> -- 
> tejun
> 

