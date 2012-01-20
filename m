Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2ATXsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:48:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2ATXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:48:08 -0500
Date: Fri, 20 Jan 2012 15:48:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] idr: make idr_get_next() good for rcu_read_lock()
Message-Id: <20120120154807.c55c9ac7.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1201191247210.29542@eggly.anvils>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
	<1326958401.1113.22.camel@edumazet-laptop>
	<CAOS58YO585NYMLtmJv3f9vVdadFqoWF+Y5vZ6Va=2qHELuePJA@mail.gmail.com>
	<1326979818.2249.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.LSU.2.00.1201191235330.29542@eggly.anvils>
	<alpine.LSU.2.00.1201191247210.29542@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012 12:48:48 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Make one small adjustment to idr_get_next(): take the height from the
> top layer (stable under RCU) instead of from the root (unprotected by
> RCU), as idr_find() does: so that it can be used with RCU locking.
> Copied comment on RCU locking from idr_find().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  lib/idr.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> --- 3.2.0+.orig/lib/idr.c	2012-01-04 15:55:44.000000000 -0800
> +++ 3.2.0+/lib/idr.c	2012-01-19 11:55:28.780206713 -0800
> @@ -595,8 +595,10 @@ EXPORT_SYMBOL(idr_for_each);
>   * Returns pointer to registered object with id, which is next number to
>   * given id. After being looked up, *@nextidp will be updated for the next
>   * iteration.
> + *
> + * This function can be called under rcu_read_lock(), given that the leaf
> + * pointers lifetimes are correctly managed.

Awkward comment.  It translates to "..., because the leaf pointers
lifetimes are correctly managed".

Is that what we really meant?  Or did we mean "..., provided the leaf
pointers lifetimes are correctly managed"?

Also, "pointers" should have been "pointer" or "pointer's"!


