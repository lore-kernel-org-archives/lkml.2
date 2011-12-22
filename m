Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1LVWvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:51:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1LVWvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:51:08 -0500
Date: Thu, 22 Dec 2011 14:51:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/2] cgroup: remove tasklist_lock from
 cgroup_attach_proc
Message-ID: <20111222225102.GM17084@google.com>
References: <1324592816-13792-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324592816-13792-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 02:26:55PM -0800, Mandeep Singh Baines wrote:
> @@ -2283,14 +2261,26 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
>  
>  	threadgroup_lock(tsk);
>  
> -	if (threadgroup)
> +	if (threadgroup) {
> +		if (!thread_group_leader(tsk)) {
> +			/*
> +			 * a race with de_thread from another thread's exec()
> +			 * may strip us of our leadership, if this happens,
> +			 * there is no choice but to throw this task away and
> +			 * try again (from cgroup_procs_write); this is
> +			 * "double-double-toil-and-trouble-check locking".
> +			 */
> +			ret = -EAGAIN;
> +			goto out_unlock_threadgroup;
> +		}
>  		ret = cgroup_attach_proc(cgrp, tsk);

Ummm... can't we just do tsk = tsk->leader after locking threadgroup?
Why do we need to retry from the beginning?

Thanks.

-- 
tejun
