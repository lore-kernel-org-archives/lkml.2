Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab1EXASH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:18:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56442 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1EXASD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:18:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 May 2011 09:11:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        hannes@cmpxchg.org, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 6/8] memcg asynchronous memory reclaim interface
Message-Id: <20110524091114.02fb183d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTinEcbQoV6n0+S9W4s4+AFJKKCiwsA@mail.gmail.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124636.45c26cfa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520144935.3bfdb2e2.akpm@linux-foundation.org>
	<BANLkTi=Ap=NdZ+05UjjEsC5f5wdjo9yvew@mail.gmail.com>
	<BANLkTinEcbQoV6n0+S9W4s4+AFJKKCiwsA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 16:36:20 -0700
Ying Han <yinghan@google.com> wrote:

> On Fri, May 20, 2011 at 4:56 PM, Hiroyuki Kamezawa
> <kamezawa.hiroyuki@gmail.com> wrote:
> > 2011/5/21 Andrew Morton <akpm@linux-foundation.org>:
> >> On Fri, 20 May 2011 12:46:36 +0900
> >> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >>
> >>> This patch adds a logic to keep usage margin to the limit in asynchronous way.
> >>> When the usage over some threshould (determined automatically), asynchronous
> >>> memory reclaim runs and shrink memory to limit - MEMCG_ASYNC_STOP_MARGIN.
> >>>
> >>> By this, there will be no difference in total amount of usage of cpu to
> >>> scan the LRU
> >>
> >> This is not true if "don't writepage at all (revisit this when
> >> dirty_ratio comes.)" is true.  Skipping over dirty pages can cause
> >> larger amounts of CPU consumption.
> >>
> >>> but we'll have a chance to make use of wait time of applications
> >>> for freeing memory. For example, when an application read a file or socket,
> >>> to fill the newly alloated memory, it needs wait. Async reclaim can make use
> >>> of that time and give a chance to reduce latency by background works.
> >>>
> >>> This patch only includes required hooks to trigger async reclaim and user interfaces.
> >>> Core logics will be in the following patches.
> >>>
> >>>
> >>> ...
> >>>
> >>>  /*
> >>> + * For example, with transparent hugepages, memory reclaim scan at hitting
> >>> + * limit can very long as to reclaim HPAGE_SIZE of memory. This increases
> >>> + * latency of page fault and may cause fallback. At usual page allocation,
> >>> + * we'll see some (shorter) latency, too. To reduce latency, it's appreciated
> >>> + * to free memory in background to make margin to the limit. This consumes
> >>> + * cpu but we'll have a chance to make use of wait time of applications
> >>> + * (read disk etc..) by asynchronous reclaim.
> >>> + *
> >>> + * This async reclaim tries to reclaim HPAGE_SIZE * 2 of pages when margin
> >>> + * to the limit is smaller than HPAGE_SIZE * 2. This will be enabled
> >>> + * automatically when the limit is set and it's greater than the threshold.
> >>> + */
> >>> +#if HPAGE_SIZE != PAGE_SIZE
> >>> +#define MEMCG_ASYNC_LIMIT_THRESH      (HPAGE_SIZE * 64)
> >>> +#define MEMCG_ASYNC_MARGIN         (HPAGE_SIZE * 4)
> >>> +#else /* make the margin as 4M bytes */
> >>> +#define MEMCG_ASYNC_LIMIT_THRESH      (128 * 1024 * 1024)
> >>> +#define MEMCG_ASYNC_MARGIN            (8 * 1024 * 1024)
> >>> +#endif
> >>
> >> Document them, please.  How are they used, what are their units.
> >>
> >
> > will do.
> >
> >
> >>> +static void mem_cgroup_may_async_reclaim(struct mem_cgroup *mem);
> >>> +
> >>> +/*
> >>>   * The memory controller data structure. The memory controller controls both
> >>>   * page cache and RSS per cgroup. We would eventually like to provide
> >>>   * statistics based on the statistics developed by Rik Van Riel for clock-pro,
> >>> @@ -278,6 +303,12 @@ struct mem_cgroup {
> >>>        */
> >>>       unsigned long   move_charge_at_immigrate;
> >>>       /*
> >>> +      * Checks for async reclaim.
> >>> +      */
> >>> +     unsigned long   async_flags;
> >>> +#define AUTO_ASYNC_ENABLED   (0)
> >>> +#define USE_AUTO_ASYNC               (1)
> >>
> >> These are really confusing.  I looked at the implementation and at the
> >> documentation file and I'm still scratching my head.  I can't work out
> >> why they exist.  With the amount of effort I put into it ;)
> >>
> >> Also, AUTO_ASYNC_ENABLED and USE_AUTO_ASYNC have practically the same
> >> meaning, which doesn't help things.
> >>
> > Ah, yes it's confusing.
> 
> Sorry I was confused by the memory.async_control interface. I assume
> that is the knob to turn on/off the bg reclaim on per-memcg basis. But
> when I tried to turn it off, it seems not working well:
> 
> $ cat /proc/7248/cgroup
> 3:memory:/A
> 
> $ cat /dev/cgroup/memory/A/memory.async_control
> 0
> 

If enabled and kworker runs, this shows "3", for now.
I'll make this simpler in the next post.

> Then i can see the kworkers start running when the memcg A under
> memory pressure. There was no other memcgs configured under root.


What kworkers ? For example, many kworkers runs on ext4? on my host.
If kworker/u:x works, it may be for memcg (for my host)

Ok, I'll add statistics in v3.

Thanks,
-Kame

