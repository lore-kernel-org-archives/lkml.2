Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2KJAzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:55:24 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41340 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KJAzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:55:22 -0500
Date: Fri, 9 Nov 2012 16:55:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
 block the readers unnecessarily
Message-ID: <20121110005516.GM2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121031194135.GA504@redhat.com>
 <20121031194158.GB504@redhat.com>
 <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
 <20121102180606.GA13255@redhat.com>
 <20121108134805.GA23870@redhat.com>
 <20121108134849.GB23870@redhat.com>
 <20121108120700.42d438f2.akpm@linux-foundation.org>
 <20121109154656.GA26134@redhat.com>
 <20121109170107.GB2419@linux.vnet.ibm.com>
 <20121109181048.GA1184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109181048.GA1184@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111000-5406-0000-0000-000001EB5C2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 07:10:48PM +0100, Oleg Nesterov wrote:
> On 11/09, Paul E. McKenney wrote:
> >
> > On Fri, Nov 09, 2012 at 04:46:56PM +0100, Oleg Nesterov wrote:
> > > Contrary, I am going to try to add some complications later, so that
> > > it can have more users. In particular, I think it can replace
> > > get_online_cpus/cpu_hotplug_begin, just we need
> > > percpu_down_write_but_dont_deadlock_with_recursive_readers().
> >
> > I must confess that I am a bit concerned about possible scalability
> > bottlenecks in the current get_online_cpus(), so +1 from me on this one.
> 
> OK, thanks...
> 
> And btw percpu_down_write_but_dont_deadlock_with_recursive_readers() is
> trivial, just it needs down_write(rw_sem) "inside" wait_event(), not
> before. But I'm afraid I will never manage to write the comments ;)
> 
> 	static bool xxx(brw)
> 	{
> 		down_write(&brw->rw_sem);

		down_write_trylock()

As you noted in your later email.  Presumably you return false if
the attempt to acquire it fails.

> 		if (!atomic_read(&brw->slow_read_ctr))
> 			return true;
> 
> 		up_write(&brw->rw_sem);
> 		return false;
> 	}
> 
> 	static void __percpu_down_write(struct percpu_rw_semaphore *brw, bool recursive_readers)
> 	{
> 		mutex_lock(&brw->writer_mutex);
> 
> 		synchronize_sched();
> 
> 		atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
> 
> 		if (recursive_readers)  {
> 			wait_event(brw->write_waitq, xxx(brw));

I see what you mean about acquiring brw->rw_sem inside of wait_event().

Cute trick!

The "recursive_readers" is a global initialization-time thing, right?

> 		} else {
> 			down_write(&brw->rw_sem);
> 
> 			wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
> 		}
> 	}

Looks like it should work, and would perform and scale nicely even
if we end up having to greatly increase the number of calls to
get_online_cpus().

> Of course, cpu.c still needs .active_writer to allow get_online_cpus()
> under cpu_hotplug_begin(), but this is simple.

Yep, same check as now.

> But first we should do other changes, I think. IMHO we should not do
> synchronize_sched() under mutex_lock() and this will add (a bit) more
> complications. We will see.

Indeed, that does put considerable delay on the writers.  There is always
synchronize_sched_expedited(), I suppose.

							Thanx, Paul

