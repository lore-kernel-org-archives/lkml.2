Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2EKEkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:40:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57063 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2EKEkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:40:16 -0400
Date: Fri, 11 May 2012 00:39:51 -0400 (EDT)
Message-Id: <20120511.003951.1470088131186301605.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 05/17] mm: allow PF_MEMALLOC from softirq context
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336657510-24378-6-git-send-email-mgorman@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<1336657510-24378-6-git-send-email-mgorman@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 21:39:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Thu, 10 May 2012 14:44:58 +0100

> This is needed to allow network softirq packet processing to make
> use of PF_MEMALLOC.
> 
> Currently softirq context cannot use PF_MEMALLOC due to it not being
> associated with a task, and therefore not having task flags to fiddle
> with - thus the gfp to alloc flag mapping ignores the task flags when
> in interrupts (hard or soft) context.
> 
> Allowing softirqs to make use of PF_MEMALLOC therefore requires some
> trickery.  We basically borrow the task flags from whatever process
> happens to be preempted by the softirq.
> 
> So we modify the gfp to alloc flags mapping to not exclude task flags
> in softirq context, and modify the softirq code to save, clear and
> restore the PF_MEMALLOC flag.
> 
> The save and clear, ensures the preempted task's PF_MEMALLOC flag
> doesn't leak into the softirq. The restore ensures a softirq's
> PF_MEMALLOC flag cannot leak back into the preempted process.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

We're now making changes to task->flags from both base and
softirq context, but with non-atomic operations and no other
kind of synchronization.

As far as I can tell, this has to be racy.

If this works via some magic combination of invariants, you
absolutely have to document this, verbosely.
