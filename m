Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2BCAKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:10:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2BCAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:10:20 -0500
Date: Thu, 2 Feb 2012 16:10:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 1/1][V5] Add reboot_pid_ns to handle the reboot syscall
Message-Id: <20120202161018.e3c62965.akpm@linux-foundation.org>
In-Reply-To: <1325754410-32600-2-git-send-email-daniel.lezcano@free.fr>
References: <1325754410-32600-1-git-send-email-daniel.lezcano@free.fr>
	<1325754410-32600-2-git-send-email-daniel.lezcano@free.fr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Jan 2012 10:06:50 +0100
Daniel Lezcano <daniel.lezcano@free.fr> wrote:

> In the case of a child pid namespace, rebooting the system does not
> really makes sense. When the pid namespace is used in conjunction
> with the other namespaces in order to create a linux container, the
> reboot syscall leads to some problems.
> 
> A container can reboot the host. That can be fixed by dropping
> the sys_reboot capability but we are unable to correctly to poweroff/
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

Looks OK, although the comments need help.  Is the below still true?

Do you think it would be feasible to put your testcase into
tools/testing/selftests?  I'm thinking "no", because running the test
needs elevated permissions and might reboot the user's machine(!).


--- a/include/linux/pid_namespace.h~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
+++ a/include/linux/pid_namespace.h
@@ -32,7 +32,7 @@ struct pid_namespace {
 #endif
 	gid_t pid_gid;
 	int hide_pid;
-	int reboot;
+	int reboot;	/* group exit code if this pidns was rebooted */
 };
 
 extern struct pid_namespace init_pid_ns;
--- a/kernel/sys.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix
+++ a/kernel/sys.c
@@ -444,9 +444,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 	                magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
-	/* In case the pid namespaces are enabled, the current task is in a
-	 * child pid_namespace and the command is handled by 'reboot_pid_ns',
-	 * this one will invoke 'do_exit'.
+	/*
+	 * If pid namespaces are enabled and the current task is in a child
+	 * pid_namespace, the command is handled by reboot_pid_ns() which will
+	 * call do_exit().
 	 */
 	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
 	if (ret)

> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -32,6 +32,7 @@ struct pid_namespace {
>  #endif
>  	gid_t pid_gid;
>  	int hide_pid;
> +	int reboot;
>  };

This was particuarly distressing.  The field was poorly named and other
people forgotting to document their data structures doesn't mean that
we should continue to do this!


