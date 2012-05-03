Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2ECPmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:42:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36697 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab2ECPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:42:22 -0400
Date: Thu, 3 May 2012 08:41:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: BUG on exit_group
Message-ID: <20120503154140.GA2592@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050315-4242-0000-0000-0000018B3785
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 10:57:19AM +0200, Sasha Levin wrote:
> Hi Paul,
> 
> I've hit a BUG similar to the schedule_tail() one when. It happened
> when I've started fuzzing exit_group() syscalls, and all of the traces
> are starting with exit_group() (there's a flood of them).
> 
> I've verified that it indeed BUGs due to the rcu preempt count.

Hello, Sasha,

Which version of -next are you using?  I did some surgery on this
yesterday based on some bugs Hugh Dickins tracked down, so if you
are using something older, please move to the current -next.

						Thanx, Paul

> Here's one of the BUG()s:
> 
> [   83.820976] BUG: sleeping function called from invalid context at
> kernel/mutex.c:269
> [   83.827870] in_atomic(): 0, irqs_disabled(): 0, pid: 4506, name: trinity
> [   83.832154] 1 lock held by trinity/4506:
> [   83.834224]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff811a7d87>]
> munlock_vma_page+0x197/0x200
> [   83.839310] Pid: 4506, comm: trinity Tainted: G        W
> 3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty #108
> [   83.849418] Call Trace:
> [   83.851182]  [<ffffffff810e7218>] __might_sleep+0x1f8/0x210
> [   83.854076]  [<ffffffff82d9540a>] mutex_lock_nested+0x2a/0x50
> [   83.857120]  [<ffffffff811b0830>] try_to_unmap_file+0x40/0x2f0
> [   83.860242]  [<ffffffff82d984bb>] ? _raw_spin_unlock_irq+0x2b/0x80
> [   83.863423]  [<ffffffff810e7ffe>] ? sub_preempt_count+0xae/0xf0
> [   83.866347]  [<ffffffff82d984e9>] ? _raw_spin_unlock_irq+0x59/0x80
> [   83.869570]  [<ffffffff811b0caa>] try_to_munlock+0x6a/0x80
> [   83.872667]  [<ffffffff811a7cc6>] munlock_vma_page+0xd6/0x200
> [   83.875646]  [<ffffffff811a7d87>] ? munlock_vma_page+0x197/0x200
> [   83.878798]  [<ffffffff811a7e7f>] munlock_vma_pages_range+0x8f/0xd0
> [   83.882235]  [<ffffffff811a8b8a>] exit_mmap+0x5a/0x160
> [   83.884880]  [<ffffffff810ba23b>] ? exit_mm+0x10b/0x130
> [   83.887508]  [<ffffffff8111d8ea>] ? __lock_release+0x1ba/0x1d0
> [   83.890399]  [<ffffffff810b4fe1>] mmput+0x81/0xe0
> [   83.892966]  [<ffffffff810ba24b>] exit_mm+0x11b/0x130
> [   83.895640]  [<ffffffff82d984e9>] ? _raw_spin_unlock_irq+0x59/0x80
> [   83.898943]  [<ffffffff810bca53>] do_exit+0x263/0x460
> [   83.901700]  [<ffffffff810bccf1>] do_group_exit+0xa1/0xe0
> [   83.907366]  [<ffffffff810bcd42>] sys_exit_group+0x12/0x20
> [   83.912450]  [<ffffffff82d993b9>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

