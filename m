Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1BQN41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:56:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52075 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1BQN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:56:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Feb 2011 22:50:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Max Kellermann <mk@cm4all.com>
Cc: menage@google.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] new cgroup controller "fork"
Message-Id: <20110217225010.7f79b412.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110217133152.4043.94951.stgit@rabbit.intern.cm-ag>
References: <20110217133152.4043.94951.stgit@rabbit.intern.cm-ag>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 14:31:52 +0100
Max Kellermann <mk@cm4all.com> wrote:

> Can limit the number of fork()/clone() calls in a cgroup.  It is
> useful as a safeguard against fork bombs.
> 

brief comments below.


> Signed-off-by: Max Kellermann <mk@cm4all.com>
<snip>

> +static int
> +cgroup_fork_remaining_write(struct cgroup *cgroup, struct cftype *cft,
> +			    s64 value)
> +{
> +	struct cgroup_fork *t = cgroup_fork_group(cgroup);
> +
> +	if (value < -1 || value > (1L << 30))
> +		return -EINVAL;
> +
> +	spin_lock_irq(&t->lock);
> +	t->remaining = (int)value;
> +	spin_unlock_irq(&t->lock);
> +
> +	return 0;
> +}

I wonder allowing to set the limit to Root cgroup may imply the system death.
How about disabling to set value to Root cgroup ?


> +
> +static const struct cftype cgroup_fork_files[] =  {
> +	{
> +		.name = "remaining",
> +		.read_s64 = cgroup_fork_remaining_read,
> +		.write_s64 = cgroup_fork_remaining_write,
> +	},
> +};
> +
> +static int
> +cgroup_fork_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
> +{
> +	if (cgroup->parent == NULL)
> +		/* cannot limit the root cgroup */
> +		return 0;
> +
> +	return cgroup_add_files(cgroup, ss, cgroup_fork_files,
> +				ARRAY_SIZE(cgroup_fork_files));
> +}
> +
> +struct cgroup_subsys fork_subsys = {
> +	.name = "fork",
> +	.create = cgroup_fork_create,
> +	.destroy = cgroup_fork_destroy,
> +	.fork = cgroup_fork_fork,
> +	.populate = cgroup_fork_populate,
> +	.subsys_id = fork_subsys_id,
> +};
> +
> +int
> +cgroup_fork_pre_fork(void)
> +{
> +	struct cgroup_fork *t;
> +	int err = 0;
> +
> +	rcu_read_lock();
> +
> +	t = cgroup_fork_current();
> +	while (t->css.cgroup->parent != NULL && err == 0) {
> +		spin_lock_irq(&t->lock);
> +
> +		if (t->remaining == 0)
> +			err = -EPERM;

IIRC, fork()'s error code is EAGAIN or ENOMEM. The exisiting limit of
rlimit() returns EAGAIN.

How about -EAGAIN here ? I think it's not good to add new error code for
system calls.

Thanks,
-Kame

