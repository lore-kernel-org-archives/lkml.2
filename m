Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2JGKUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 06:20:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52071 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2JGKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 06:20:39 -0400
Date: Sun, 7 Oct 2012 14:20:34 +0400
From: Andrew Vagin <avagin@gmail.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] [RFC] pidns: don't zap processes several times
Message-ID: <20121007102034.GA1614@gmail.com>
References: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <1349603358-1085282-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

The test program is attached.

On Sun, Oct 07, 2012 at 01:49:18PM +0400, Andrew Vagin wrote:
> I wrote a test program. It does clone(CLONE_NEWPID | CLONE_VM) and
> sleep(), a new task repeates the same actions. This program creates
> 4000 tasks. When I tried to kill all this processes, a system was
> inaccessible for some minutes.
> 
> The system is inaccessible, because each process calls
> zap_pid_ns_processes, which tries to kill subprocesses under
> tasklist_lock. The most time are required for find_vpid().
> 
> I suggest to mark sub-namespaces in zap_pid_ns_processes.
> zap_pid_ns_processes for marked pidns doesn't kill tasks,
> it only waits them.
> 
> I am not sure, that this idea is correct, but it helps.
> 
> Maybe we should restrict depth of pidns?
> Why can't we enumerate task->children instead of using find_vpid()?
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  include/linux/pid_namespace.h |    1 +
>  kernel/pid_namespace.c        |   14 ++++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 00474b0..28073a0 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -34,6 +34,7 @@ struct pid_namespace {
>  	kgid_t pid_gid;
>  	int hide_pid;
>  	int reboot;	/* group exit code if this pidns was rebooted */
> +	atomic_t zapped; /* non zero if all process were killed */
>  };
>  
>  extern struct pid_namespace init_pid_ns;
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index b051fa6..7db7dcd 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -177,21 +177,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	 * 	  maintain a tasklist for each pid namespace.
>  	 *
>  	 */
> +
> +	if (atomic_read(&pid_ns->zapped))
> +		goto wait; /* All processes were already killed */
> +
>  	read_lock(&tasklist_lock);
>  	nr = next_pidmap(pid_ns, 1);
>  	while (nr > 0) {
>  		rcu_read_lock();
>  
>  		task = pid_task(find_vpid(nr), PIDTYPE_PID);
> -		if (task && !__fatal_signal_pending(task))
> +		if (task && !__fatal_signal_pending(task)) {
> +			struct pid_namespace *ns;
> +
>  			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
> +			ns = task_active_pid_ns(task);
> +			if (unlikely(ns->child_reaper == task))
> +				atomic_set(&ns->zapped, 1);
> +		}
>  
>  		rcu_read_unlock();
>  
>  		nr = next_pidmap(pid_ns, nr);
>  	}
>  	read_unlock(&tasklist_lock);
> -
> +wait:
>  	/* Firstly reap the EXIT_ZOMBIE children we may have. */
>  	do {
>  		clear_thread_flag(TIF_SIGPENDING);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="test.c"

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sched.h>

struct args {
	char body[1024];
	char ptr[0];
};


static i = 0;

static int ns_exec(void *_arg)
{
	pid_t pid;
	int status;
	struct args *args = malloc(sizeof(struct args));

	if (args == NULL) {
		printf("Can't allocate memory\n");
		return 1;
	}

	if (i++ > 4000)
		return 0;

	pid = clone(ns_exec, args->ptr,
			CLONE_NEWPID | CLONE_VM | SIGCHLD, NULL);
	if (pid == -1) {
		printf("clone() failed: %m\n");
		return 1;
	}

	while (1)
		sleep(1000);

	return 0;
}

int main(int argc, char **argv)
{
	ns_exec(NULL);
	return 0;
}

--J2SCkAp4GZ/dPZZf--
