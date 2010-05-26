Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0EZTgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:36:01 -0400
Received: from mga10.intel.com ([192.55.52.92]:17356 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756677Ab0EZTf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,305,1272870000"; 
   d="scan'208";a="802142696"
Subject: Re: [PATCH 2/2] tmpfs: Make tmpfs scalable with caches for free
 blocks
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
In-Reply-To: <20100520161324.5b4b146d.akpm@linux-foundation.org>
References: <1274225672.31973.8951.camel@mudge.jf.intel.com>
	 <20100520161324.5b4b146d.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:33:38 -0700
Message-ID: <1274902418.31973.9395.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 16:13 -0700, Andrew Morton wrote:

> >
> > -		spin_lock(&sbinfo->stat_lock);
> > -		sbinfo->free_blocks += pages;
> > +		spin_lock(&inode->i_lock);
> > +		qtoken_return(&sbinfo->token_jar, pages);
> >  		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
> > -		spin_unlock(&sbinfo->stat_lock);
> > +		spin_unlock(&inode->i_lock);
> 
> Well most of the calls into the qtoken layer occur under inode->i_lock.
> So did we really need that spinlock inside the qtoken library code?
> 
> It is a problem when library code such as qtoken performs its own
> internal locking.  We have learned that such code is much more useful
> and flexible if it performs no locking at all, and requires that
> callers provide the locking (lib/rbtree.c, lib/radix-tree.c,
> lib/prio_heap.c, lib/flex_array.c, etcetera).  Can we follow this
> approach with qtoken?
> 

Andrew,

The inode->i_lock only locks a single inode. The token jar is shared by
all the inodes using the tmpfs so we do not want to use inode->i_lock to
lock the entire token jar for performance reason.  With the qtoken
scheme, the spinlock inside the qtoken library is used only to protect
the free tokens in the common pool of the token jar.  Most of the time,
this lock need not be taken as we can operate with the tokens in the per
cpu cache of the token jar.  We will only need to take the lock when we
run out of tokens in cache.  We put the intelligence in the library to
manage the cache and decides when it is necessary to lock and access the
free tokens in the common pool.  It is better to leave the locking
decision in the library code rather than exposing it to the user.
Otherwise the user will need to check whether tokens should be taken
from cache or the common pool and duplicate the code in qtoken library.

Regards,
Tim Chen



