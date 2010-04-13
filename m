Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab0DMTer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0DMTep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:34:45 -0400
Date: Tue, 13 Apr 2010 21:32:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
Subject: Re: [RFC][PATCH 08/11] sched: send SIGXCPU at -deadline task
	overruns.
Message-ID: <20100413193201.GA18835@redhat.com>
References: <1267383976.13676.79.camel@Palantir> <1267385046.13676.97.camel@Palantir> <1271182942.4807.1881.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271182942.4807.1881.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Peter Zijlstra wrote:
>
> On Sun, 2010-02-28 at 20:24 +0100, Raistlin wrote:
> >
> > +#define dl_se_signal(se, s, msg)					\
> > + do {									\
> > +  struct task_struct *t = dl_task_of(se);				\
> > +  sigaddset(&t->pending.signal, s);					\
> > +  set_tsk_thread_flag(t, TIF_SIGPENDING);				\
> > +  printk(KERN_INFO msg "in %d (%s)\n", task_pid_nr(t), t->comm);	\
> > + } while (0)
> > +

Without ->siglock?

This is racy even if dl_task_of(se) == current, but I guess it can
be !current. For example, we must never set TIF_SIGPENDING without
wake_up_state(). A fatal signal should kill the whole process, etc.
Even sigaddset() itself can race with tkill, it is not atomic.

Oleg.

