Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2ASHAC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:00:02 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33220 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2ASHAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:00:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 19 Jan 2012 15:58:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for
 next
Message-Id: <20120119155839.ad57620c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 22:05:12 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

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

Thank you ! This seems much better.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


