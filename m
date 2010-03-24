Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0CXQRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:17:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:40644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0CXQRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:17:38 -0400
Subject: Re: [PATCH 2/6] move_task_off_dead_cpu: take rq->lock around
 select_fallback_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100324160727.GA4121@redhat.com>
References: <20100315091010.GA9131@redhat.com>
	 <1269445284.5109.360.camel@twins>  <20100324160727.GA4121@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 17:17:02 +0100
Message-ID: <1269447422.5109.408.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 17:07 +0100, Oleg Nesterov wrote:
> On 03/24, Peter Zijlstra wrote:
> >
> > On Mon, 2010-03-15 at 10:10 +0100, Oleg Nesterov wrote:
> > >  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
> > >  {
> > > +       struct rq *rq = cpu_rq(dead_cpu);
> > > +       int needs_cpu, dest_cpu;
> > > +       unsigned long flags;
> > >  again:
> > > +       local_irq_save(flags);
> > > +
> > > +       raw_spin_lock(&rq->lock);
> > > +       needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
> >
> >                                        ^ 
> > kernel/sched.c:5445: warning: ‘dest_cpu’ may be used uninitialized in this function
> 
> Hmm. looks like my gcc is more friendly...

Hrm, that and I'm apparently unable to read, it said dest_cpu, not
dead_cpu.. a well, I'll slam an __maybe_unused in.

> OK. certainly I'll send the updated patch, if this series passes
> your review otherwise.

Yeah, you made a few good points in 0/6, am now staring at the code on
how to close those holes, hope to post something sensible soon.
