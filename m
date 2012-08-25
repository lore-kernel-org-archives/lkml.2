Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2HYAaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40845 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab2HYAa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:30:27 -0400
Message-ID: <50381C9D.5070007@zytor.com>
Date: Fri, 24 Aug 2012 17:30:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com> <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
In-Reply-To: <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 04:55 PM, Jacob Shin wrote:
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +		u64 start = ei->addr;
> +		u64 end = ei->addr + ei->size;
> +
> +		/* we only map E820_RAM */
> +		if (ei->type != E820_RAM)
> +			continue;
> +
> +		if (end <= ISA_END_ADDRESS)
> +			continue;
> +
> +		if (start <= ISA_END_ADDRESS)
> +			start = 0;
> +#ifdef CONFIG_X86_32
> +		/* on 32 bit, we only map up to max_low_pfn */
> +		if ((start >> PAGE_SHIFT) >= max_low_pfn)
> +			continue;
> +
> +		if ((end >> PAGE_SHIFT) > max_low_pfn)
> +			end = max_low_pfn << PAGE_SHIFT;
> +#endif
> +		/* the ISA range is always mapped regardless of holes */
> +		if (!pfn_range_is_mapped(0, ISA_END_ADDRESS << PAGE_SHIFT) &&
> +		    start != 0)
> +			init_memory_mapping(0, ISA_END_ADDRESS);
> +
> +		init_memory_mapping(start, end);
> +	}
> +

The ISA range mapping doesn't really make sense *inside* the loop, no? 
It seems you could do that before you enter the loop and then simply have:

+		if (end <= ISA_END_ADDRESS)
+			continue;
+
+		if (start <= ISA_END_ADDRESS)
+			start = ISA_END_ADDRESS;

... no?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

