Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1ADR1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:27:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1ADR1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:27:03 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=MsfxUTlnwtkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Ct3KpmEn6wzl-ax-vRIA:9 a=eNxaAOHMdy7k3UBXTTYA:7 a=iY3A_Vy0VZ9dj6iRpArSCvQHxlwA:4 a=PUjeQqilurYA:10 a=WsGbVyN5T98ustuj:21 a=a0iCG_TXSBU_U88X:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: Steven Rostedt <rostedt@goodmis.org>
To: pmorreale@novell.com
Cc: Gregory Haskins <ghaskins@novell.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1294161347.3371.80.camel@hermosa.morreale.net>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
	 <1294081596.3948.192.camel@gandalf.stny.rr.com>
	 <1294086147.3948.194.camel@gandalf.stny.rr.com>
	 <1294154349.3371.24.camel@hermosa.morreale.net>
	 <1294156079.3948.209.camel@gandalf.stny.rr.com>
	 <1294161347.3371.80.camel@hermosa.morreale.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 04 Jan 2011 12:27:00 -0500
Message-ID: <1294162020.3948.215.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 10:15 -0700, Peter W. Morreale wrote:

> My bad.  I thought preemption did change task state.
> 
> This still requires the owner to run through try_to_wake_up() and all
> its associated overhead only to find out that the waiter is running.  
> 
> The assumption I made when I suggested the original concept to Greg was
> that if the new owner is running, there is *nothing* to do wrt
> scheduling.  If that was a wrong assumption, then, yes, drop the patch
> and clean things up.  
> 
> If that was a good assumption, then we are leaving 'cycles on the table'
> as waking up a running process is a non-zero-overhead path and that is a
> bad thing considering how many times spin_unlock() is called on an rt
> system.
> 
> Bear in mind that this savings scales directly as the number of CPUs
> (assuming all are vectored on the lock).  We can only have nr_cpus-1
> spinning waiters at any given time, regardless of the number of tasks in
> contention.  Perhaps this is too little to worry about on a 4way system,
> but I suspect that it could be substantial on larger systems.  
> 
> I'll be quiet now as I know little about the intricacies of
> preemption/scheduling (obviously) and like Greg, have been removed from
> RT kernel work for several years. <sigh>

No need to be quiet ;-)

I'm working on making it spin in TASK_RUNNING state if possible, but it
is making the code a bit more complex, as it seems that there is an
assumption with the wakeup and the changing of the current->state in the
rt_spin_lock_slowlock code all being under the lock->wait_lock. I think
I'll scrap this idea.

That said, I think your wakeup patch may be worth while with Lai's new
code. His changes causes the owner to wake up the pending owner several
times, because the pending owner is never removed from the lock
wait_list. If a high prio task grabs and releases the same lock over and
over, if there is a waiter it will try to wake up that waiter each time.

Thus, having your patch may prevent that unnecessary wakeup.

I'll look more into it. Thanks!

-- Steve



