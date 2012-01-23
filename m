Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2AWPJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:09:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2AWPJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:09:17 -0500
Date: Mon, 23 Jan 2012 16:03:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] If init dies, log a signal which killed it, if any.
Message-ID: <20120123150309.GA8153@redhat.com>
References: <1327097836-8485-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327097836-8485-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Denys Vlasenko wrote:
>
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

Looks reasonable to me.

Probably you should re-send the patch to Andrew, I do not know who
else can pick it.

Acked-by: Oleg Nesterov <oleg@redhat.com>

> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> ---
>  kernel/exit.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 294b170..0c540a5 100644
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
>
>  		zap_pid_ns_processes(pid_ns);
>  		write_lock_irq(&tasklist_lock);
> --
> 1.7.7.5
>

