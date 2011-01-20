Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1ATB5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:57:30 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40012 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1ATB53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:57:29 -0500
Date: Thu, 20 Jan 2011 10:52:51 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [patch rfc] memcg: correctly order reading PCG_USED and
 pc->mem_cgroup
Message-Id: <20110120105251.f0384f8d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110119120319.GA2232@cmpxchg.org>
References: <20110119120319.GA2232@cmpxchg.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 13:03:19 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The placement of the read-side barrier is confused: the writer first
> sets pc->mem_cgroup, then PCG_USED.  The read-side barrier has to be
> between testing PCG_USED and reading pc->mem_cgroup.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c |   27 +++++++++------------------
>  1 files changed, 9 insertions(+), 18 deletions(-)
> 
> I am a bit dumbfounded as to why this has never had any impact.  I see
> two scenarios where charging can race with LRU operations:
> 
> One is shmem pages on swapoff.  They are on the LRU when charged as
> page cache, which could race with isolation/putback.  This seems
> sufficiently rare.
> 
> The other case is a swap cache page being charged while somebody else
> had it isolated.  mem_cgroup_lru_del_before_commit_swapcache() would
> see the page isolated and skip it.  The commit then has to race with
> putback, which could see PCG_USED but not pc->mem_cgroup, and crash
> with a NULL pointer dereference.  This does sound a bit more likely.
> 
> Any idea?  Am I missing something?
> 
pc->mem_cgroup is not cleared even when the page is freed, so NULL pointer
dereference can happen only when it's the first time the page is used.
But yes, even if it's not the first time, this means pc->mem_cgroup may be wrong.

Anyway, I welcome this patch.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>


Thanks,
Daisuke Nishimura.
