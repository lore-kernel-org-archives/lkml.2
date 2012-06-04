Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844Ab2FDQxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab2FDQxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:53:02 -0400
Date: Mon, 4 Jun 2012 18:51:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        kir@parallels.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] allow a task to join a pid namespace
Message-ID: <20120604165117.GA13091@redhat.com>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338816828-25312-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Glauber Costa wrote:
>
> Currently, it is possible for a process  to join existing
> net, uts and ipc namespaces. This patch allows a process to join an
> existing pid namespace as well.

I can't understand this patch... but probably I missed something,
I never really understood setns.

> +static int pidns_install(struct nsproxy *nsproxy, void *_ns)
> +{
> +	struct pid *newpid;
> +	struct pid_namespace *ns = _ns;
> +
> +	if (is_container_init(current))
> +		return -EINVAL;
> +
> +	if (nsproxy->pid_ns != ns->parent)
> +		return -EPERM;

At least you should also check that current is single-threaded,
I guess.

> +
> +	if (task_pgrp(current) !=  task_pid(current))
> +		return -EPERM;
> +
> +	if (task_session(current) !=  task_pid(current))
> +		return -EPERM;

Both checks are obviously racy without tasklist.

> +	newpid = alloc_pid(ns);
> +	if (!newpid)
> +		return -ENOMEM;

Hmm. Doesn't this mean that pid_nr of this task (as it seen
in its current namespace) will be changed? This doesn't look
sane.

> +	put_pid_ns(nsproxy->pid_ns);
> +	nsproxy->pid_ns = get_pid_ns(ns);
> +
> +	write_lock_irq(&tasklist_lock);
> +	change_pid(current, PIDTYPE_PID, newpid);
> +	change_pid(current, PIDTYPE_PGID, newpid);
> +	change_pid(current, PIDTYPE_SID, newpid);
> +	write_unlock_irq(&tasklist_lock);

Hmm. So, until the caller does switch_task_namespaces()
task_active_pid_ns(current) != current->nsproxy->pid_ns,
doesn't look very nice too.

I don't think this can be right. If nothing else, this breaks
it_real_fn().

Oleg.

