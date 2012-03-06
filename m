Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030919Ab2CFPf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:35:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030792Ab2CFPf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:35:27 -0500
Message-ID: <1331048093.11248.317.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, tj@kernel.org
Date: Tue, 06 Mar 2012 16:34:53 +0100
In-Reply-To: <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331032571.11248.277.camel@twins>
	 <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 23:12 +0800, Lai Jiangshan wrote:
> On Tue, Mar 6, 2012 at 7:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> >>         srcu_head is bigger, it is worth, it provides more ability and simplify
> >>         the srcu code.
> >
> > Dubious claim.. memory footprint of various data structures is deemed
> > important. rcu_head is 16 bytes, srcu_head is 32 bytes. I think it would
> > be real nice not to have two different callback structures and not grow
> > them as large.
> 
> CC: tj@kernel.org
> It could be better if workqueue also supports 2*sizeof(long) work callbacks.

That's going to be very painful if at all possible.

> I prefer ability/functionality a little more, it eases the caller's pain.
> preemptible callbacks also eases the pressure of the whole system.
> But I'm also ok if we limit the srcu-callbacks in softirq.

You don't have to use softirq, you could run a complete list from a
single worklet. Just keep the single linked rcu_head list and enqueue a
static (per-cpu) worker to process the entire list.
