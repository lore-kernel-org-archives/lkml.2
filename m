Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab2BBX05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:26:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2BBX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:26:50 -0500
Date: Thu, 2 Feb 2012 15:26:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch cr 3/4] c/r: procfs: add arg_start/end, env_start/end
 and exit_code members to /proc/$pid/stat
Message-Id: <20120202152648.bff836b4.akpm@linux-foundation.org>
In-Reply-To: <20120130141852.377457689@openvz.org>
References: <20120130140905.441199885@openvz.org>
	<20120130141852.377457689@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 18:09:08 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> We would like to have an ability to restore command line
> arguments and envirion pointers so the task being restored
> would print appropriate values in /proc/pid/cmdline and
> /proc/pid/envirion. The exit_code is needed to restore
> zombie tasks.
> 
> ...
>
> --- linux-2.6.git.orig/fs/proc/array.c
> +++ linux-2.6.git/fs/proc/array.c
> @@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
>  
>  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
>  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
> +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld ",
>  		pid_nr_ns(pid, ns),
>  		tcomm,
>  		state,
> @@ -511,10 +511,25 @@ static int do_task_stat(struct seq_file
>  		task->policy,
>  		(unsigned long long)delayacct_blkio_ticks(task),
>  		cputime_to_clock_t(gtime),
> -		cputime_to_clock_t(cgtime),
> -		(mm && permitted) ? mm->start_data : 0,
> -		(mm && permitted) ? mm->end_data : 0,
> -		(mm && permitted) ? mm->start_brk : 0);
> +		cputime_to_clock_t(cgtime));
> +
> +		if (mm && permitted) {
> +			seq_printf(m, "%lu %lu %lu %lu %lu %lu %lu ",
> +				   mm->start_data,
> +				   mm->end_data,
> +				   mm->start_brk,
> +				   mm->arg_start,
> +				   mm->arg_end,
> +				   mm->env_start,
> +				   mm->env_end);
> +		} else
> +			seq_printf(m, "0 0 0 0 0 0 0 ");

heh.

We have a whizzy new num_to_str() in -mm which can later be used to
speed this up.

This actually means that your patch will conflict horridly with
procfs-add-num_to_str-to-speed-up-proc-stat.patch, because that patch
redoes /proc/stat handling.  I guess I can take care of that issue.

> +
> +		if (permitted)
> +			seq_printf(m, "%d\n", task->exit_code);
> +		else
> +			seq_printf(m, "0\n");
> +
>  	if (mm)
>  		mmput(mm);
>  	return 0;

