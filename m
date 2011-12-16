Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337Ab1LPRz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:55:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49883 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760268Ab1LPRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:55:20 -0500
Message-ID: <4EEB85F1.7050903@zytor.com>
Date: Fri, 16 Dec 2011 09:54:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com> <4EA09EA2.3030203@zytor.com> <1319149574.13035.6.camel@jshin-Toonie> <4EE9266A.90200@zytor.com> <20111214231425.GA18068@jshin-Toonie> <20111216162004.GC18068@jshin-Toonie> <4EEB8320.4010809@oracle.com>
In-Reply-To: <4EEB8320.4010809@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 09:42 AM, Yinghai Lu wrote:
>
> no, you change the meaning max_low_pfn_mapped and max_pfn_mapped for x86_64 at least.
>
> before your patch:
> max_low_pfn_mapped is the mapped pfn beblow 4g.
> max_pfn_mapped: is mapped pfn.
>
> after your patch, those two variables does not mean the memory [0, max_low_pfn_mapped) and [4g<<12, max_pfn_mapped)
> are really mapped.
>

And that's exactly the problem.  It is BROKEN -- as in fundamentally 
dangerous -- for these mappings to exist.  It is because the model is 
too inflexible.

> so in arch/x86/platform/efi/efi.c
>
>                  if (end_pfn<= max_low_pfn_mapped
>                      || (end_pfn>  (1UL<<  (32 - PAGE_SHIFT))
>                          &&  end_pfn<= max_pfn_mapped))
>                          va = __va(md->phys_addr);
>                  else
>                          va = efi_ioremap(md->phys_addr, size, md->type);
>
>
> and others will have problem.
>
> to solve your problem:
> 1. unmap the HT range ?
> 2. or introduce mapped_pfn_range array?

1 is fundamentally a braindead hack that solves one case without solving 
the overall problem.

For 2 - why can't we simply make the invariant that E820_RAM is mapped 
and nothing else, with the sole exceptions being the 1 MiB (fixed MTRR)?

For things like efi.c we should make sure to have interfaces instead of 
open-code this kind of stuff.

	-hpa

