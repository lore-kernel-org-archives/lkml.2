Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1IMKG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:06:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41498 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1IMKG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:06:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Sep 2011 19:06:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/11] mm: memcg: consolidate hierarchy iteration
 primitives
Message-Id: <20110913190608.b0658961.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315825048-3437-2-git-send-email-jweiner@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-2-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 12:57:18 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Memory control groups are currently bolted onto the side of
> traditional memory management in places where better integration would
> be preferrable.  To reclaim memory, for example, memory control groups
> maintain their own LRU list and reclaim strategy aside from the global
> per-zone LRU list reclaim.  But an extra list head for each existing
> page frame is expensive and maintaining it requires additional code.
> 
> This patchset disables the global per-zone LRU lists on memory cgroup
> configurations and converts all its users to operate on the per-memory
> cgroup lists instead.  As LRU pages are then exclusively on one list,
> this saves two list pointers for each page frame in the system:
> 
> page_cgroup array size with 4G physical memory
> 
>   vanilla: [    0.000000] allocated 31457280 bytes of page_cgroup
>   patched: [    0.000000] allocated 15728640 bytes of page_cgroup
> 
> At the same time, system performance for various workloads is
> unaffected:
> 
> 100G sparse file cat, 4G physical memory, 10 runs, to test for code
> bloat in the traditional LRU handling and kswapd & direct reclaim
> paths, without/with the memory controller configured in
> 
>   vanilla: 71.603(0.207) seconds
>   patched: 71.640(0.156) seconds
> 
>   vanilla: 79.558(0.288) seconds
>   patched: 77.233(0.147) seconds
> 
> 100G sparse file cat in 1G memory cgroup, 10 runs, to test for code
> bloat in the traditional memory cgroup LRU handling and reclaim path
> 
>   vanilla: 96.844(0.281) seconds
>   patched: 94.454(0.311) seconds
> 
> 4 unlimited memcgs running kbuild -j32 each, 4G physical memory, 500M
> swap on SSD, 10 runs, to test for regressions in kswapd & direct
> reclaim using per-memcg LRU lists with multiple memcgs and multiple
> allocators within each memcg
> 
>   vanilla: 717.722(1.440) seconds [ 69720.100(11600.835) majfaults ]
>   patched: 714.106(2.313) seconds [ 71109.300(14886.186) majfaults ]
> 
> 16 unlimited memcgs running kbuild, 1900M hierarchical limit, 500M
> swap on SSD, 10 runs, to test for regressions in hierarchical memcg
> setups
> 
>   vanilla: 2742.058(1.992) seconds [ 26479.600(1736.737) majfaults ]
>   patched: 2743.267(1.214) seconds [ 27240.700(1076.063) majfaults ]
> 
> This patch:
> 
> There are currently two different implementations of iterating over a
> memory cgroup hierarchy tree.
> 
> Consolidate them into one worker function and base the convenience
> looping-macros on top of it.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Seems nice.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

