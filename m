Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2DNDh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 23:37:29 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49035 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab2DNDh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 23:37:27 -0400
Date: Sat, 14 Apr 2012 12:37:22 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 00/16] KVM: MMU: fast page fault
Message-Id: <20120414123722.a94af3adb4ca80a6a5f6b477@gmail.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 18:05:29 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Thanks for Avi and Marcelo's review, i have simplified the whole things
> in this version:
> - it only fix the page fault with PFEC.P = 1 && PFEC.W = 0 that means
>   unlock set_spte path can be dropped.
> 
> - it only fixes the page fault caused by dirty-log
> 
> In this version, all the information we need is from spte, the
> SPTE_ALLOW_WRITE bit and SPTE_WRITE_PROTECT bit:
>    - SPTE_ALLOW_WRITE is set if the gpte is writable and the pfn pointed
>      by the spte is writable on host.
>    - SPTE_WRITE_PROTECT is set if the spte is write-protected by shadow
>      page table protection.
> 
> All these bits can be protected by cmpxchg, now, all the things is fairly
> simple than before. :)

Well, could you remove cleanup patches not needed for "lock-less" from
this patch series?

I want to see them separately.

Or everything was needed for "lock-less" ?

> Performance test:
> 
> autotest migration:
> (Host: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz * 12 + 32G)

Please explain what this test result means, not just numbers.

There are many aspects:
	- how fast migration can converge/complete
	- how fast programs inside the guest can run during migration:
	  -- throughput
	  -- latency
	- ...

I think lock-less will reduce latency a lot, but not sure about convergence:
why it became fast?

> - For ept:
> 
> Before:
>                     smp2.Fedora.16.64.migrate
> Times   .unix      .with_autotest.dbench.unix     total
>  1       104           214                         323
>  2       68            238                         310
>  3       68            242                         314
> 
> After:
>                     smp2.Fedora.16.64.migrate
> Times   .unix      .with_autotest.dbench.unix     total
>  1       101           190                         295
>  2       67            188                         259
>  3       66            217                         289
> 

As discussed on v1-threads, the main goal of this "lock-less" should be
the elimination of mmu_lock contentions.

So what we should measure is latency.

Thanks,
	Takuya
