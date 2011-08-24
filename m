Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1HXC2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:28:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:32782 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1HXC2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:28:35 -0400
Date: Tue, 23 Aug 2011 19:28:31 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, oleg@redhat.com
Subject: Re: [PATCH 05/16] freezer: rename thaw_process() to __thaw_task()
 and simplify the implementation
Message-ID: <20110824022831.GF28444@count0.beaverton.ibm.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 04:16:11PM +0200, Tejun Heo wrote:
> thaw_process() now has only internal users - system and cgroup
> freezers.  Remove the unnecessary return value, rename, unexport and
> collapse __thaw_process() into it.  This will help further updates to
> the freezer code.

<snip>

> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index e691818..e7fa0ec 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c

<snip (Looks fine)>

> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 656492c..f5db7fd 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c

<snip>

> @@ -164,15 +154,17 @@ static int __thaw_process(struct task_struct *p)
>   * refrigerator() could call frozen_process(), in which case the task would be
>   * frozen and no one would thaw it.
>   */
> -int thaw_process(struct task_struct *p)
> +void __thaw_task(struct task_struct *p)
>  {
> +	bool was_frozen;
> +
>  	task_lock(p);
> -	if (__thaw_process(p) == 1) {
> -		task_unlock(p);
> -		wake_up_process(p);
> -		return 1;
> -	}
> +	if ((was_frozen = frozen(p)))

Style nit: I think this form is preferable:

	was_frozen = frozen(p);
	if (was_frozen)
		...

However I know Rafael already pulled this so I don't
know if it's worth bothering.

Cheers,
	-Matt Helsley
