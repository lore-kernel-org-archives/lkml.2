Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0CQGoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:44:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49325 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0CQGoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:44:13 -0400
Date: Wed, 17 Mar 2010 12:14:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v7)
Message-ID: <20100317064402.GP18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1268609202-15581-1-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi <arighi@develer.com> [2010-03-15 00:26:37]:

> Control the maximum amount of dirty pages a cgroup can have at any given time.
> 
> Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
> page cache used by any cgroup. So, in case of multiple cgroup writers, they
> will not be able to consume more than their designated share of dirty pages and
> will be forced to perform write-out if they cross that limit.
> 
> The overall design is the following:
> 
>  - account dirty pages per cgroup
>  - limit the number of dirty pages via memory.dirty_ratio / memory.dirty_bytes
>    and memory.dirty_background_ratio / memory.dirty_background_bytes in
>    cgroupfs
>  - start to write-out (background or actively) when the cgroup limits are
>    exceeded
> 
> This feature is supposed to be strictly connected to any underlying IO
> controller implementation, so we can stop increasing dirty pages in VM layer
> and enforce a write-out before any cgroup will consume the global amount of
> dirty pages defined by the /proc/sys/vm/dirty_ratio|dirty_bytes and
> /proc/sys/vm/dirty_background_ratio|dirty_background_bytes limits.
> 
> Changelog (v6 -> v7)
> ~~~~~~~~~~~~~~~~~~~~~~
>  * introduce trylock_page_cgroup() to guarantee that lock_page_cgroup()
>    is never called under tree_lock (no strict accounting, but better overall
>    performance)
>  * do not account file cache statistics for the root cgroup (zero
>    overhead for the root cgroup)
>  * fix: evaluate cgroup free pages as at the minimum free pages of all
>    its parents
> 
> Results
> ~~~~~~~
> The testcase is a kernel build (2.6.33 x86_64_defconfig) on a Intel Core 2 @
> 1.2GHz:
> 
> <before>
>  - root  cgroup:	11m51.983s
>  - child cgroup:	11m56.596s
> 
> <after>
>  - root cgroup:		11m51.742s
>  - child cgroup:	12m5.016s
> 
> In the previous version of this patchset, using the "complex" locking scheme
> with the _locked and _unlocked version of mem_cgroup_update_page_stat(), the
> child cgroup required 11m57.896s and 12m9.920s with lock_page_cgroup()+irq_disabled.
> 
> With this version there's no overhead for the root cgroup (the small difference
> is in error range). I expected to see less overhead for the child cgroup, I'll
> do more testing and try to figure better what's happening.

I like that the root overhead is going away.

> 
> In the while, it would be great if someone could perform some tests on a larger
> system... unfortunately at the moment I don't have a big system available for
> this kind of tests...
>

I'll test this, I have a small machine to test on at the moment, I'll
revert back with data. 

-- 
	Three Cheers,
	Balbir
