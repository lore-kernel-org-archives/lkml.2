Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab2BTQaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:30:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:53255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2BTQaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:30:12 -0500
Message-ID: <1329755402.2293.365.camel@twins>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 17:30:02 +0100
In-Reply-To: <CAPM31R+xLCnPE10SZRYnTMe=O=j5mZEoutH=e3npw5xKOS_s7w@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
	 <1329411510.2293.254.camel@twins>
	 <CAPM31R+xLCnPE10SZRYnTMe=O=j5mZEoutH=e3npw5xKOS_s7w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 03:32 -0800, Paul Turner wrote:

> Since we do not know where we slept relative to the tick, unless we
> explicitly track where this occurred we don't know for a "n.y" jiffy
> sleep whether the "0.y" fraction included an extra decay. 

but isn't that the same problem you have in
__update_entity_runnable_avg() where you use ->runnable_avg_period %
1024 ?

Also, shouldn't __synchronize_entity_decay() update
->runnable_avg_period? Surely when you wake up your window fraction
could be different than when you went to sleep?

>  It's
> important to get this right to reduce instability, since when the
> entity wakes back up we need to charge an equivalent decay against
> it's contribution before we can remove it from the blocked_load_sum.
> 
> For the common case of a short sleep whether we charge an extra period
> (if y included a jiffy edge) or not is significant to stability since
> getting it wrong means we leave a little extra load in blocked_load.

Sure..

> Further complicating this we need to be able to do said
> synchronization in the annoying cases of wake-up migration (where we
> don't hold the lock on previous rq) and 32-bit machines (where
> everything sucks).

Ah, wouldn't task_waking_fair() be a better place though?

> >
> > C) 'Migrate'
> >    - uses contributes_blocked_load to check if we actually did migrate?
> >
> 
> We actually use se->avg.decay_count to check whether we were migrated
> (setting it appropriately at migration); contributes_blocked_load is
> just a convenience variable to track whether we're a part of
> cfs_rq->blocked_load_avg or not.

If you use task_waking_fair() you can also use ENQUEUE_WAKING.

> There's a one or two other paths (than ttwu) that this matters for,
> using set_task_rq() gets them all.

What paths are those? Having a cfs hook in the generic code there isn't
pretty an suggests funny things could happen when PI gets done.

