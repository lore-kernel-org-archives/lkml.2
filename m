Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2EJIwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:52:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:55771 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab2EJIwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:52:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98445243"
Message-ID: <4FAB8169.7090809@intel.com>
Date: Thu, 10 May 2012 16:50:49 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com> <1336626013-28413-4-git-send-email-alex.shi@intel.com> <20120510075325.GB30055@aftab.osrc.amd.com>
In-Reply-To: <20120510075325.GB30055@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> Ok, question:
> 
> we're comparing TLB size with the amount of pages mapped by this mm
> struct. AFAICT, that doesn't mean that all those mapped pages do have
> respective entries in the TLB, does it?
> 
> If so, then the actual entries number is kinda inaccurate, no? We don't
> really know how many TLB entries actually belong to this mm struct. Or am I
> missing something?


No, we can not know the exactly TLB entires for. But usually, when you
process is doing the mprotect/munmap etc system call, your process has
taken much of memory and already filled lots of TLB entries.

This point is considered imply in the balance point calculation.
checking following equation
	(512 - X) * 100ns(assumed TLB refill cost) =
		X(TLB flush entries) * 100ns(assumed invlpg cost)

The X value we got is far lower then theory value. That means remain TLB
entries is may not so much, or TLB refill cost is much lower due to
hardware pre-fetcher.

>

>> +			if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
> 
> Oh, in a later patch you do this:
> 
> +                       if ((end - start) >> PAGE_SHIFT >
> +                                       act_entries >> tlb_flushall_factor)
> 
> and the tlb_flushall_factor factor is 5 or 6 but the division by 16
> (FLUSHALL_BAR) was a >> 4. So, is this to assume that it is not 16 but
> actually more than 32 or even 64 TLB entries where a full TLB flush
> makes sense and one-by-one if less?


Yes, the FLUSHALL_BAR is just a guessing value here. And take your
advice, I modify the macro benchmark a little and get the more sensible
value in later patch.

BTW, I found 8% performance increase on kbuild on SNB EP from the
average multiple testing, while result variation is up to 15%.
