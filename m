Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2KKPoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2KKPoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:44:44 -0500
Date: Sun, 11 Nov 2012 16:45:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
	block the readers unnecessarily
Message-ID: <20121111154509.GA15652@redhat.com>
References: <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com> <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org> <20121109154656.GA26134@redhat.com> <20121109170107.GB2419@linux.vnet.ibm.com> <20121109181048.GA1184@redhat.com> <20121110005516.GM2419@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121110005516.GM2419@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Paul E. McKenney wrote:
>
> On Fri, Nov 09, 2012 at 07:10:48PM +0100, Oleg Nesterov wrote:
> >
> > 	static bool xxx(brw)
> > 	{
> > 		down_write(&brw->rw_sem);
>
> 		down_write_trylock()
>
> As you noted in your later email.  Presumably you return false if
> the attempt to acquire it fails.

Yes, yes, thanks.

> > But first we should do other changes, I think. IMHO we should not do
> > synchronize_sched() under mutex_lock() and this will add (a bit) more
> > complications. We will see.
>
> Indeed, that does put considerable delay on the writers.  There is always
> synchronize_sched_expedited(), I suppose.

I am not sure about synchronize_sched_expedited() (at least unconditionally),
but: only the 1st down_write() needs  synchronize_, and up_write() do not
need to sleep in synchronize_ at all.

To simplify, lets ignore the fact that the writers need to serialize with
each other. IOW, the pseudo-code below is obviously deadly wrong and racy,
just to illustrate the idea.

1. We remove brw->writer_mutex and add "atomic_t writers_ctr".

   update_fast_ctr() uses atomic_read(brw->writers_ctr) == 0 instead
   of !mutex_is_locked().

2. down_write() does

	if (atomic_add_return(brw->writers_ctr) == 1) {
		// first writer
		synchronize_sched();
		...
	} else {
		... XXX: wait for percpu_up_write() from the first writer ...
	}

3. up_write() does

	if (atomic_dec_unless_one(brw->writers_ctr)) {
		... wake up XXX writers above ...
		return;
	} else {
		// the last writer
		call_rcu_sched( func => { atomic_dec(brw->writers_ctr) } );
	}

Once again, this all is racy, but hopefully the idea is clear:

	- down_write(brw) sleeps in synchronize_sched() only if brw
	  has already switched back to fast-path-mode

	- up_write() never sleeps in synchronize_sched(), it uses
	  call_rcu_sched() or wakes up the next writer.

Of course I am not sure this all worth the trouble, this should be discussed.
(and, cough, I'd like to add the multi-writers mode which I'm afraid nobody
will like) But I am not going to even try to do this until the current patch
is applied, I need it to fix the bug in uprobes and I think the current code
is "good enough". These changes can't help to speedup the readers, and the
writers are slow/rare anyway.

Thanks!

Oleg.

