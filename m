Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1BWSiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:38:19 -0500
Received: from blu0-omc1-s37.blu0.hotmail.com ([65.55.116.48]:16708 "EHLO
	blu0-omc1-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab1BWSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:38:18 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP74223132108BB524FE9A6796DB0@phx.gbl>
Date: Wed, 23 Feb 2011 13:38:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
	to kthread
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <20110223161645.GA1819@nowhere> <1298479302.7666.94.camel@gandalf.stny.rr.com> <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl> <alpine.DEB.2.00.1102231132140.562@router.home> <1298485027.7666.98.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1298485027.7666.98.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:28:22 up 322 days,  4:18,  6 users,  load average: 2.27, 2.22,
	1.98
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 18:38:16.0678 (UTC) FILETIME=[D5D61060:01CBD388]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-02-23 at 11:34 -0600, Christoph Lameter wrote:
> 
> > > > True, but we could also argue that the multiple checks for being preempt
> > > > can also be an issue.
> > >
> > > At least on x86 preemption don't actually need to be disabled: selection
> > > of the right per-cpu memory location is done atomically with the rest of
> > > the instruction by the segment selector.
> > 
> > Right.
> 
> But a test still needs to be made. Because three access of this_cpu_*()
> that gets preempted and scheduled on another CPU can access a different
> CPU var for each access. This does not matter how atomic the
> this_cpu_*() code is.
> 
> IOW, the use of this_cpu_*() without preemption disabled is 99% of the
> time a bug.

Agreed. Unless the algorithm is carefully crafted to allow being
migrated in between the ops (which is a non-trivial exercise), these
would be bugs.

As far as I am aware, there are at least two cases where leaving preempt
enabled makes sense: if we use cmpxchg or add_return, these can be
followed by tests on the return value and allow creation of preemptable
fast-paths that allow migration between the per-cpu op and the following
test (useful to keep per-cpu counters that are summed into global
counters when some power-of-2 threshold value is reached in the
low-order bits). Using cpuid field within atomically updated variable
can also allow detection of migration between the operations. In
addition, we can add the trivial single update case, but this really
does not count as a non-trivial algorithm.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
