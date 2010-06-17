Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0FQGD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:03:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33119 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0FQGD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:03:58 -0400
Message-ID: <4C19BA9A.4010300@zytor.com>
Date: Wed, 16 Jun 2010 23:03:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com>
In-Reply-To: <4C19AABA.8000706@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 09:55 PM, Kenji Kaneshige wrote:
>>
>> I think they might be. Kenji?
> 
> No. My addresses are in the 44-bits range (around fc000000000). So it is
> not required for my problem. This change assumes that phys_addr can be
> above 44-bits (up to 52-bits (and higher in the future?)).
> 
> By the way, is there linux kernel limit regarding above 44-bits physical
> address in x86_32 PAE? For example, pfn above 32-bits is not supported?
> 

There are probably places at which PFNs are held in 32-bit numbers,
although it would be good to track them down if it isn't too expensive
to fix them (i.e. doesn't affect generic code.)

This also affects paravirt systems, i.e. right now Xen has to locate all
32-bit guests below 64 GB, which limits its usefulness.

> #ifdef CONFIG_X86_PAE
> /* 44=32+12, the limit we can fit into an unsigned long pfn */
> #define __PHYSICAL_MASK_SHIFT   44
> #define __VIRTUAL_MASK_SHIFT    32
> 
> If there is 44-bits physical address limit, I think it's better to use
> PHYSICAL_PAGE_MASK for masking physical address, instead of "(phys_addr
>>> PAGE_SHIFT) << PAGE_SHIFT)". The PHYSICAL_PAGE_MASK would become
> greater value when 44-bits physical address limit is eliminated. And
> maybe we need to change phys_addr_valid() returns error if physical
> address is above (1 << __PHYSICAL_MASK_SHIFT)?

The real question is how much we can fix without an unreasonable cost.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

