Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1H2PxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:53:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1H2PxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:53:11 -0400
Date: Mon, 29 Aug 2011 17:49:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 14/16] freezer: make freezing() test freeze conditions
	in effect instead of TIF_FREEZE
Message-ID: <20110829154944.GA7531@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Tejun Heo wrote:
>
> @@ -311,9 +315,11 @@ static int freezer_change_state(struct cgroup *cgroup,
>  
>  	switch (goal_state) {
>  	case CGROUP_THAWED:
> +		atomic_dec(&system_freezing_cnt);
>  		unfreeze_cgroup(cgroup, freezer);
>  		break;
>  	case CGROUP_FROZEN:
> +		atomic_inc(&system_freezing_cnt);

This is harmless, but afaics is not exactly right. CGROUP_FROZEN doesn't
need system_freezing_cnt != 0, everything is already frozen and we just
provoke freezing_slow_path() without any reason. Right?


> @@ -120,13 +120,18 @@ int freeze_processes(void)
>  {
>  	int error;
>
> +	if (!pm_freezing)
> +		atomic_inc(&system_freezing_cnt);
> +
>  	printk("Freezing user space processes ... ");
> +	pm_freezing = true;

and

> @@ -146,6 +151,11 @@ void thaw_processes(void)
>  {
>  	struct task_struct *g, *p;
>
> +	if (pm_freezing)
> +		atomic_dec(&system_freezing_cnt);
> +	pm_freezing = false;

I simply can't understand this... Why freeze_processes/thaw_processes
check pm_freezing?

IIUC, the calls to freeze/thaw should be serialized anyway (probably
pm_mutex ?). Otherwise this check can't help anyway. Say, _if_ it
is possible to call freeze_processes() with pm_freezing == T, then
the failure path or subsequent thaw_processes() will do the unbalanced
atomic_dec().

Oleg.

