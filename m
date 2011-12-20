Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1LTW1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:27:40 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31457 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab1LTW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:27:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKUK8U55LL6d/2dsb2JhbAA7CKwEgQaBcgEBBTocIxAIAxguFCUDIRO/JBOIQ4JTYwSUfokciSk
Date: Wed, 21 Dec 2011 09:27:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220222734.GA23662@dastard>
References: <4EF03915.60902@linux.vnet.ibm.com>
 <1324373854.21588.16.camel@mengcong>
 <4EF0654B.4060904@linux.vnet.ibm.com>
 <4EF06C9B.4010703@linux.vnet.ibm.com>
 <4EF084A4.3000106@linux.vnet.ibm.com>
 <20111220140628.GD23916@ZenIV.linux.org.uk>
 <4EF09D34.1060607@linux.vnet.ibm.com>
 <20111220175919.GE23916@ZenIV.linux.org.uk>
 <4EF0DE04.6030604@linux.vnet.ibm.com>
 <20111220195806.GF23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220195806.GF23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 07:58:06PM +0000, Al Viro wrote:
> On Wed, Dec 21, 2011 at 12:42:04AM +0530, Srivatsa S. Bhat wrote:
> > register_hotcpu_notifier(...);
> > grab spinlock
> > for_each_online_cpu(N)
> >   add N to bitmap
> > release spinlock
> > 
> > because the latter code is not fully race-free (because we don't handle
> > CPU_DOWN_PREPARE event in the callback and hence cpu_online_mask can get
> > updated in-between). But it would still work since cpus going down don't
> > really pose problems for us.
> 
> Um?  Sure, that loop can end up adding CPUs on their way down into the set.
> And as soon as they get their CPU_DEAD, notifier will prune them out...  Or
> is there something I'm missing here?  Anyway, the variant I have here
> (untested) follows:

Only thing that concerns me about this patch is the bitmap changing
between lock and unlock operations. i.e.

CPU 1: lock all cpus in mask
CPU 2: brings up new cpu, notifier adds CPU to bitmask
CPU 1: unlock all cpus in mask

And in this case the unlock tries to unlock a cpu that wasn't locked
to start with. It really seems to me that while a global lock is in
progress, the online bitmask cannot be allowed to change.

Perhaps something can be passed between the lock and unlock
operations to be able to detect a changed mask between lock/unlock
operations (e.g. a generation number) and then handle that via a
slow path that unlocks only locks that are active in the online
bitmask?  i.e. all the notifier does is bump the generation count,
and the slow path on the unlock handles everything else?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
