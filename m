Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2AXCIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:08:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53166 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2AXCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:08:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 11:07:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-Id: <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120123142436.181674896@openvz.org>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.181674896@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 18:20:37 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> When we do checkpoint of a task we need to know the list of children
> the task, has but there is no easy and fast way to generate reverse
> parent->children chain from arbitrary <pid> (while a parent pid is
> provided in "PPid" field of /proc/<pid>/status).
> 
> So instead of walking over all pids in the system (creating one big process
> tree in memory, just to figure out which children a task has) -- we add
> explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
> this kind of information but it is not yet exported.
> 
> This is a first level children, not the whole process tree.
> 
> v2:
>  - Kame suggested to use a separated /proc/<pid>/children entry
>    instead of poking /proc/<pid>/status
>  - Andew suggested to use rcu facility instead of locking
>    tasklist_lock
>  - Tejun pointed that non-seekable seq file might not be
>    enough for tasks with large number of children
> 
> v3:
>  - To be on a safe side use %lu format for pid_t printing
> 
> v4:
>  - New line get printed when sequence ends not at seq->stop,
>    a nit pointed by Tejun
>  - Documentation update
>  - tasklist_lock is back, Oleg pointed that ->children list
>    is actually not rcu-safe
> 
> v5:
>  - Oleg suggested to make /proc/<pid>/task/<tid>/children
>    instead of global /proc/<pid>/children, which eliminates
>    hardness related to threads and children migration, and
>    allows patch to be a way simplier.
> 
> v6:
>  - Drop ptrace_may_access tests, pids are can be found anyway
>    so nothing to protect here.
>  - Update comments and docs, pointed by Oleg.
> 
> v7:
>  - Use get_pid over proc-pid directly, to simplify
>    code, pointed by Oleg.
> 
> v8:
>  - Obtain a starting pid from the proc's inode directly.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

>From viewpoint I played with seq_file, yesterday.

> +static void *children_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	return get_children_pid(seq->private, NULL, *pos);
> +}
> +
> +static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct pid *pid = NULL;
> +
> +	pid = get_children_pid(seq->private, v, *pos + 1);
> +	if (!pid)
> +		seq_printf(seq, "\n");
> +	put_pid(v);

Because seq_printf() may fail. This seems dangeorus.

If seq_printf() fails and returns NULL, "\n" will not be
printed out and user land parser will go wrong.

I think all seq_printf() should be handled in ->show().
(And you can use seq_putc() for "\n".)

Thanks,
-Kame


