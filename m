Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2BBJQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:16:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48803 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab2BBJQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:16:02 -0500
Message-ID: <1328174158.2279.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Module/kthread/printk question/problem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2012 10:15:58 +0100
In-Reply-To: <4F2A296E.5080007@linaro.org>
References: <4F2963AA.3010306@linaro.org>
	  <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <4F2969B7.4040202@linaro.org>
	 <1328116594.1882.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F2A296E.5080007@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 02 février 2012 à 10:13 +0400, Dmitry Antipov a écrit :
> On 02/01/2012 09:16 PM, Eric Dumazet wrote:
> 
> >> I realize this, but there was a second part of the question: what's the
> >> better way to ensure that all test/X threads are really gone at some point of
> >> testmod_exit()?
> >>
> >
> > You could use kthread_stop()
> >
> > This way you can control all your kernel threads really exited before
> > module cleanup.
> 
> Hm... if I try something like:
> 
> static void __exit testmod_exit(void)
> {
> 	int i;
> 
> 	wait_for_completion(&done);
> 	for (i = 0; i < nrthreads; i++)
> 		kthread_stop(threads[i]);
> 	kfree(threads);
> }

Try following code :



#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/kthread.h>
#include <linux/module.h>
#include <linux/slab.h>

MODULE_LICENSE("GPL");

static int nrthreads = 128;
module_param(nrthreads, int, 0644);

static int loopcount = 1024;
module_param(loopcount, int, 0644);

static int usehrtime = 0;
module_param(usehrtime, int, 0644);

static int slack = 50000;
module_param(slack, int, 0644);

static int msecs = 1;
module_param(msecs, int, 0644);

static struct task_struct **threads;

static int test(void *unused)
{
	 int i;
	 ktime_t expires = ktime_set(0, msecs * NSEC_PER_MSEC);

	 for (i = 0; !kthread_should_stop() && i < loopcount; i++) {
		 if (usehrtime) {
			 set_current_state(TASK_UNINTERRUPTIBLE);
			 schedule_hrtimeout_range(&expires, slack, HRTIMER_MODE_REL);
		 }
		 else
			 schedule_timeout_uninterruptible(msecs_to_jiffies(msecs));
	 }

	 return 0;
}

static int __init testmod_init(void)
{
	 int i;

	 printk("test begin\n");

	 threads = kmalloc(nrthreads * sizeof(struct task_struct *), GFP_KERNEL);
	 if (!threads)
		 return -ENOMEM;

	 for (i = 0; i < nrthreads; i++) {
		 threads[i] = kthread_create(test, NULL, "test/%d", i);
		 if (IS_ERR(threads[i])) {
			 int j, err = PTR_ERR(threads[i]);

			 for (j = 0; j < i; j++)
				 kthread_stop(threads[j]);
			 kfree(threads);
			 return err;
		 }
	 }
	 for (i = 0; i < nrthreads; i++) {
		get_task_struct(threads[i]);
		wake_up_process(threads[i]);
	 }
	 return 0;
}

static void __exit testmod_exit(void)
{
	int i;

	for (i = 0; i < nrthreads; i++) {
		kthread_stop(threads[i]);
		put_task_struct(threads[i]);
	}
	kfree(threads);
}

module_init(testmod_init);
module_exit(testmod_exit);


