Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2APQRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab2APQRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:17:33 -0500
Date: Mon, 16 Jan 2012 17:11:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v6
Message-ID: <20120116161114.GA17727@redhat.com>
References: <20120116153231.GF2998@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116153231.GF2998@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Cyrill Gorcunov wrote:
>
> +get_children_pid(struct proc_pid_children_iter *iter, struct pid *pid_prev, loff_t pos)
> +{
> +	struct task_struct *start, *task;
> +	struct pid *pid = NULL;
> +
> +	read_lock(&tasklist_lock);
> +
> +	start = pid_task(iter->pid_start, PIDTYPE_PID);
> +	if (!start)
> +		goto out;
> +
> +	/*
> +	 * Lets try to continue searching first, this gives
> +	 * us significant speedup on children-rich processes.
> +	 */
> +	if (pid_prev) {
> +		task = pid_task(pid_prev, PIDTYPE_PID);
> +		if (task && task->real_parent == start &&
> +		    !(list_empty(&task->sibling))) {

Damn. No, this is wrong.

Damn! Yes, it was we who told you to check list_empty(sibling) ;)

But this is not enough. exit_ptrace() can do list_move() without
changing ->real_parent.

I'll try to think. At first glance we can rely on EXIT_DEAD, but
I'd like to avoid this, I think EXIT_DEAD should die.

Oleg.

