Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab2CHWjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:39:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2CHWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:39:10 -0500
Date: Thu, 8 Mar 2012 14:39:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Message-Id: <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 17:21:53 -0500 
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 6 Mar 2012, Mandeep Singh Baines wrote:
> 
> > You are
> > allocated a complete shash_desc per I/O. We only allocate one per CPU.
> 
> I looked at it --- and using percpu variables in workqueues isn't safe 
> because the workqueue can change CPU if the CPU is hot-unplugged.
> 
> dm-crypt has the same bug --- it also uses workqueue with per-cpu 
> variables and assumes that the CPU doesn't change for a single work item.
> 
> This program shows that work executed in a workqueue can be switched to a 
> different CPU.
> 
> I'm wondering how much other kernel code assumes that workqueues are bound 
> to a specific CPU, which isn't true if we unplug that CPU.

ugh.

We really don't want to have to avoid using workqueues because of some
daft issue with CPU hot-unplug.  And yes, there are assumptions in various
work handlers that they will be pinned to a single CPU.  Finding and fixing
those assumptions would be painful.

Heck, even debug_smp_processor_id() can be wrong in the presence of the
cpu-unplug thing.

I'm not sure what we can do about it really, apart from blocking unplug
until all the target CPU's workqueues have been cleared.  And/or refusing
to unplug a CPU until all pinned-to-that-cpu kernel threads have been
shut down or pinned elsewhere (which is the same thing, only more
general).

Tejun, is this new behaviour?  I do recall that a long time ago we
wrestled with unplug-vs-worker-threads and I ended up OK with the
result, but I forget what it was.  IIRC Rusty was involved.


That being said, I don't think it's worth compromising the DM code
because of this workqueue wart: lots of other code has the same wart,
and we should find a centralised fix for it.

> /*
>  * A proof of concept that a work item executed on a workqueue may change CPU
>  * when CPU hot-unplugging is used.
>  * Compile this as a module and run:
>  * insmod test.ko; sleep 1; echo 0 >/sys/devices/system/cpu/cpu1/online
>  * You see that the work item starts executing on CPU 1 and ends up executing
>  * on different CPU, usually 0.
>  */
> 
> #include <linux/module.h>
> #include <linux/delay.h>
> 
> static struct workqueue_struct *wq;
> static struct work_struct work;
> 
> static void do_work(struct work_struct *w)
> {
> 	printk("starting work on cpu %d\n", smp_processor_id());
> 	msleep(10000);
> 	printk("finishing work on cpu %d\n", smp_processor_id());
> }
> 
> static int __init test_init(void)
> {
> 	printk("module init\n");
> 	wq = alloc_workqueue("testd", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
> 	if (!wq) {
> 		printk("alloc_workqueue failed\n");
> 		return -ENOMEM;
> 	}
> 	INIT_WORK(&work, do_work);
> 	queue_work_on(1, wq, &work);
> 	return 0;
> }
> 
> static void __exit test_exit(void)
> {
> 	destroy_workqueue(wq);
> 	printk("module exit\n");
> }
> 
> module_init(test_init)
> module_exit(test_exit)
> MODULE_LICENSE("GPL");
