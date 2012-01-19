Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2ASH2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:28:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab2ASH2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:28:42 -0500
Message-ID: <4F17C6B7.5020606@cn.fujitsu.com>
Date: Thu, 19 Jan 2012 15:31:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for
 next
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-19 15:27:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-19 15:27:22,
	Serialize complete at 2012-01-19 15:27:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Commit c1e2ee2dc436 "memcg: replace ss->id_lock with a rwlock" has
> now been seen to cause the unfair behavior we should have expected
> from converting a spinlock to an rwlock: softlockup in cgroup_mkdir(),
> whose get_new_cssid() is waiting for the wlock, while there are 19
> tasks using the rlock in css_get_next() to get on with their memcg
> workload (in an artificial test, admittedly).  Yet lib/idr.c was
> made suitable for RCU way back.
> 
> 1. Revert that commit, restoring ss->id_lock to a spinlock.
> 
> 2. Make one small adjustment to idr_get_next(): take the height from
> the top layer (stable under RCU) instead of from the root (unprotected
> by RCU), as idr_find() does.
> 
> 3. Remove lock and unlock around css_get_next()'s call to idr_get_next():
> memcg iterators (only users of css_get_next) already did rcu_read_lock(),
> and comment demands that, but add a WARN_ON_ONCE to make sure of it.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
> 
>  include/linux/cgroup.h |    2 +-
>  kernel/cgroup.c        |   19 +++++++++----------
>  lib/idr.c              |    4 ++--
>  3 files changed, 12 insertions(+), 13 deletions(-)
