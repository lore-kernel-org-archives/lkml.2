Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab0FJPLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:11:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:43694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0FJPLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:11:49 -0400
Subject: Re: BUG: sched:sched_migrate_task event tracing returns incorrect
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Ronny =?ISO-8859-1?Q?Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C10FD1C.7080200@tu-dresden.de>
References: <4C10FD1C.7080200@tu-dresden.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 17:11:41 +0200
Message-ID: <1276182701.2077.462.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 16:56 +0200, Ronny Tschüter wrote:
> Hi,
> 
> I want to know a little bit more about the execution of my program. 
> Especially I'm interested in cpu migrations of my process. Therefore I 
> use the Linux performance counter infrastructure, set appropriate 
> perf_event attributes and setup the sched:sched_migrate_task event with 
> a system call:
> ...
> attr.type = PERF_TYPE_TRACEPOINT;
> attr.size = sizeof( struct perf_event_attr );
> attr.config = event_id; // id of sched:sched_migrate_task event
> attr.sample_type = PERF_SAMPLE_TIME|PERF_SAMPLE_CPU|PERF_SAMPLE_RAW;
> attr.freq = 0;
> attr.sample_freq = 1;
> fd = syscall( __NR_perf_counter_open, &attr, getpid(), -1, -1, 0 );
> ...
> Finally to read the events I map the kernel event buffer via mmap and 
> process every event in this buffer. However I run into two problems:
> 
> (1) I need root privileges to open the counter successfully. Without 
> root privileges syscall returns -1. I think that is not OK because users 
> should be allowed to create per task counters.

It is, because you specify PERF_SAMPLE_RAW, which is considered a data
leak for unpriv users.

> (2) The buffer contains events that aren't caused by my process (i.e. 
> the COMM field does not contain the name of my process and the PID field 
> is not equal to the pid of my process).

I think that could happen if the migration happens from interrupt
context while your task is running. Also wakeups your process does can
result in migrations of the woken task from the context of your task.
