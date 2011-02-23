Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1BWTkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:40:46 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:27996 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751539Ab1BWTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:40:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9SWVVdIVM1lX6AKkLsIwtTus9WhnEfXQsFq._gzjrmkRdvQ
 OSixuP1Ql1IhZDWTBzpGYc.6jp4uRhsuM4Goll3ZL56LWnu2MaXiDior802A
 TrCgmUZlUrchcIZEXzIGNzIZMei4UTZrTI43XZs5OuASCOPENsNHbedQmRad
 FppgqzpX8DBaCgnanLw8jbqY4Ghpkr0joOj9UV_RGkbsNiCzFEZJFz0hBnyM
 gmaGdlUOiUbtct4udbTgUVyDJ09vmSfdoWBiJhUNQK0ZVgcBydKweW6o96No
 GGUyxPhIPw1ehVfrYsysCoDl6Z67woVrYaAWXCgZlWEZyuNo-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Feb 2011 13:40:37 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
In-Reply-To: <1298489030.2217.818.camel@twins>
Message-ID: <alpine.DEB.2.00.1102231337340.4823@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com>  <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>  <20110223161645.GA1819@nowhere>  <1298479302.7666.94.camel@gandalf.stny.rr.com>  <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl> 
 <alpine.DEB.2.00.1102231132140.562@router.home>  <1298485027.7666.98.camel@gandalf.stny.rr.com>  <alpine.DEB.2.00.1102231225330.3906@router.home>  <1298485965.7666.102.camel@gandalf.stny.rr.com>  <alpine.DEB.2.00.1102231317550.4823@router.home>
 <1298489030.2217.818.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Peter Zijlstra wrote:

> On Wed, 2011-02-23 at 13:19 -0600, Christoph Lameter wrote:
>
> > this_cpu_inc is already percpu atomic. On x86 it is an instruction that
> > cannot be interrupted nor preempted while in progress.
>
> On x86, yes, but is this true for all architectures? I guess the
> fallback is implemented with local_irq_disable() which might be good
> enough for some but not for NMI usage.

Fallback is to do preempt_disable(). But you can also disable interrupts
on fallback by putting an irqsafe_ prefix before them. Its just more
expensive and typically not needed.

There is no way to create an nmi safe per cpu atomicity emulation as far
as I can tell. It is possible to check at compile time if the arch has
per cpu atomic instructions available via CONFIG_CMPXCHG_LOCAL which
allows optimized per cpu atomic use for arches that satisfy the safety
requirements.
