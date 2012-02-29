Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715Ab2B2TA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:00:58 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46786 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030328Ab2B2TA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:00:56 -0500
Date: Wed, 29 Feb 2012 20:00:46 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: fix deadlock by inverting lrucare nesting
Message-ID: <20120229190046.GC1673@cmpxchg.org>
References: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202282121160.4875@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:25:02PM -0800, Hugh Dickins wrote:
> We have forgotten the rules of lock nesting: the irq-safe ones must be
> taken inside the non-irq-safe ones, otherwise we are open to deadlock:
> 
> CPU0                          CPU1
> ----                          ----
> lock(&(&pc->lock)->rlock);
>                               local_irq_disable();
>                               lock(&(&zone->lru_lock)->rlock);
>                               lock(&(&pc->lock)->rlock);
> <Interrupt>
> lock(&(&zone->lru_lock)->rlock);
> 
> To check a different locking issue, I happened to add a spin_lock to
> memcg's bit_spin_lock in lock_page_cgroup(), and lockdep very quickly
> complained about __mem_cgroup_commit_charge_lrucare() (on CPU1 above).
> 
> So delete __mem_cgroup_commit_charge_lrucare(), passing a bool lrucare
> to __mem_cgroup_commit_charge() instead, taking zone->lru_lock under
> lock_page_cgroup() in the lrucare case.
> 
> The original was using spin_lock_irqsave, but we'd be in more trouble
> if it were ever called at interrupt time: unconditional _irq is enough.
> And ClearPageLRU before del from lru, SetPageLRU before add to lru: no
> strong reason, but that is the ordering used consistently elsewhere.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
