Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1EaTmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:42:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:40880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1EaTmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:42:18 -0400
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110531172651.GA4478@swordfish.minsk.epam.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 21:45:46 +0200
Message-ID: <1306871146.2497.590.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 20:26 +0300, Sergey Senozhatsky wrote:
> Wrap __set_task_cpu() with RCU read-side critical section. 
> __set_task_cpu() calls task_group() that performs rcu dereference check in 
> task_subsys_state_check(), causing:
> 
>  [  152.262791] kernel/sched.c:619 invoked rcu_dereference_check() without protection!
>  [  152.262795] 
>  [  152.262841] stack backtrace:
>  [  152.262846] Pid: 16, comm: watchdog/1 Not tainted 3.0.0-rc1-dbg-00441-g1d5f9cc-dirty #599
>  [  152.262851] Call Trace:
>  [  152.262860]  [<ffffffff8106e17b>] lockdep_rcu_dereference+0xa7/0xaf
>  [  152.262868]  [<ffffffff810369f4>] set_task_cpu+0x1ed/0x3ce
>  [  152.262876]  [<ffffffff8123a5d7>] ? plist_check_head+0x94/0x98
>  [  152.262883]  [<ffffffff8123a72d>] ? plist_del+0x82/0x89
>  [  152.262889]  [<ffffffff8102b139>] ? dequeue_task_rt+0x33/0x38
>  [  152.262895]  [<ffffffff8102e3ac>] ? dequeue_task+0x82/0x89
>  [  152.262902]  [<ffffffff81036fc0>] push_rt_task.part.131+0x1bb/0x247
>  [  152.262909]  [<ffffffff81037138>] post_schedule_rt+0x1b/0x24
>  [  152.262918]  [<ffffffff81477c1c>] schedule+0x989/0xa9e
>  [  152.262923]  [<ffffffff814775e6>] ? schedule+0x353/0xa9e
>  [  152.262931]  [<ffffffff8147de58>] ? sub_preempt_count+0x8f/0xa3
>  [  152.262938]  [<ffffffff8109fd2c>] ? watchdog_enable+0x195/0x195
>  [  152.262946]  [<ffffffff810072e5>] ? native_sched_clock+0x38/0x65
>  [  152.262953]  [<ffffffff81062c0c>] ? cpu_clock+0x4a/0x5f
>  [  152.262958]  [<ffffffff8109fd2c>] ? watchdog_enable+0x195/0x195
>  [  152.262965]  [<ffffffff81071a15>] ? trace_hardirqs_on_caller+0x10d/0x131
>  [  152.262971]  [<ffffffff81071a46>] ? trace_hardirqs_on+0xd/0xf
>  [  152.262977]  [<ffffffff8109fd2c>] ? watchdog_enable+0x195/0x195
>  [  152.262983]  [<ffffffff8109fd94>] watchdog+0x68/0xab
>  [  152.262990]  [<ffffffff8105cb82>] kthread+0x9a/0xa2
>  [  152.262999]  [<ffffffff81481e24>] kernel_thread_helper+0x4/0x10
>  [  152.263005]  [<ffffffff8102d6bf>] ? finish_task_switch+0x76/0xf0
>  [  152.263012]  [<ffffffff8147b258>] ? retint_restore_args+0x13/0x13
>  [  152.263019]  [<ffffffff8105cae8>] ? __init_kthread_worker+0x53/0x53
>  [  152.263024]  [<ffffffff81481e20>] ? gs_change+0x13/0x13
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Sorry, no. You failed to ask youself, what is it protecting, and how
does wrapping it like this ensure the proper thing is done.

What you've done is basically silence the warning for all set_task_cpu()
callers, without proper consideration.


