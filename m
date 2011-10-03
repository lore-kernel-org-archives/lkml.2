Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1JDAEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:04:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38621 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1JDAEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:04:32 -0400
Date: Mon, 3 Oct 2011 14:47:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org
Subject: Re: lockdep recursive locking detected (rcu_kthread / __cache_free)
Message-ID: <20111003214739.GK2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111003175322.GA26122@sucs.org>
 <20111003203139.GH2403@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1110031540560.11713@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110031540560.11713@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:46:11PM -0500, Christoph Lameter wrote:
> On Mon, 3 Oct 2011, Paul E. McKenney wrote:
> 
> > The first lock was acquired here in an RCU callback.  The later lock that
> > lockdep complained about appears to have been acquired from a recursive
> > call to __cache_free(), with no help from RCU.  This looks to me like
> > one of the issues that arise from the slab allocator using itself to
> > allocate slab metadata.
> 
> Right. However, this is a false positive since the slab cache with
> the metadata is different from the slab caches with the slab data. The slab
> cache with the metadata does not use itself any metadata slab caches.

Wouldn't it be possible to pass a new flag to the metadata slab caches
upon creation so that their locks could be placed in a separate lock
class?  Just allocate a separate lock_class_key structure for each such
lock in that case, and then use lockdep_set_class_and_name to associate
that structure with the corresponding lock.  I do this in kernel/rcutree.c
in order to allow the rcu_node tree's locks to nest properly.

							Thanx, Paul
