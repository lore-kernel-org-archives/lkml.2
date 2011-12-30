Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1L3WZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 17:25:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1L3WZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 17:25:44 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=rrYGrSk31WUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Oc60lQwaBigmYfxwCdkA:9 a=QnvJoPpAVbnYh0NSU_MA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325283941.24045.15.camel@gandalf.stny.rr.com>
Subject: Re: ftrace performance impact with different configuration
From: Steven Rostedt <rostedt@goodmis.org>
To: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        leiwen@marvell.com, Lei Wen <adrian.wenl@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Dec 2011 17:25:41 -0500
In-Reply-To: <23257775.9kkYY4quUh@laptop>
References: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com>
	 <CAH+eYFDb4r235jAGjr7j5R5C+9YK9WeXXjVZGWQUB=330sOi0Q@mail.gmail.com>
	 <1325175685.24045.5.camel@gandalf.stny.rr.com> <23257775.9kkYY4quUh@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-30 at 14:07 +0100, Philippe Rétornaz wrote:

> Sorry about being a bit naive, but why it is not possible to do it in two 
> steps ?
> call stop_machine to put the jmp which skip the call to mcount
> Then wait until all tasks hits schedule() (synchronize_sched() ?)

Here's the problem. With a preemptible kernel, hitting schedule() does
not mean that you can guarantee that all tasks have not been
interrupted.


	nop (use to be push lr)
	------------> interrupt
			set NEED_RESCHED
			end of interrupt
			preempt_schedule()
				schedule()

	[ another processes is now running ]
	call stop_machine()
	put in push lr
	call stop_machine()
	put in call to mcount

	everything seems to be running fine.

	the low priority task gets scheduled again...


				schedule() finishes
			preempt_schedule() finishes
			back at tail of return_from_intr in entry_64.S
			iret
	call mcount
			pop lr (which was never pushed)
			jmp lr

Now we jump back to some random stuff and the stack is corrupted.

There's no way to safely modify two instructions that depend on each
other in a preemptible kernel, with the exception of waiting for all
CPUs to hit idle (which may never happen on a busy system). And even
that may be racy.

-- Steve

> Then modify both instructions to put in place the two nops since we know that 
> nobody is calling mcount.


