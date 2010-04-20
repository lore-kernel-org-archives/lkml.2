Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0DTXA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:00:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54347 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0DTXAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:00:55 -0400
X-Authority-Analysis: v=1.1 cv=ZUag8tkj9kgmNMrzofuoEsXxpG43g9sRv4eUZcQ4+as= c=1 sm=0 a=eOOYVsMsLpwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=mx-tpX3RaX2WCM4R2LsA:9 a=SeCOUZLyZGnKl9vbdtgA:7 a=MPYBzRg3a9dvLP0X2MQPNfHi14YA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Considerations on sched APIs under RT patch
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Primiano Tucci <p.tucci@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 20 Apr 2010 19:00:53 -0400
Message-ID: <1271804453.10448.168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 23:56 +0200, Primiano Tucci wrote:
> Hi Peter,

> long sched_setaffinity(pid_t pid, const struct cpumask *in_mask) {
> 	cpumask_var_t cpus_allowed, new_mask;
> 	struct task_struct *p;
> 	int retval;
> 
> 	get_online_cpus();
> -->	read_lock(&tasklist_lock);
> 
> 
> My question is: suppose that tasklist_lock is held by a writer.
> What happens to the calling thread? It can't take the lock, therefore
> it yields to the next ready task (that in my scenario has a lower
> priority).
> In my view, this is not a Priority Inversion problem. The problem is
> that the sched_setaffinity is unexpectedly "suspensive" and yields to
> the lower thread.

read_locks are converted into "special" rt_mutexes. The only thing
special about them, is the owner may grab the same read lock more than
once (recursive).

If a lower priority process currently holds the tasklist_lock for write,
when a high priority process tries to take it for read (or write for
that matter) it will block on the lower priority process. But that lower
priority process will acquire the priority of the higher priority
process (priority inheritance) and will run at that priority until it
releases the lock. Then it will go back to its low priority and the
higher priority process will then preempt it and acquire the lock for
read.

The above is what is expected.

-- Steve


