Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030647Ab2GLLID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:08:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:38319 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357Ab2GLLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:08:00 -0400
Date: Thu, 12 Jul 2012 13:07:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
In-Reply-To: <1342072060.7338.102.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1207121253170.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Mike Galbraith wrote:
> crash> struct rt_mutex 0xffff8801770601c8
> struct rt_mutex {
>   wait_lock = {
>     raw_lock = {
>       slock = 7966
>     }
>   }, 
>   wait_list = {
>     node_list = {
>       next = 0xffff880175eedbe0, 
>       prev = 0xffff880175eedbe0
>     }, 
>     rawlock = 0xffff880175eedbd8, 

Urgh. Here is something completely wrong. That should point to
wait_lock, i.e. the rt_mutex itself, but that points into lala land.

>     spinlock = 0x0
>   }, 
>   owner = 0x1, 
>   save_state = 0, 
>   file = 0x0, 
>   name = 0xffffffff81781b9b "&(&device->io_lock)->lock", 
>   line = 0, 
>   magic = 0x0
> }
> crash> struct list_head 0xffff880175eedbe0
> struct list_head {
>   next = 0x6b6b6b6b6b6b6b6b, 
>   prev = 0x6b6b6b6b6b6b6b6b
> }

That's POISON_FREE. How the heck can this happen ?

 
> Reproducer2: dbench -t 30 8
> 
> [  692.857164] 
> [  692.857165] ============================================
> [  692.863963] [ BUG: circular locking deadlock detected! ]
> [  692.869264] Not tainted
> [  692.871708] --------------------------------------------
> [  692.877008] btrfs-delayed-m/1404 is deadlocking current task dbench/7937
> [  692.877009] 
> [  692.885183] 
> [  692.885184] 1) dbench/7937 is trying to acquire this lock:
> [  692.892149]  [ffff88014d6aea80] {&(&eb->lock)->lock}
> [  692.897102] .. ->owner: ffff880175808501
> [  692.901018] .. held by:   btrfs-delayed-m: 1404 [ffff880175808500, 120]
> [  692.907657] 
> [  692.907657] 2) btrfs-delayed-m/1404 is blocked on this lock:
> [  692.914797]  [ffff88014bf58d60] {&(&eb->lock)->lock}
> [  692.919751] .. ->owner: ffff880175186101
> [  692.923672] .. held by:            dbench: 7937 [ffff880175186100, 120]
> [  692.930309] 
> [  692.930309] btrfs-delayed-m/1404's [blocked] stackdump:

Hrmm. Both locks are rw_locks and we prevent multiple readers for the
known reasons in RT. No idea how to deal with that one :(

Thanks,

	tglx


