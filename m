Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2KTOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:38:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:38:37 -0500
Date: Tue, 20 Nov 2012 06:38:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Daniel Wagner <wagi@monom.org>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] netprio_cgroup: reimplement priomap expansion
Message-ID: <20121120143832.GO15971@htj.dyndns.org>
References: <1353400211-5182-1-git-send-email-tj@kernel.org>
 <1353400211-5182-5-git-send-email-tj@kernel.org>
 <50AB435E.8060901@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB435E.8060901@monom.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Daniel.

On Tue, Nov 20, 2012 at 09:46:22AM +0100, Daniel Wagner wrote:
> struct netprio_map {
> 	struct rcu_head rcu;
> 	struct netprio_aux *aux;	/* auxiliary config array */
> 	u32 priomap_len;
> 	u32 priomap[];
> };
> 
> Is there a specific reason why aux and priomap is handled
> differently? Couldn't you just use same approach for both variables,
> e.g. re/allocating only them here and leave the allocation struct
> netprio_map in cgrp_css_alloc()?

->aux is no longer added, so the consistency issue doesn't exist
anymore.  The reason why they were handled differently before (or
rather why I didn't change priomap[] to be allocated separately) was
that pointer chasing tends to be more expensive than offsetting.  I
don't know how much effect it would have in this case but things
sitting in packet in/out paths can be very hot so didn't wanna disturb
it.

> Also the algorithm to figure out the size of the array might be a
> bit too aggressive in my opinion. So you always start at
> PRIOMAP_MIN_SIZE and then try to double the size until target_idx
> fits. Wouldn't it make sense to start to look for the new size
> beginning at old->priomap_len and then do the power-of-two increase?

The only downside of always starting from PRIOMAP_MIN_SIZE is
iterating several more times in the sizing loop which isn't really
anything to worry about.  The loop is structured that way because I
wanted to keep the size of the whole thing power-of-two.  Due to the
fields before priomap[], if we size priomap_len power-of-two, we'll
always end up with something slightly over power-of-two, which is
usually the worst size to allocate.

Thanks.

-- 
tejun
