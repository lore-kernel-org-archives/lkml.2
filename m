Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1CXQD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:03:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab1CXQDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:03:25 -0400
Date: Thu, 24 Mar 2011 17:03:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: torvalds@linux-foundation.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324160310.GA27127@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324142146.GA11682@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, some sort of boot crash has snuck upstream in the last 24 hours:
> 
>  BUG: unable to handle kernel paging request at ffff87ffc147e020                               
>  IP: [<ffffffff811aa762>] this_cpu_cmpxchg16b_emu+0x2/0x1c           
> 
>      [<ffffffff810d9cbc>] ? kmem_cache_alloc+0x4c/0x110                                           
>      [<ffffffff8151cf06>] kmem_cache_init+0xeb/0x2b0                                              
>      [<ffffffff81504a06>] start_kernel+0x1de/0x49b                                                
>      [<ffffffff8150432b>] x86_64_start_reservations+0x132/0x136                                   
>      [<ffffffff81504140>] ? early_idt_handlers+0x140/0x140         
> 
> And the SLAB changes are one of the suspects. It triggers in about 5% of all 
> randconfigs. I'm bisecting it currently.

Caused by:

| 8a5ec0ba42c4919e2d8f4c3138cc8b987fdb0b79 is the first bad commit
| commit 8a5ec0ba42c4919e2d8f4c3138cc8b987fdb0b79
| Author: Christoph Lameter <cl@linux.com>
| Date:   Fri Feb 25 11:38:54 2011 -0600
|
|    Lockless (and preemptless) fastpaths for slub

I'll try to revert these:

 2fd66c517d5e: slub: Add missing irq restore for the OOM path
 a24c5a0ea902: slub: Dont define useless label in the !CONFIG_CMPXCHG_LOCAL case
 8a5ec0ba42c4: Lockless (and preemptless) fastpaths for slub

Thanks,

	Ingo
