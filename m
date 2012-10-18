Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2JRROV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:14:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40294 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab2JRROU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:14:20 -0400
Date: Thu, 18 Oct 2012 10:14:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [ 004/120] slab: fix the DEADLOCK issue on l3 alien lock
Message-ID: <20121018171411.GC23278@kroah.com>
References: <20121011005825.364610894@linuxfoundation.org>
 <20121011005826.156478516@linuxfoundation.org>
 <20121018132020.GB7282@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018132020.GB7282@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 09:20:20AM -0400, Steven Rostedt wrote:
> On Thu, Oct 11, 2012 at 09:59:16AM +0900, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Michael Wang <wangyun@linux.vnet.ibm.com>
> > 
> > commit 947ca1856a7e60aa6d20536785e6a42dff25aa6e upstream.
> > 
> > DEADLOCK will be report while running a kernel with NUMA and LOCKDEP enabled,
> > the process of this fake report is:
> > 
> > 	   kmem_cache_free()	//free obj in cachep
> > 	-> cache_free_alien()	//acquire cachep's l3 alien lock
> > 	-> __drain_alien_cache()
> > 	-> free_block()
> > 	-> slab_destroy()
> > 	-> kmem_cache_free()	//free slab in cachep->slabp_cache
> > 	-> cache_free_alien()	//acquire cachep->slabp_cache's l3 alien lock
> > 
> > Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
> > fake report generated.
> > 
> > This should not happen since we already have init_lock_keys() which will
> > reassign the lock class for both l3 list and l3 alien.
> > 
> > However, init_lock_keys() was invoked at a wrong position which is before we
> > invoke enable_cpucache() on each cache.
> > 
> > Since until set slab_state to be FULL, we won't invoke enable_cpucache()
> > on caches to build their l3 alien while creating them, so although we invoked
> > init_lock_keys(), the l3 alien lock class won't change since we don't have
> > them until invoked enable_cpucache() later.
> > 
> > This patch will invoke init_lock_keys() after we done enable_cpucache()
> > instead of before to avoid the fake DEADLOCK report.
> > 
> > Michael traced the problem back to a commit in release 3.0.0:
> 
> I don't see this fix in the last 3.0 stable release. Shouldn't it go
> there too?

As-is, it doesn't apply at all.  If someone provides me a backport, I'll
be glad to apply it there.

thanks,

greg k-h
