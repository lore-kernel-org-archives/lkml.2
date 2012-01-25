Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2AYAUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:20:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab2AYAUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:20:18 -0500
Date: Tue, 24 Jan 2012 16:20:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] If init dies, log a signal which killed it, if any.
Message-Id: <20120124162016.08a37b2f.akpm@linux-foundation.org>
In-Reply-To: <1327097836-8485-1-git-send-email-vda.linux@googlemail.com>
References: <1327097836-8485-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012 23:17:16 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> I just received another user's pleas for help when their
> init mysteriously died. I again explained that they need to check
> whether it died because of bad instruction, a segv, or something else.
> Which was an annoying detour into writing a trivial C program
> to spawn his init and print its exit code:
> 
> http://lists.busybox.net/pipermail/busybox/2012-January/077172.html
> 
> I hear you saying "just test it under /bin/sh". Well, the crashing init
> _was_ /bin/sh.
> 
> Which prompted me to make kernel do this first step automatically.
> We can print exit code, which makes it possible to see that
> death was from e.g. SIGILL without writing test programs.
> 
> The code is fairly self-explanatory. Compile-tested.
> 
> Changes in v.2: don't try to decode signal names, just print
> exit status in hex.
> 
>
> ...
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -710,8 +710,11 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
>  
>  	if (unlikely(pid_ns->child_reaper == father)) {
>  		write_unlock_irq(&tasklist_lock);
> -		if (unlikely(pid_ns == &init_pid_ns))
> -			panic("Attempted to kill init!");
> +		if (unlikely(pid_ns == &init_pid_ns)) {
> +			panic("Attempted to kill init! exitcode=%08x\n",
> +				father->signal->group_exit_code ?:
> +					father->exit_code);
> +		}

It's a bit user-hostile to print a hex number in such a context without
the leading 0x.  The %08 does provide a hint - users are unlikely to
interpret 00000011 as 11.  But still, I think...

--- a/kernel/exit.c~kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix
+++ a/kernel/exit.c
@@ -711,7 +711,7 @@ static struct task_struct *find_new_reap
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
 		if (unlikely(pid_ns == &init_pid_ns)) {
-			panic("Attempted to kill init! exitcode=%08x\n",
+			panic("Attempted to kill init! exitcode=0x%08x\n",
 				father->signal->group_exit_code ?:
 					father->exit_code);
 		}
_

Or maybe we should use %d.  Does anyone use hex for exit codes?
