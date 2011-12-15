Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab1LOAx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 19:53:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:38451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384Ab1LOAx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 19:53:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87449787"
Subject: Re: [PATCH] mm: Fix kswapd livelock on single core, no preempt
 kernel
From: Shaohua Li <shaohua.li@intel.com>
To: Mike Waychison <mikew@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickens <hughd@google.com>, Greg Thelen <gthelen@google.com>
In-Reply-To: <CAGTjWtC=2vcBKBBaNhKczBXXUCYVmyC+0vUjPUB3NKGnW4cKcQ@mail.gmail.com>
References: <1323798271-1452-1-git-send-email-mikew@google.com>
	 <1323829490.22361.395.camel@sli10-conroe>
	 <CAGTjWtDvmLnNqUoddUCmLVSDN0HcOjtsuFbAs+MFy24JFX-P3g@mail.gmail.com>
	 <CAGTjWtC=2vcBKBBaNhKczBXXUCYVmyC+0vUjPUB3NKGnW4cKcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 09:06:27 +0800
Message-ID: <1323911187.22361.426.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 12:45 +0800, Mike Waychison wrote:
> On Tue, Dec 13, 2011 at 8:36 PM, Mike Waychison <mikew@google.com> wrote:
> > On Tue, Dec 13, 2011 at 6:24 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> On Wed, 2011-12-14 at 01:44 +0800, Mike Waychison wrote:
> >>> On a single core system with kernel preemption disabled, it is possible
> >>> for the memory system to be so taxed that kswapd cannot make any forward
> >>> progress.  This can happen when most of system memory is tied up as
> >>> anonymous memory without swap enabled, causing kswapd to consistently
> >>> fail to achieve its watermark goals.  In turn, sleeping_prematurely()
> >>> will consistently return true and kswapd_try_to_sleep() to never invoke
> >>> schedule().  This causes the kswapd thread to stay on the CPU in
> >>> perpetuity and keeps other threads from processing oom-kills to reclaim
> >>> memory.
> >>>
> >>> The cond_resched() instance in balance_pgdat() is never called as the
> >>> loop that iterates from DEF_PRIORITY down to 0 will always set
> >>> all_zones_ok to true, and not set it to false once we've passed
> >>> DEF_PRIORITY as zones that are marked ->all_unreclaimable are not
> >>> considered in the "all_zones_ok" evaluation.
> >>>
> >>> This change modifies kswapd_try_to_sleep to ensure that we enter
> >>> scheduler at least once per invocation if needed.  This allows kswapd to
> >>> get off the CPU and allows other threads to die off from the OOM killer
> >>> (freeing memory that is otherwise unavailable in the process).
> >> your description suggests zones with all_unreclaimable set. but in this
> >> case sleeping_prematurely() will return false instead of true, kswapd
> >> will do sleep then. is there anything I missed?
> 
> Actually, I don't see where sleeping_prematurely() would return false
> if any zone has ->all_unreclaimable set.   In this case, the order was
> 0, so we return !all_zones_ok, which is false because
> !zone_watermark_ok_safe(ZONE_DMA32).
so the ZONE_DMA32 hasn't all_unreclaimable set, right? if all zones have
all_unreclaimable set, all_zones_ok clearly is true. this means kswapd
can reclaim some pages in the zone, which looks sane.

Thanks,
Shaohua

