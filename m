Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab2CHWWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758899Ab2CHWWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:08 -0500
Date: Thu, 8 Mar 2012 17:21:53 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair G Kergon <agk@redhat.com>, Will Drewry <wad@chromium.org>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: workqueues and percpu (was: [PATCH] dm: remake of the verity target)
In-Reply-To: <20120306215947.GB27051@google.com>
Message-ID: <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com> <20120306215947.GB27051@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2012, Mandeep Singh Baines wrote:

> You are
> allocated a complete shash_desc per I/O. We only allocate one per CPU.

I looked at it --- and using percpu variables in workqueues isn't safe 
because the workqueue can change CPU if the CPU is hot-unplugged.

dm-crypt has the same bug --- it also uses workqueue with per-cpu 
variables and assumes that the CPU doesn't change for a single work item.

This program shows that work executed in a workqueue can be switched to a 
different CPU.

I'm wondering how much other kernel code assumes that workqueues are bound 
to a specific CPU, which isn't true if we unplug that CPU.

Mikulas

---

/*
 * A proof of concept that a work item executed on a workqueue may change CPU
 * when CPU hot-unplugging is used.
 * Compile this as a module and run:
 * insmod test.ko; sleep 1; echo 0 >/sys/devices/system/cpu/cpu1/online
 * You see that the work item starts executing on CPU 1 and ends up executing
 * on different CPU, usually 0.
 */

#include <linux/module.h>
#include <linux/delay.h>

static struct workqueue_struct *wq;
static struct work_struct work;

static void do_work(struct work_struct *w)
{
	printk("starting work on cpu %d\n", smp_processor_id());
	msleep(10000);
	printk("finishing work on cpu %d\n", smp_processor_id());
}

static int __init test_init(void)
{
	printk("module init\n");
	wq = alloc_workqueue("testd", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
	if (!wq) {
		printk("alloc_workqueue failed\n");
		return -ENOMEM;
	}
	INIT_WORK(&work, do_work);
	queue_work_on(1, wq, &work);
	return 0;
}

static void __exit test_exit(void)
{
	destroy_workqueue(wq);
	printk("module exit\n");
}

module_init(test_init)
module_exit(test_exit)
MODULE_LICENSE("GPL");
