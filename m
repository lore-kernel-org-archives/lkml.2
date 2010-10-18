Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab0JRSAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:00:52 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:27480 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752208Ab0JRSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:00:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 58Y_4jIVM1lZtOxXUv95qPbD3LUuJLR6x3HXts1XStII6cp
 nUoM-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 18 Oct 2010 13:00:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
In-Reply-To: <1286936472.31597.50.camel@debian>
Message-ID: <alpine.DEB.2.00.1010181249540.2092@router.home>
References: <20101005185725.088808842@linux.com>  <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>  <20101006123753.GA17674@localhost> <1286936472.31597.50.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, Alex,Shi wrote:

> I got the code from
> git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git unified
> on branch "origin/unified" and do a patch base on 36-rc7 kernel. Then I
> tested the patch on our 2P/4P core2 machines and 2P NHM, 2P WSM
> machines. Most of benchmark have no clear improvement or regression. The
> testing benchmarks is listed here.
> http://kernel-perf.sourceforge.net/about_tests.php

Ah. Thanks. The tests needs to show a clear benefit for this to be a
viable solution. They did earlier without all the NUMA queuing on SMP.

> BTW, I save several time kernel panic in fio testing:
> ===================
> > Pid: 776, comm: kswapd0 Not tainted 2.6.36-rc7-unified #1 X8DTN/X8DTN
> > > RIP: 0010:[<ffffffff810cc21c>]  [<ffffffff810cc21c>] slab_alloc
> > > +0x562/0x6f2

Cannot see the error message? I guess this is the result of a BUG_ON()?
I'll try to run that fio test first.

> kswapd0: page allocation failure. order:0, mode:0xd0
> Pid: 714, comm: kswapd0 Not tainted 2.6.36-rc7-unified #1
> Call Trace:
> [<ffffffff8109fcf4>] ? __alloc_pages_nodemask+0x63f/0x6c7
> [<ffffffff8100328e>] ? apic_timer_interrupt+0xe/0x20
> [<ffffffff810cc6f7>] ? new_slab+0xac/0x277
> [<ffffffff810cce1e>] ? slab_alloc+0x55c/0x6e8
> [<ffffffff810ce58b>] ? shared_caches+0x31/0xd9
> [<ffffffff810ce110>] ? __kmalloc+0xb0/0xff
> [<ffffffff810ce58b>] ? shared_caches+0x31/0xd9
> [<ffffffff810ce649>] ? expire_alien_caches+0x16/0x8d
> [<ffffffff810cde25>] ? kmem_cache_expire_all+0xf6/0x14d

Expiration needs to get the gfp flags from the reclaim context. And we
now have more allocations in a reclaim context.

> slab_unreclaimable:2963060kB kernel_stack:1016kB pagetables:656kB

3GB unreclaimable.... Memory leak.

