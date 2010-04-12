Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0DLUcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:32:18 -0400
Received: from www.tglx.de ([62.245.132.106]:48751 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0DLUcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:32:16 -0400
Date: Mon, 12 Apr 2010 22:32:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Agner <stefan@agner.ch>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: I attached a test module to reproduce this bug. Does I miss
 something in my code or is there a bug?
In-Reply-To: <20100412182325.161358ntday18s1o@limpopo.deheime.ch>
Message-ID: <alpine.LFD.2.00.1004122207300.18009@localhost.localdomain>
References: <20100412182325.161358ntday18s1o@limpopo.deheime.ch>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

please use short and descriptive subject lines. "I attached a test
module to reproduce this bug ..." does not tell anything.

On Mon, 12 Apr 2010, Stefan Agner wrote:

> Unable to handle kernel paging request at kthread_should_stop

That would have been the real subject line :)
 
> I attached a test module to reproduce this bug.  Does I miss something in my
> code or is there a bug?

There are several bugs in your code :)

> static int runloop(void *unused)
> {
> 
> 	int ret;
> 
> 	/* Daemonize */
> 	daemonize(MODULE_NAME);

 Do not call daemonize() for a kthread created with kthread_create().
 That was necessary for kthreads created with kernel_thread.

> 	/* Allow SIGTERM signal */
> 	allow_signal(SIGTERM);

 Why do you want signals here ?

> 	/* Calculate first shot */
> 	now = ktime_get();
> 	thread_next = ktime_add_us(now, 500);
> 
> 	do {
> 		set_current_state(TASK_UNINTERRUPTIBLE);
> 		ret = schedule_hrtimeout(&thread_next, HRTIMER_MODE_ABS);
> 		if(ret == -EINTR)
> 		{

  That EINTR can never happen. You set the task to
  TASK_UNINTERRUPTIBLE state, so it cannot be woken up by a signal.
	
> int __init init_test_module(void)
> {
> 	struct sched_param param = { .sched_priority = THREAD_PRIORITY };
> 
> 	/* Kernel Thread erzeugen */
> 	if(thread == NULL)
> 		thread = kthread_create((void *)&runloop, NULL, "testthread");

 The init code is called once, so no need to check for thread == NULL
 before calling kthread_create().

 But you miss to check thread _after_ the call ....

> 	// Realtime scheduler
> 	sched_setscheduler(thread, THREAD_SCHEDULER, &param);

 Scheduler settings should happen in the thread.

> 	wake_up_process(thread);

 Simply use kthread_run(....), which implies kthread_create() and
 wake_up_process().

Thanks,

	tglx
