Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2BBHpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 02:45:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50738 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2BBHpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 02:45:05 -0500
Message-ID: <1328168701.2902.14.camel@edumazet-laptop>
Subject: Re: Module/kthread/printk question/problem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2012 08:45:01 +0100
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
> 
> typical result is:


> I suppose that __put_task_struct() was called for the thread when is 'partially dead'
> (because it's somewhere in do_exit() called by kthread() after returning from thread's
> function), but not 'dead enough' to finalize it with free_task().
> 
> So, the question is still open.
> 

Really you need to better understand how all this works.

Remove the wait_for_completion(), this brings nothing at all, as you
already discovered.

Then you need cooperation from worker threads : they must wait for
kthread_should_stop(), or else your kthread_stop(arg) pass an already
freed "arg" memory block.

Take the time to read kernel/kthread.c and function kthread_stop()



