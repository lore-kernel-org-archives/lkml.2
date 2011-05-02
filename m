Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1EBIJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:09:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51327 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab1EBIJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:09:14 -0400
Date: Mon, 2 May 2011 01:09:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@lnaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Preview of RCU patches for 2.6.40
Message-ID: <20110502080906.GS2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <20110501234911.GI13542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501234911.GI13542@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 09:49:11AM +1000, Dave Chinner wrote:
> On Sun, May 01, 2011 at 06:21:42AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This patchset introduces RCU_TREE priority boosting, a new "fire and
> > forget" kfree_rcu() API, numerous uses of kfree_rcu(), plus a number
> > of other fixes and improvements.  The patches are as follows:
> 
> .....
> 
> > 34-70.	Use kfree_rcu() throughout the kernel.  This set of patches has
> > 	Acked-by's, so will go up -tip.
> > 
> > 71-86.	Ditto, but lacking Acked-by's.
> 
> Any reason why dentry and inode freeing was not converted in this
> series?

>From what I can see, they use kmem_cache_free() rather than kfree(),
so we cannot use kfree_rcu() for them.  But there are many tens of RCU
callback functions that just do kmem_cache_free(), so maybe we need
a kmem_cache_free_rcu().

Lai, any thoughts on this?  Perhaps a global array of pointers to all the
kmem_caches, so that the low-order bit can say kmem_cache_free() rather
than kfree()?  Then the offset can be encoded in the kmem_cache structure,
allowing the ->func field of rcu_head to encode only the index of the
global array of pointers to kmem_cache structures?  Or would something
else work better?

							Thanx, Paul
