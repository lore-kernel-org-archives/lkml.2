Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1LNCM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:12:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:46395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1LNCMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:12:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87003568"
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
In-Reply-To: <1323798271-1452-1-git-send-email-mikew@google.com>
References: <1323798271-1452-1-git-send-email-mikew@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 10:24:50 +0800
Message-ID: <1323829490.22361.395.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 01:44 +0800, Mike Waychison wrote:
> On a single core system with kernel preemption disabled, it is possible
> for the memory system to be so taxed that kswapd cannot make any forward
> progress.  This can happen when most of system memory is tied up as
> anonymous memory without swap enabled, causing kswapd to consistently
> fail to achieve its watermark goals.  In turn, sleeping_prematurely()
> will consistently return true and kswapd_try_to_sleep() to never invoke
> schedule().  This causes the kswapd thread to stay on the CPU in
> perpetuity and keeps other threads from processing oom-kills to reclaim
> memory.
> 
> The cond_resched() instance in balance_pgdat() is never called as the
> loop that iterates from DEF_PRIORITY down to 0 will always set
> all_zones_ok to true, and not set it to false once we've passed
> DEF_PRIORITY as zones that are marked ->all_unreclaimable are not
> considered in the "all_zones_ok" evaluation.
> 
> This change modifies kswapd_try_to_sleep to ensure that we enter
> scheduler at least once per invocation if needed.  This allows kswapd to
> get off the CPU and allows other threads to die off from the OOM killer
> (freeing memory that is otherwise unavailable in the process).
your description suggests zones with all_unreclaimable set. but in this
case sleeping_prematurely() will return false instead of true, kswapd
will do sleep then. is there anything I missed?

