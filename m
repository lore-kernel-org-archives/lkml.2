Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1ATBKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:10:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:12793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1ATBJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:09:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,347,1291622400"; 
   d="scan'208";a="698606696"
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20110119165247.cca2f434.akpm@linux-foundation.org>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	 <20110119135546.bb7e8f62.akpm@linux-foundation.org>
	 <1295484358.15213.25.camel@yhuang-dev>
	 <20110119165247.cca2f434.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 09:09:56 +0800
Message-ID: <1295485796.15213.38.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 08:52 +0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 08:45:58 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > On Thu, 2011-01-20 at 05:55 +0800, Andrew Morton wrote:
> > > I'm trying to remember why we're talking about this.
> > > 
> > > You had an ACPI-based "hardware error reporting" thing.  And that
> > > required an nmi-context memory allocator.  And that required a
> > > "lockless" list implementation.
> > > 
> > > Yes?
> > 
> > Yes.  But the "lockless" list implementation is general, it can be used
> > by other part of kernel too,  such as irq_work and xlist in
> > net/rds/xlist.h in the patchset.
> 
> Well.  Lots of things are general but that doesn't mean we toss them
> into the kernel when we already have plenty of infrastructure to handle
> that sort of thing.
> 
> otoh, hoisting xlist.h out of net/rds and making it generally available
> is a good thing.
> 
> otooh, net/rds/ probably didn't need xlist at all and could have used
> existing general code.

>From commit description of xlist, it seems that xlist is created for
some performance issue.

commit 6fa70da6081bbcf948801fd5ee0be4d222298a43
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Jun 11 11:17:59 2010 -0700

    rds: recycle FMRs through lockless lists
    
    FRM allocation and recycling is performance critical and fairly lock
    intensive.  The current code has a per connection lock that all
    processes bang on and it becomes a major bottleneck on large systems.
    
    This changes things to use a number of cmpxchg based lists instead,
    allowing us to go through the whole FMR lifecycle without locking inside
    RDS.

    [snip]

So general list may be not good for them.

> So...  I'd say that unless and until the NMI-context allocator is
> merged, the case for merging the lockless list code is a bit marginal? 

In fact, lockless allocator is not really depends on llist, it just
depends on the ARCH_HAVE_NMI_SAFE_CMPXCHG patch in the patchset.

> Or have you identified other code sites which could use llist and which
> would gain some benefit from migrating?

The llist will be used by APEI (ACPI Platform Error Interface, that is,
an ACPI-based "hardware error reporting" thing).  It may be used by
other hardware error reporting mechanisms too, which involves NMI or
NMI-like notification method.

Best Regards,
Huang Ying


