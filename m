Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2I1NMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:12:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33249 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab2I1NMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:12:05 -0400
Date: Fri, 28 Sep 2012 15:12:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
Message-ID: <20120928131152.GB12843@somewhere.redhat.com>
References: <50659D37.2020206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50659D37.2020206@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:51:03PM +0200, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest with the latest linux-next kernel, I've stumbled on the following during boot:
> 
> [  199.224369] WARNING: at kernel/rcutree.c:513 rcu_eqs_exit_common+0x4a/0x3a0()
> [  199.225307] Pid: 1, comm: init Tainted: G        W    3.6.0-rc7-next-20120928-sasha-00001-g8b2d05d-dirty #13
> [  199.226611] Call Trace:
> [  199.226951]  [<ffffffff811c8d1a>] ? rcu_eqs_exit_common+0x4a/0x3a0
> [  199.227773]  [<ffffffff81108e36>] warn_slowpath_common+0x86/0xb0
> [  199.228572]  [<ffffffff81108f25>] warn_slowpath_null+0x15/0x20
> [  199.229348]  [<ffffffff811c8d1a>] rcu_eqs_exit_common+0x4a/0x3a0
> [  199.230037]  [<ffffffff8117f267>] ? __lock_acquire+0x1c37/0x1ca0
> [  199.230037]  [<ffffffff811c936c>] rcu_eqs_exit+0x9c/0xb0
> [  199.230037]  [<ffffffff811c940c>] rcu_user_exit+0x8c/0xf0
> [  199.230037]  [<ffffffff810a98bb>] do_page_fault+0x1b/0x40
> [  199.230037]  [<ffffffff810a2a90>] do_async_page_fault+0x30/0xa0
> [  199.230037]  [<ffffffff83a3eea8>] async_page_fault+0x28/0x30
> [  199.230037]  [<ffffffff819f357b>] ? debug_object_activate+0x6b/0x1b0
> [  199.230037]  [<ffffffff819f3586>] ? debug_object_activate+0x76/0x1b0
> [  199.230037]  [<ffffffff8111af13>] ? lock_timer_base.isra.19+0x33/0x70
> [  199.230037]  [<ffffffff8111d45f>] mod_timer_pinned+0x9f/0x260
> [  199.230037]  [<ffffffff811c5ff4>] rcu_eqs_enter_common+0x894/0x970
> [  199.230037]  [<ffffffff839dc2ac>] ? init_post+0x75/0xc8
> [  199.230037]  [<ffffffff85abfed5>] ? kernel_init+0x1e1/0x1e1
> [  199.230037]  [<ffffffff811c63df>] rcu_eqs_enter+0xaf/0xc0
> [  199.230037]  [<ffffffff811c64c5>] rcu_user_enter+0xd5/0x140
> [  199.230037]  [<ffffffff8107d0fd>] syscall_trace_leave+0xfd/0x150
> [  199.230037]  [<ffffffff83a3f7af>] int_check_syscall_exit_work+0x34/0x3d
> [  199.230037] ---[ end trace a582c3a264d5bd1a ]---

We are faulting in the middle of rcu_user_enter() and thus we call rcu_user_exit()
while the whole transition state in rcu_user_enter() is not yet finished (rdtp->dynticks
not incremented).

Not sure how to solve this...
