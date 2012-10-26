Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab2JZNWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:22:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab2JZNWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:22:49 -0400
Date: Fri, 26 Oct 2012 09:22:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
In-Reply-To: <20121026120605.GA23545@redhat.com>
Message-ID: <Pine.LNX.4.64.1210260900170.24474@file.rdu.redhat.com>
References: <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com>
 <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com> <1350650286.30157.28.camel@twins>
 <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com> <1350668451.2768.60.camel@twins>
 <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com> <20121024030845.GT4291@dastard>
 <Pine.LNX.4.64.1210251008330.1849@file.rdu.redhat.com> <20121025234048.GH29378@dastard>
 <20121026120605.GA23545@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2012, Oleg Nesterov wrote:

> On 10/26, Dave Chinner wrote:
> >
> > On Thu, Oct 25, 2012 at 10:09:31AM -0400, Mikulas Patocka wrote:
> > >
> > > Yes, mnt_want_write()/mnt_make_readonly() do the same thing as percpu rw
> > > semaphores. I think you can convert mnt_want_write()/mnt_make_readonly()
> > > to use percpu rw semaphores and remove the duplicated code.
> >
> > I think you misunderstood my point - that rather than re-inventing
> > the wheel, why didn't you just copy something that is known to
> > work?

I didn't know about. The code is not reusable, and it doesn't really do 
locking. And it has two barriers on the read path, while percpu rw 
semaphores have none.

> I don't understand why do you both think that __mnt_want_write()
> and mnt_make_readonly() provides the same functionality. I looked
> at this code before I started this patch, and unless I completely
> misread it this does very different things. It is not "lock" at all.
> 
> Oleg.

mnt_want_write uses percpu array of counters, just like percpu semaphores.

The code is different, but it can be changed to use percpu rw semaphores 
(if we add percpu_down_write_trylock).

__mnt_want_write could call percpu_down_read and check if it is readonly 
(if it is, drop the lock and return -EROFS)
__mnt_drop_write could call percpu_up_read
mnt_make_readonly and sb_prepare_remount_readonly could call 
percpu_down_write_trylock instead of mnt_get_writers (if they get the 
write lock, set it to readonly and drop the write lock)

... and that's it, then, you can remove MNT_WRITE_HOLD, the barriers, 
spinning and other complexity from fs/namespace.c

Mikulas
