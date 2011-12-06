Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1LFWdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:33:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1LFWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:33:14 -0500
Date: Tue, 6 Dec 2011 14:33:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-Id: <20111206143313.ac2e7287.akpm@linux-foundation.org>
In-Reply-To: <20111206181026.GO29781@moon>
References: <20111206181026.GO29781@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 22:10:26 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> There is no easy way to make a reverse parent->children chain
> from the task status, in turn children->parent provided with "PPid"
> field.
> 
> So instead of walking over all pids in system to figure out what
> children the task have -- we add explicit /proc/<pid>/children entry,
> since kernel already knows this kind of information but it was not
> yet exported.
> 
>
> ...
>
> +static int children_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct task_struct *task = container_of(v, struct task_struct, sibling);
> +	return seq_printf(seq, " %d", pid_vnr(task_pid(task)));
> +}

Printing a pid_t with %d is a bit risky.  At present all architectures
appear to use int for pid_t so it's not broken (yet!).  I suppose we
can leave this code as-is for now - if some 32-bit arch turns up with a
64-bit pid_t, we'll want that warning to come out.

> +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct task_struct *task;
> +
> +	rcu_read_lock();
> +	task = seq->private;
> +	if (task)
> +		return seq_list_start(&task->children, *pos);
> +
> +	return NULL;
> +}
> +
> +static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct task_struct *task = seq->private;
> +	if (task)
> +		return seq_list_next(v, &task->children, pos);
> +	return NULL;
> +}
> +
> +static void children_seq_stop(struct seq_file *seq, void *v)
> +{
> +	rcu_read_unlock();
> +	seq_printf(seq, "\n");
> +}

So as I understand it, they way this works is that when the seqfile
buffer fills up we will drop the rcu lock, will flush the buffer and
then we reacquire the lock and the seq_file core will iterate over the
children list until we end up the same number of items from the head,
and populating the output buffer will resume.

This means that if the children list changes during the flush, the data
which userspace reads will be wrong.  Of course, inaccuracy is
unavoidable when returning kernel-internal data such as this to
userspace.

I suggest that the changelog should explain these races and should also
explain how you propose that the client software will be robust against
such races.

It's also worth adding a warning about this into the documentation for
this procfs file.  Documentation which this patch forgot to provide,
btw!


