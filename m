Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2DUAeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:34:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63440 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2DUAeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <1334968130-20724-1-git-send-email-sboyd@codeaurora.org>
References: <20120420173529.GD32324@google.com>
	<1334968130-20724-1-git-send-email-sboyd@codeaurora.org>
Date: Sat, 21 Apr 2012 08:34:01 +0800
Message-ID: <CAM2zO=Den20TynZi+_=-qCGnccbR=Tr=u09C89mTxBuWyz=eEg@mail.gmail.com>
Subject: Re: [PATCHv2] workqueue: Catch more locking problems with flush_work()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 8:28 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> If a workqueue is flushed with flush_work() lockdep checking can
> be circumvented. For example:
>
>  static DEFINE_MUTEX(mutex);
>
>  static void my_work(struct work_struct *w)
>  {
>         mutex_lock(&mutex);
>         mutex_unlock(&mutex);
>  }
>
>  static DECLARE_WORK(work, my_work);
>
>  static int __init start_test_module(void)
>  {
>         schedule_work(&work);
>         return 0;
>  }
>  module_init(start_test_module);
>
>  static void __exit stop_test_module(void)
>  {
>         mutex_lock(&mutex);
>         flush_work(&work);
>         mutex_unlock(&mutex);
>  }
>  module_exit(stop_test_module);
>
> would not always print a warning when flush_work() was called.
> In this trivial example nothing could go wrong since we are
> guaranteed module_init() and module_exit() don't run concurrently,
> but if the work item is schedule asynchronously we could have a
> scenario where the work item is running just at the time flush_work()
> is called resulting in a classic ABBA locking problem.
>
> Add a lockdep hint by acquiring and releasing the work item
> lockdep_map in flush_work() so that we always catch this
> potential deadlock scenario.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

> ---
>  kernel/workqueue.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5abf42f..038cf64 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2506,6 +2506,9 @@ bool flush_work(struct work_struct *work)
>  {
>        struct wq_barrier barr;
>
> +       lock_map_acquire(&work->lockdep_map);
> +       lock_map_release(&work->lockdep_map);
> +
>        if (start_flush_work(work, &barr, true)) {
>                wait_for_completion(&barr.done);
>                destroy_work_on_stack(&barr.work);
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>



-- 
Only stand for myself
