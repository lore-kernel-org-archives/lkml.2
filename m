Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1LNExu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:53:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40818 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab1LNExt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:53:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAGTjWtDvmLnNqUoddUCmLVSDN0HcOjtsuFbAs+MFy24JFX-P3g@mail.gmail.com>
References: <1323798271-1452-1-git-send-email-mikew@google.com>
 <1323829490.22361.395.camel@sli10-conroe> <CAGTjWtDvmLnNqUoddUCmLVSDN0HcOjtsuFbAs+MFy24JFX-P3g@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 13 Dec 2011 20:45:46 -0800
Message-ID: <CAGTjWtC=2vcBKBBaNhKczBXXUCYVmyC+0vUjPUB3NKGnW4cKcQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix kswapd livelock on single core, no preempt kernel
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickens <hughd@google.com>, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 8:36 PM, Mike Waychison <mikew@google.com> wrote:
> On Tue, Dec 13, 2011 at 6:24 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> On Wed, 2011-12-14 at 01:44 +0800, Mike Waychison wrote:
>>> On a single core system with kernel preemption disabled, it is possible
>>> for the memory system to be so taxed that kswapd cannot make any forward
>>> progress.  This can happen when most of system memory is tied up as
>>> anonymous memory without swap enabled, causing kswapd to consistently
>>> fail to achieve its watermark goals.  In turn, sleeping_prematurely()
>>> will consistently return true and kswapd_try_to_sleep() to never invoke
>>> schedule().  This causes the kswapd thread to stay on the CPU in
>>> perpetuity and keeps other threads from processing oom-kills to reclaim
>>> memory.
>>>
>>> The cond_resched() instance in balance_pgdat() is never called as the
>>> loop that iterates from DEF_PRIORITY down to 0 will always set
>>> all_zones_ok to true, and not set it to false once we've passed
>>> DEF_PRIORITY as zones that are marked ->all_unreclaimable are not
>>> considered in the "all_zones_ok" evaluation.
>>>
>>> This change modifies kswapd_try_to_sleep to ensure that we enter
>>> scheduler at least once per invocation if needed.  This allows kswapd to
>>> get off the CPU and allows other threads to die off from the OOM killer
>>> (freeing memory that is otherwise unavailable in the process).
>> your description suggests zones with all_unreclaimable set. but in this
>> case sleeping_prematurely() will return false instead of true, kswapd
>> will do sleep then. is there anything I missed?

Actually, I don't see where sleeping_prematurely() would return false
if any zone has ->all_unreclaimable set.   In this case, the order was
0, so we return !all_zones_ok, which is false because
!zone_watermark_ok_safe(ZONE_DMA32).

>
> Debugging this, I didn't get a dump from oom-kill as it never ran
> (until I binary patched in a cond_resched() into live hung machines --
> this reproduced in a VM).
>
> I was however able to capture the following data while it was hung:
>
>
> /cloud/vmm/host/backend/perfmetric/node0/zone0/active_anon : long long = 773
> /cloud/vmm/host/backend/perfmetric/node0/zone0/active_file : long long = 6
> /cloud/vmm/host/backend/perfmetric/node0/zone0/anon_pages : long long = 1,329
> /cloud/vmm/host/backend/perfmetric/node0/zone0/bounce : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone0/dirtied : long long = 4,425
> /cloud/vmm/host/backend/perfmetric/node0/zone0/file_dirty : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone0/file_mapped : long long = 5
> /cloud/vmm/host/backend/perfmetric/node0/zone0/file_pages : long long = 330
> /cloud/vmm/host/backend/perfmetric/node0/zone0/free_pages : long long = 2,018
> /cloud/vmm/host/backend/perfmetric/node0/zone0/inactive_anon : long long = 865
> /cloud/vmm/host/backend/perfmetric/node0/zone0/inactive_file : long long = 13
> /cloud/vmm/host/backend/perfmetric/node0/zone0/kernel_stack : long long = 10
> /cloud/vmm/host/backend/perfmetric/node0/zone0/mlock : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone0/pagetable : long long = 74
> /cloud/vmm/host/backend/perfmetric/node0/zone0/shmem : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone0/slab_reclaimable : long long = 54
> /cloud/vmm/host/backend/perfmetric/node0/zone0/slab_unreclaimable :
> long long = 130
> /cloud/vmm/host/backend/perfmetric/node0/zone0/unevictable : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone0/writeback : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone0/written : long long = 47,184
>
> /cloud/vmm/host/backend/perfmetric/node0/zone1/active_anon : long long = 359,251
> /cloud/vmm/host/backend/perfmetric/node0/zone1/active_file : long long = 67
> /cloud/vmm/host/backend/perfmetric/node0/zone1/anon_pages : long long = 441,180
> /cloud/vmm/host/backend/perfmetric/node0/zone1/bounce : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone1/dirtied : long long = 6,457,125
> /cloud/vmm/host/backend/perfmetric/node0/zone1/file_dirty : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone1/file_mapped : long long = 134
> /cloud/vmm/host/backend/perfmetric/node0/zone1/file_pages : long long = 38,090
> /cloud/vmm/host/backend/perfmetric/node0/zone1/free_pages : long long = 1,630
> /cloud/vmm/host/backend/perfmetric/node0/zone1/inactive_anon : long
> long = 119,779
> /cloud/vmm/host/backend/perfmetric/node0/zone1/inactive_file : long long = 81
> /cloud/vmm/host/backend/perfmetric/node0/zone1/kernel_stack : long long = 173
> /cloud/vmm/host/backend/perfmetric/node0/zone1/mlock : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone1/pagetable : long long = 15,222
> /cloud/vmm/host/backend/perfmetric/node0/zone1/shmem : long long = 1
> /cloud/vmm/host/backend/perfmetric/node0/zone1/slab_reclaimable : long
> long = 1,677
> /cloud/vmm/host/backend/perfmetric/node0/zone1/slab_unreclaimable :
> long long = 7,152
> /cloud/vmm/host/backend/perfmetric/node0/zone1/unevictable : long long = 0
> /cloud/vmm/host/backend/perfmetric/node0/zone1/writeback : long long = 8
> /cloud/vmm/host/backend/perfmetric/node0/zone1/written : long long = 16,639,708
>
> These value were static while the machine was hung up in kswapd.  I
> unfortunately don't have the low/min/max or lowmem watermarks handy.
>
> From stepping through with gdb, I was able to determine that
> ZONE_DMA32 would fail zone_watermark_ok_safe(), causing a scan   up to
> end_zone == 1.  If memory serves, it would not get the
> ->all_unreclaimable flag.  I didn't get the chance to root cause this
> internal inconsistency though.
>
> FYI, this was seen with a 2.6.39-based kernel with no-numa, no-memcg
> and swap-enabled.
>
> If I get the chance, I can reproduce and look at this closer to try
> and root cause why zone_reclaimable() would return true, but I won't
> be able to do that until after the holidays -- sometime in January.
