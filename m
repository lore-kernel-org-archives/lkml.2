Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab2JZOMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab2JZOL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:11:57 -0400
Date: Fri, 26 Oct 2012 16:12:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121026141238.GA28443@redhat.com>
References: <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com> <1350650286.30157.28.camel@twins> <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com> <1350668451.2768.60.camel@twins> <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com> <20121024030845.GT4291@dastard> <Pine.LNX.4.64.1210251008330.1849@file.rdu.redhat.com> <20121025234048.GH29378@dastard> <20121026120605.GA23545@redhat.com> <Pine.LNX.4.64.1210260900170.24474@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210260900170.24474@file.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26, Mikulas Patocka wrote:
>
> On Fri, 26 Oct 2012, Oleg Nesterov wrote:
>
> I didn't know about. The code is not reusable, and it doesn't really do
> locking.

That was my main point.

As for the changing fs/namespace.c to use percpu_rwsem, I am not sure
it is that simple and even worthwhile but I won't argue, I do not
pretend I understand this code.

> > I don't understand why do you both think that __mnt_want_write()
> > and mnt_make_readonly() provides the same functionality. I looked
> > at this code before I started this patch, and unless I completely
> > misread it this does very different things. It is not "lock" at all.
> >
> > Oleg.
>
> mnt_want_write uses percpu array of counters, just like percpu semaphores.

and this is all imo ;)

> The code is different, but it can be changed to use percpu rw semaphores
> (if we add percpu_down_write_trylock).

I don't really understand how you can make percpu_down_write_trylock()
atomic so that it can be called under br_write_lock(vfsmount_lock) in
sb_prepare_remount_readonly(). So I guess you also need to replace
vfsmount_lock at least. Or _trylock needs the barriers in _down_read.
Or I missed something.

Oleg.

