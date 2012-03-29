Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2C2SL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:11:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35348 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033Ab2C2SLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:11:20 -0400
Date: Thu, 29 Mar 2012 11:11:04 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Mandeep Singh Baines <msb@chromium.org>,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Paul Menage <paul@paulmenage.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH for-3.4-fixes] cgroup: cgroup_attach_task() could
 return -errno after success
Message-ID: <20120329181104.GC27051@google.com>
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
 <20120329160433.GC28941@google.com>
 <20120329162620.GD28941@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329162620.GD28941@google.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo (tj@kernel.org) wrote:
> 61d1d219c4 "cgroup: remove extra calls to find_existing_css_set" made
> cgroup_task_migrate() return void.  An unfortunate side effect was
> that cgroup_attach_task() was depending on that function's return
> value to clear its @retval on the success path.  On cgroup mounts
> without any subsystem with ->can_attach() callback,
> cgroup_attach_task() ended up returning @retval without initializing
> it on success.
> 
> For some reason, gcc failed to warn about it and it didn't cause
> cgroup_attach_task() to return non-zero value in many cases, probably
> due to difference in register allocation.  When the problem
> materializes, systemd fails to populate /systemd cgroup mount and
> fails to boot.
> 
> Fix it by initializing @retval to zero on declaration.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Mandeep Singh Baines <msb@chromium.org>

> Reported-by: Jiri Kosina <jkosina@suse.cz>
> LKML-Reference: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
> ---
> Jiri, can you please confirm the fix?
> 
> Thanks.
> 
>  kernel/cgroup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f4ea4b6..ed64cca 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1883,7 +1883,7 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>   */
>  int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  {
> -	int retval;
> +	int retval = 0;
>  	struct cgroup_subsys *ss, *failed_ss = NULL;
>  	struct cgroup *oldcgrp;
>  	struct cgroupfs_root *root = cgrp->root;
