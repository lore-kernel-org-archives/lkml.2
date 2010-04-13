Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0DMBWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:22:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62419 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0DMBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:22:31 -0400
Message-Id: <201004130121.o3D1Lhh7099571@www262.sakura.ne.jp>
Subject: Re: [Patch 3/3] net: reserve ports for applications using fixed port numbers
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: amwang@redhat.com
Cc: opurdila@ixiacom.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, davem@davemloft.net, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Apr 2010 10:21:43 +0900
References: <20100412100744.5302.92442.sendpatchset@localhost.localdomain> <20100412100816.5302.74919.sendpatchset@localhost.localdomain>
In-Reply-To: <20100412100816.5302.74919.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 12042010 #3702773, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> --- linux-2.6.orig/drivers/infiniband/core/cma.c
> +++ linux-2.6/drivers/infiniband/core/cma.c
> @@ -1980,6 +1980,8 @@ retry:
>  	/* FIXME: add proper port randomization per like inet_csk_get_port */
>  	do {
>  		ret = idr_get_new_above(ps, bind_list, next_port, &port);
> +		if (!ret && inet_is_reserved_local_port(port))
> +			ret = -EAGAIN;
>  	} while ((ret == -EAGAIN) && idr_pre_get(ps, GFP_KERNEL));
>  
>  	if (ret)
> 
I think above part is wrong. Below program
--------------------
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/idr.h>

static DEFINE_IDR(idr);
static int idr_demo_init(void)
{
	int next_port = 65530;
	int port = 0;
	int ret = -EINTR;
	while (!signal_pending(current)) {
		msleep(1000);
		ret = idr_get_new_above(&idr, NULL, next_port, &port);
		printk(KERN_INFO "idr_get_new_above() = %d\n", ret);
		if (!ret) {
			/* Emulate inet_is_reserved_local_port(port) = true */
			printk(KERN_INFO "Port %u is reserved.\n", port);
			ret = -EAGAIN;
		}
		if (ret == -EAGAIN) {
			if (idr_pre_get(&idr, GFP_KERNEL)) {
				printk(KERN_INFO "idr_pre_get() succeeded.\n");
				continue;
			}
			printk(KERN_INFO "idr_pre_get() failed.\n");
			break;
		} else {
			printk(KERN_INFO "next_port=%u port=%u\n",
			       next_port, port);
			break;
		}
	}
	if (!ret)
		idr_remove(&idr, port);
	idr_destroy(&idr);
	return -EINVAL;
}
module_init(idr_demo_init);
MODULE_LICENSE("GPL");
--------------------
generated below output.

idr_get_new_above() = -11
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65530 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65531 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65532 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65533 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65534 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65535 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65536 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
Port 65537 is reserved.
idr_pre_get() succeeded.
idr_get_new_above() = 0
(...snipped...)

This result suggests that above loop will continue until idr_pre_get() fails
due to out of memory if all ports were reserved.

Also, if idr_get_new_above() returned 0, bind_list (which is a kmalloc()ed
pointer) is already installed into a free slot (see comment on
idr_get_new_above_int()). Thus, simply calling idr_get_new_above() again will
install the same pointer into multiple slots. I guess it will malfunction later.
