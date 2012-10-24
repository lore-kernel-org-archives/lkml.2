Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385Ab2JXDIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:08:50 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56484 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934056Ab2JXDIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:08:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooYAFZbh1B5LNyp/2dsb2JhbAA8CIUrtlSEcgKBEIEJgh4BAQU6HCMQCAMOCi4UJQMhE4gDuxYUi0wWgWyEXAOVcYlChniDAw
Date: Wed, 24 Oct 2012 14:08:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121024030845.GT4291@dastard>
References: <20121017165902.GB9872@redhat.com>
 <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com>
 <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
 <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com>
 <1350650286.30157.28.camel@twins>
 <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
 <1350668451.2768.60.camel@twins>
 <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 06:54:41PM -0400, Mikulas Patocka wrote:
> 
> 
> On Fri, 19 Oct 2012, Peter Zijlstra wrote:
> 
> > > Yes, I tried this approach - it involves doing LOCK instruction on read 
> > > lock, remembering the cpu and doing another LOCK instruction on read 
> > > unlock (which will hopefully be on the same CPU, so no cacheline bouncing 
> > > happens in the common case). It was slower than the approach without any 
> > > LOCK instructions (43.3 seconds seconds for the implementation with 
> > > per-cpu LOCKed access, 42.7 seconds for this implementation without atomic 
> > > instruction; the benchmark involved doing 512-byte direct-io reads and 
> > > writes on a ramdisk with 8 processes on 8-core machine).
> > 
> > So why is that a problem? Surely that's already tons better then what
> > you've currently got.
> 
> Percpu rw-semaphores do not improve performance at all. I put them there 
> to avoid performance regression, not to improve performance.
> 
> All Linux kernels have a race condition - when you change block size of a 
> block device and you read or write the device at the same time, a crash 
> may happen. This bug is there since ever. Recently, this bug started to 
> cause major trouble - multiple high profile business sites report crashes 
> because of this race condition.
>
> You can fix this race by using a read lock around I/O paths and write lock 
> around block size changing, but normal rw semaphore cause cache line 
> bouncing when taken for read by multiple processors and I/O performance 
> degradation because of it is measurable.

This doesn't sound like a new problem.  Hasn't this global access,
single modifier exclusion problem been solved before in the VFS?
e.g. mnt_want_write()/mnt_make_readonly()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
