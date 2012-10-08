Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2JHGNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:13:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:65004 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2JHGNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:13:14 -0400
Message-ID: <50726E80.4040204@huawei.com>
Date: Mon, 8 Oct 2012 14:11:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Ben Blum <bblum@andrew.cmu.edu>, Tejun Heo <tj@kernel.org>
Subject: Re: [REGRESSION] cgroup: notify_on_release may not be triggered in
 some cases
References: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
In-Reply-To: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/10/4 15:37, Daisuke Nishimura wrote:
> notify_on_release must be triggered when the last process in a cgroup is
> move to another. But if the first(and only) process in a cgroup is moved to
> another, notify_on_release is not triggered.
> 
> 	# mkdir /cgroup/cpu/SRC
> 	# mkdir /cgroup/cpu/DST
> 	#
> 	# echo 1 >/cgroup/cpu/SRC/notify_on_release
> 	# echo 1 >/cgroup/cpu/DST/notify_on_release
> 	#
> 	# sleep 300 &
> 	[1] 8629
> 	#
> 	# echo 8629 >/cgroup/cpu/SRC/tasks
> 	# echo 8629 >/cgroup/cpu/DST/tasks
> 	-> notify_on_release for /SRC must be triggered at this point,
> 	   but it isn't.
> 
> This is because put_css_set() is called before setting CGRP_RELEASABLE
> in cgroup_task_migrate(), and is a regression introduce by the
> commit:74a1166d(cgroups: make procs file writable), which was merged
> into v3.0.
> 
> Cc: Ben Blum <bblum@andrew.cmu.edu>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: <stable@vger.kernel.org> # v3.0.x and later
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
> This patch is based on v3.6.
> 
>  kernel/cgroup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 7981850..7d01182 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1923,9 +1923,8 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  	 * trading it for newcg is protected by cgroup_mutex, we're safe to drop
>  	 * it here; it will be freed under RCU.
>  	 */
> -	put_css_set(oldcg);
> -
>  	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
> +	put_css_set(oldcg);

Good catch. Also we might end up with invalid memory access! 

Acked-by: Li Zefan <lizefan@huawei.com>

>  }
>  
>  /**
> 

