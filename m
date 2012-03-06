Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2CFDpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:45:23 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18425 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab2CFDpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:45:21 -0500
MIME-Version: 1.0
Message-ID: <37663fc4-72a2-4c02-9d9a-7ac6e6f64e1a@default>
Date: Mon, 5 Mar 2012 19:44:57 -0800 (PST)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <yinghai@kernel.org>
Cc: <mingo@redhat.com>, <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <torvalds@linux-foundation.org>, <joe.jin@oracle.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rjw@sisk.pl>, <tiwai@suse.de>, <hpa@zytor.com>
Subject: =?UTF-8?B?562U5aSNOiBSZTogW1BBVENIXSBJbml0aWFsaXplIG1heF9wZm5fbWFwcGVk?=
 =?UTF-8?B?IGFzIGluaXRpYWwgaWRlbnQgbWFwcGluZyBzaXplIGZvciB4ODZfNjQ=?=
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F55883E.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- yinghai@kernel.org 写道：

> it is not that simple.
> 
> 
> 
> whole history:
> 
> before following patch, on x86_64, for low memory (under 4g) pgtable
> 
> will be allocated just under TOML
> 
> and even those memory is not mapped directly. because now we are using
> 
> early_ioremap to access those
> 
> page table.
> 
> 
> 
> but looks it has problem with S4 resume. so good_end is set to initial
> 
> mapped high address.
> 
> (that is 512M). So page table will just below 512M
> 
> but crash kernel is allocated below 768M. so will have no chance to
> 
> get 512M porting for crashkernel.

Aha, thanks Yinghai talking this interesting history.

Can't imagine the difference between below 512M and below max_low_pfn_mapped both from sw and hw's view, for S4 resume.
Even if we set max_pfn_mapped to 512M, we can play with a small trick to get 512M space for crashkernel. That's shareing space with initrd since when initrd space freed, 
it will check if pages occupied by crashkernel. But this need some address scope calculation.
> 
> 
> 
> Now your patch just set initial mapping limit to 1g. but according to
> 
> arch/x86/kernel/head_64.S
> 
> we only have initial mapping to 512M.

I browered arch/x86/kernel/head_64.S again, looks ident mapping is 1G mapped. See below
NEXT_PAGE(level2_ident_pgt)
        /* Since I easily can, map the first 1G.
         * Don't set NX because code runs from these pages.
         */
        PMDS(0, __PAGE_KERNEL_IDENT_LARGE_EXEC, PTRS_PER_PMD)

If you mean level2_kernel_pgt here, it's 512MB here. But it's not that accurate for relocated kernel and is truncated in cleanup_highmap to _text ---- _brk_end.
> 
> 
> 
> So you can not just simply set to 1G,  that will confuse early
> 
> memblock allocator.
> 
> 
> 
> We may update find_early_table_space() to use 1G as good_end for
> 
> x86_64 that will be less confusing.

Yes
> 
> 
> 
> also even in that case, you still need to double check if S4 resume is
> 
> broken again.
> 
> 
> 
> 
> 
> Or We can change KERNL_IMAGE_SIZE to 1G?
That need only a small change in arch/x86/kernel/head_64.S
But as you said, still need test for S4 resume or others.

> 
> 
> 
> Or we need to dig out when S4 resume is broken at first place when we
> 
> put page table near TOML.
I prefer that, maybe intel engineer can help on this.
