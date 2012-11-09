Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2KIMs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:48:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2KIMsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:48:21 -0500
Date: Fri, 9 Nov 2012 07:47:15 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
 block the readers unnecessarily
In-Reply-To: <20121108120700.42d438f2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1211090743210.10254@file.rdu.redhat.com>
References: <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com>
 <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com>
 <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
 <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com>
 <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Nov 2012, Andrew Morton wrote:

> On Thu, 8 Nov 2012 14:48:49 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Currently the writer does msleep() plus synchronize_sched() 3 times
> > to acquire/release the semaphore, and during this time the readers
> > are blocked completely. Even if the "write" section was not actually
> > started or if it was already finished.
> > 
> > With this patch down_write/up_write does synchronize_sched() twice
> > and down_read/up_read are still possible during this time, just they
> > use the slow path.
> > 
> > percpu_down_write() first forces the readers to use rw_semaphore and
> > increment the "slow" counter to take the lock for reading, then it
> > takes that rw_semaphore for writing and blocks the readers.
> > 
> > Also. With this patch the code relies on the documented behaviour of
> > synchronize_sched(), it doesn't try to pair synchronize_sched() with
> > barrier.
> > 
> > ...
> >
> >  include/linux/percpu-rwsem.h |   83 +++++------------------------
> >  lib/Makefile                 |    2 +-
> >  lib/percpu-rwsem.c           |  123 ++++++++++++++++++++++++++++++++++++++++++
> 
> The patch also uninlines everything.
> 
> And it didn't export the resulting symbols to modules, so it isn't an
> equivalent.  We can export thing later if needed I guess.
> 
> It adds percpu-rwsem.o to lib-y, so the CONFIG_BLOCK=n kernel will
> avoid including the code altogether, methinks?

If you want to use percpu-rwsem only for block devices then you can remove 
Oleg's patch at all. Oleg's optimizations are useless for block device use 
case (the contention between readers and writers is very rare and it 
doesn't matter if readers are blocked in case of contention). I suppose 
that Oleg made the optimizations because he wants to use percpu-rwsem for 
something else - if not, you can drop the patch and revert to the previois 
version that is simpler.

Mikulas
