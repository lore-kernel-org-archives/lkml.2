Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1BWRek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:34:40 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:34618 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755275Ab1BWRej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:34:39 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .znkNwsVM1lixbecSeD8XvimZ7SN7IPf4Pf7n10DQutTxIc
 _O9rPhoO9B3gCUKxDyjw9z6ZXN6f5YybGIPZPrd0CQ932wI0SmmO2ArGg.Kw
 UxWvXFRRc6cOVz_rHwfbGawNjDPa4wy1gQ7zAcgWCZQcFs4Umw0.hhZEUnxK
 uIy73qU0JafLHCodI0G11DSG.uyIoYt22d53yFVESAEk1GVbULxmGnw9mjpN
 H
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Feb 2011 11:34:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
In-Reply-To: <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
Message-ID: <alpine.DEB.2.00.1102231132140.562@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <20110223161645.GA1819@nowhere> <1298479302.7666.94.camel@gandalf.stny.rr.com> <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Mathieu Desnoyers wrote:

> > > > +
> > > > +	local_irq_save(flags);
> > > > +	cpu = smp_processor_id();

Drop this line.

> > > > +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {

use this_cpu_read(rcu_cpu_kthread_task)

> > > > +		local_irq_restore(flags);
> > > > +		return;
> > > > +	}
> > > > +	per_cpu(rcu_cpu_has_work, cpu) = 1;

this_cpu_write(rcu_cpu_has_work, 1);

> This is not quite true on x86_64 and s390 anymore. __get_cpu_var() now
> uses a segment selector override to get the local CPU variable on x86.
> See x86's percpu.h for details.

__get_cpu_var cannot use a segment override since there are places where
the address of the variable is taken. One needs to use this_cpu_ops for
that.


> > True, but we could also argue that the multiple checks for being preempt
> > can also be an issue.
>
> At least on x86 preemption don't actually need to be disabled: selection
> of the right per-cpu memory location is done atomically with the rest of
> the instruction by the segment selector.

Right.
