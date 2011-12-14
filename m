Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1LNAWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:22:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1LNAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:22:43 -0500
Date: Tue, 13 Dec 2011 16:22:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH][V4] Add reboot_pid_ns to handle the reboot syscall
Message-Id: <20111213162242.1ab3cb1a.akpm@linux-foundation.org>
In-Reply-To: <1323649064-7960-2-git-send-email-daniel.lezcano@free.fr>
References: <1323649064-7960-1-git-send-email-daniel.lezcano@free.fr>
	<1323649064-7960-2-git-send-email-daniel.lezcano@free.fr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 01:17:44 +0100
Daniel Lezcano <daniel.lezcano@free.fr> wrote:

> In the case of a child pid namespace, rebooting the system does not
> really makes sense. When the pid namespace is used in conjunction
> with the other namespaces in order to create a linux container, the
> reboot syscall leads to some problems.
> 
> A container can reboot the host. That can be fixed by dropping
> the sys_reboot capability but we are unable to correctly poweroff/
> halt/reboot a container and the container stays stuck at the shutdown
> time with the container's init process waiting indefinitively.
> 
> After several attempts, no solution from userspace was found to reliabily
> handle the shutdown from a container.
> 
> This patch propose to make the init process of the child pid namespace to
> exit with a signal status set to : SIGINT if the child pid namespace called
> "halt/poweroff" and SIGHUP if the child pid namespace called "reboot".
> When the reboot syscall is called and we are not in the initial
> pid namespace, we kill the pid namespace for "HALT", "POWEROFF", "RESTART",
> and "RESTART2". Otherwise we return EINVAL.
> 
> Returning EINVAL is also an easy way to check if this feature is supported
> by the kernel when invoking another 'reboot' option like CAD.
> 
> By this way the parent process of the child pid namespace knows if
> it rebooted or not and can take the right decision.
>
> ...
>
> +static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
> +{
> +	BUG();
> +}
>  #endif /* CONFIG_PID_NS */

I'd recommend compile-testing this...

> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -444,6 +444,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  	                magic2 != LINUX_REBOOT_MAGIC2C))
>  		return -EINVAL;
>  
> +	if (task_active_pid_ns(current) != &init_pid_ns)
> +		return reboot_pid_ns(task_active_pid_ns(current), cmd);
> +
>  	/* Instead of trying to make the power_off code look like
> 	 * halt when pm_power_off is not set do it the easy way.
> 	 */

I'll repeat my cruelly-ignored review comment for v3:

This adds a bunch of useless code if CONFIG_PID_NS=n.  It would be
better to do

#ifdef CONFIG_PID_NS
extern void pidns_handle_reboot(int cmd);
#else
static inline void pidns_handle_reboot(int cmd)
{
}
#endif

(And thereby move the additional code into pid_namespace.c)
