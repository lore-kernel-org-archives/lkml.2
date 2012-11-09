Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2KISKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:10:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab2KISKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:10:23 -0500
Date: Fri, 9 Nov 2012 19:10:48 +0100
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
Message-ID: <20121109181048.GA1184@redhat.com>
References: <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com> <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org> <20121109154656.GA26134@redhat.com> <20121109170107.GB2419@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109170107.GB2419@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Paul E. McKenney wrote:
>
> On Fri, Nov 09, 2012 at 04:46:56PM +0100, Oleg Nesterov wrote:
> > Contrary, I am going to try to add some complications later, so that
> > it can have more users. In particular, I think it can replace
> > get_online_cpus/cpu_hotplug_begin, just we need
> > percpu_down_write_but_dont_deadlock_with_recursive_readers().
>
> I must confess that I am a bit concerned about possible scalability
> bottlenecks in the current get_online_cpus(), so +1 from me on this one.

OK, thanks...

And btw percpu_down_write_but_dont_deadlock_with_recursive_readers() is
trivial, just it needs down_write(rw_sem) "inside" wait_event(), not
before. But I'm afraid I will never manage to write the comments ;)

	static bool xxx(brw)
	{
		down_write(&brw->rw_sem);
		if (!atomic_read(&brw->slow_read_ctr))
			return true;

		up_write(&brw->rw_sem);
		return false;
	}

	static void __percpu_down_write(struct percpu_rw_semaphore *brw, bool recursive_readers)
	{
		mutex_lock(&brw->writer_mutex);

		synchronize_sched();

		atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);

		if (recursive_readers)  {
			wait_event(brw->write_waitq, xxx(brw));
		} else {
			down_write(&brw->rw_sem);

			wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
		}
	}

Of course, cpu.c still needs .active_writer to allow get_online_cpus()
under cpu_hotplug_begin(), but this is simple.

But first we should do other changes, I think. IMHO we should not do
synchronize_sched() under mutex_lock() and this will add (a bit) more
complications. We will see.

Oleg.

