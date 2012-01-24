Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2AXX7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:59:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2AXX7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:59:42 -0500
Date: Tue, 24 Jan 2012 15:59:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
Message-Id: <20120124155941.4f7453d4.akpm@linux-foundation.org>
In-Reply-To: <20120123142436.336126707@openvz.org>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.336126707@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 18:20:39 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> We would like to have an ability to restore command line
> arguments and envirion pointers so the task being restored
> would print appropriate values in /proc/pid/cmdline and
> /proc/pid/envirion. The exit_code is needed to restore
> zombie tasks.
> 

Please update Documentation/filesystems/proc.txt.

>
> --- linux-2.6.git.orig/fs/proc/array.c
> +++ linux-2.6.git/fs/proc/array.c
> @@ -464,7 +464,8 @@ static int do_task_stat(struct seq_file
>  
>  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
>  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
> +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu \
> +%lu %lu %lu %lu %d\n",
>  		pid_nr_ns(pid, ns),
>  		tcomm,
>  		state,
> @@ -514,7 +515,12 @@ static int do_task_stat(struct seq_file
>  		cputime_to_clock_t(cgtime),
>  		(mm && permitted) ? mm->start_data : 0,
>  		(mm && permitted) ? mm->end_data : 0,
> -		(mm && permitted) ? mm->start_brk : 0);
> +		(mm && permitted) ? mm->start_brk : 0,
> +		(mm && permitted) ? mm->arg_start : 0,
> +		(mm && permitted) ? mm->arg_end : 0,
> +		(mm && permitted) ? mm->env_start : 0,
> +		(mm && permitted) ? mm->env_end : 0,
> +		task->exit_code);
>  	if (mm)
>  		mmput(mm);
>  	return 0;

/proc/pid/stat is getting out of control.  People are now sending patches
because reading from this thing already takes too long.

The problem is that if you only want one field, you have to incur the
cost of preparing all the fields.  The magnitude of this problem
increases exponentially over time!

I'm unsure what to do about it really.  Perhaps add a new
/proc/pid/mmstat for MM-specific things.  We could put the above six
fields in there, as long as we move quickly.



