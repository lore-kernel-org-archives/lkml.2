Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab1EMNUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:20:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:43414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab1EMNUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:20:05 -0400
Subject: Re: [PATCH 2/2] x86: Make the x86-64 stacktrace code safely
 callable from scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110513124800.GA1840@nowhere>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
	 <1305232326-9804-3-git-send-email-fweisbec@gmail.com>
	 <1305283706.22280.40.camel@frodo>  <20110513124800.GA1840@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 15:19:58 +0200
Message-ID: <1305292798.2466.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 14:48 +0200, Frederic Weisbecker wrote:
> I haven't observed any deadlock. trace events disable preemption and
> other tracers do too (my changelog was buggy).
> 
> I just worried about potential other users, like a WARN_ON in the
> scheduler or so.
> 
> My worry is the following scenario:
> 
> schedule() {
>         acquire(rq)
>                                                         set_tsk_need_resched
>         WARN_ON() {
>                 stack_trace() {
>                         preempt_enable() {
>                                 preempt_schedule() {

Would never happen, because rq->lock is a spinlock which holds another
preempt count so preempt_enable() would never schedule.

>                                         acquire(rq)
>                                 }
>                         }
>                 }
>         }
> }



> I don't know if it happens that one set TIF_NEED_RESCHED remotely,

Yes

> or if TIF_NEED_RESCHED can be set when we hold the rq,

Yes

>  and then we
> can be followed by a WARN_ON, ...

Not quite sure, but possible.

> So I preferred to be careful. 

Still not quite seeing how all things could go bang.
