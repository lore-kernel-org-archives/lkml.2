Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2HYAtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:49:14 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:2583
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab2HYAtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:49:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9ACXS-02-C6E-02
X-M-MSG: 
Date: Fri, 24 Aug 2012 19:49:04 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120825004859.GB10812@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
 <50381C9D.5070007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50381C9D.5070007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 05:30:21PM -0700, H. Peter Anvin wrote:
> On 08/24/2012 04:55 PM, Jacob Shin wrote:
> >+
> >+	for (i = 0; i < e820.nr_map; i++) {
> >+		struct e820entry *ei = &e820.map[i];
> >+		u64 start = ei->addr;
> >+		u64 end = ei->addr + ei->size;
> >+
> >+		/* we only map E820_RAM */
> >+		if (ei->type != E820_RAM)
> >+			continue;
> >+
> >+		if (end <= ISA_END_ADDRESS)
> >+			continue;
> >+
> >+		if (start <= ISA_END_ADDRESS)
> >+			start = 0;
> >+#ifdef CONFIG_X86_32
> >+		/* on 32 bit, we only map up to max_low_pfn */
> >+		if ((start >> PAGE_SHIFT) >= max_low_pfn)
> >+			continue;
> >+
> >+		if ((end >> PAGE_SHIFT) > max_low_pfn)
> >+			end = max_low_pfn << PAGE_SHIFT;
> >+#endif
> >+		/* the ISA range is always mapped regardless of holes */
> >+		if (!pfn_range_is_mapped(0, ISA_END_ADDRESS << PAGE_SHIFT) &&
> >+		    start != 0)
> >+			init_memory_mapping(0, ISA_END_ADDRESS);
> >+
> >+		init_memory_mapping(start, end);
> >+	}
> >+
> 
> The ISA range mapping doesn't really make sense *inside* the loop,
> no? It seems you could do that before you enter the loop and then
> simply have:
> 
> +		if (end <= ISA_END_ADDRESS)
> +			continue;
> +
> +		if (start <= ISA_END_ADDRESS)
> +			start = ISA_END_ADDRESS;
> 
> ... no?

Right, I think what I was attempting to do was to merge the 1MB
with E820_RAM right above 1MB:

So instead of:

init_memory_mapping(0, 1MB)
init_memory_mapping(1MB, 2GB)

It would be:

init_memory_mapping(0, 2GB)

While taking care of the odd case where there is a gap right after
1MB.

But if its not worth it, I can move it out of the loop.

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 

