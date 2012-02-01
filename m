Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2BAQbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:31:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63558 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2BAQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:31:44 -0500
Message-ID: <1328113899.1882.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Module/kthread/printk question/problem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 01 Feb 2012 17:31:39 +0100
In-Reply-To: <4F2963AA.3010306@linaro.org>
References: <4F2963AA.3010306@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 20:09 +0400, Dmitry Antipov a écrit :
> I'm writing a kernel module which creates a substantial amount of
> kernel threads. After dropping some real stuff, the module is:
> 
> #include <linux/kernel.h>
> #include <linux/sched.h>
> #include <linux/kthread.h>
> #include <linux/module.h>
> #include <linux/slab.h>
> 
> MODULE_LICENSE("GPL");
> 
> static int nrthreads = 128;
> module_param(nrthreads, int, 0644);
> 
> static int loopcount = 1024;
> module_param(loopcount, int, 0644);
> 
> static int usehrtime = 0;
> module_param(usehrtime, int, 0644);
> 
> static int slack = 50000;
> module_param(slack, int, 0644);
> 
> static int msecs = 1;
> module_param(msecs, int, 0644);
> 
> static DECLARE_COMPLETION(done);
> static struct task_struct **threads;
> static atomic_t nrunning;
> 
> static int test(void *unused)
> {
>          int i;
>          ktime_t expires = ktime_set(0, msecs * NSEC_PER_MSEC);
> 
>          for (i = 0; !kthread_should_stop() && i < loopcount; i++) {
>                  if (usehrtime) {
>                          set_current_state(TASK_UNINTERRUPTIBLE);
>                          schedule_hrtimeout_range(&expires, slack, HRTIMER_MODE_REL);
>                  }
>                  else
>                          schedule_timeout_uninterruptible(msecs_to_jiffies(msecs));
>          }
> 
>          if (atomic_dec_and_test(&nrunning)) {
>                  printk("last thread done\n");
>                  complete(&done);

Race is here :

Here you allow testmod_exit() to continue, while _this_ thread has not
yet exited.

>          }

And if this thread is preempted a litle bit, its code already was freed.
-> crash.

>          return 0;
> }
> 
> static int __init testmod_init(void)
> {
>          int i;
> 
>          printk("test begin\n");
> 
>          atomic_set(&nrunning, nrthreads);
> 
>          threads = kmalloc(nrthreads * sizeof(struct task_struct *), GFP_KERNEL);
>          if (!threads)
>                  return -ENOMEM;
> 
>          for (i = 0; i < nrthreads; i++) {
>                  threads[i] = kthread_run(test, NULL, "test/%d", i);
>                  if (IS_ERR(threads[i])) {
>                          int j, err = PTR_ERR(threads[i]);
> 
>                          for (j = 0; j < i; j++)
>                                  kthread_stop(threads[j]);
>                          kfree(threads);
>                          return err;
>                  }
>          }
>          return 0;
> }
> 
> static void __exit testmod_exit(void)
> {
>          wait_for_completion(&done);
>          kfree(threads);
> }
> 
> module_init(testmod_init);
> module_exit(testmod_exit);
> 
> Usually it works as expected, at least from 8 to 128 threads.
> But when I'm trying to run it a loop like:
> 
>    while true; do insmod testmod.ko && rmmod testmod.ko; sleep 1; done
> 
> it's also possible to catch a very rare crash (ARM example):
> 
> Unable to handle kernel paging request at virtual address 7f1200c4
> pgd = 80004000
> [7f1200c4] *pgd=bdc28811, *pte=00000000, *ppte=00000000
> Internal error: Oops: 80000007 [#1] PREEMPT SMP
> Modules linked in: [last unloaded: testmod]
> CPU: 1    Tainted: G           O  (3.3.0-rc2 #3)
> PC is at 0x7f1200c4
> LR is at __schedule+0x684/0x6e4
> pc : [<7f1200c4>]    lr : [<802c053c>]    psr: 600f0113
> sp : bf115f88  ip : 00000000  fp : 00000000
> r10: 00000000  r9 : 00000000  r8 : 7f120394
> r7 : 00000002  r6 : 00000400  r5 : 7f120204  r4 : bf114000
> r3 : 00000000  r2 : bf115ec0  r1 : bf9220c0  r0 : 00000001
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: bfbcc04a  DAC: 00000015
> Process test/126 (pid: 10918, stack limit = 0xbf1142f8)
> Stack: (0xbf115f88 to 0xbf116000)
> 5f80:                   000f4240 00000000 bf213e4c 00000000 7f120000 00000013
> 5fa0: 00000000 80049228 00000000 00000000 00000000 00000000 00000000 00000000
> 5fc0: dead4ead ffffffff ffffffff 8048b2b8 00000000 00000000 8036a3f9 bf115fdc
> 5fe0: bf115fdc 271aee1c bf213e4c 8004919c 8000eabc 8000eabc bfefc811 bfefcc11
> Code: bad PC value
> 
> Note the bad PC, and stack is just a nonsense. I suspect that the kernel calls
> testmod_exit() and frees module memory _before_ all test/X threads are really
> dead - i.e. the module memory is freed when at least one of the test/X threads
> is somewhere in do_exit() or nearby. Is that possible? If yes, what's the better
> way to ensure that all test/X threads are really gone at some point of
> testmod_exit()?
> 
> An interesting thing is that I can't reproduce this fault with both printk()s
> commented out. No ideas why.
> 
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


