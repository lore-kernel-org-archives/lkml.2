Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2D1JT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:19:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:54255 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750881Ab2D1JTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:19:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Cq4F+LNrCw1qxEqdMW4tGCx5ZJ9oQKCtE94wtC0
	cGd0JqyYj+HneJ
Message-ID: <1335604790.5995.22.camel@marge.simpson.net>
Subject: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Date: Sat, 28 Apr 2012 11:19:50 +0200
Content-Type: multipart/mixed; boundary="=-DN6+atMkmN1sreDdbpVc"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DN6+atMkmN1sreDdbpVc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Greetings,

The attached testcase induces quite a bit of pid/mnt namespace leakage.
The below fixes up one of these leaks.  There's still at least one pid
namespace leak left, that being the final put_pid() in softirq context
goes missing.

A trace of the leak that's left shows... 
vsftpd-5055  [003] ....  3921.490806: proc_set_super: get_pid_ns: 0xffff8801c996e988 count:1->2
vsftpd-5055  [003] ....  3921.490823: alloc_pid: get_pid_ns: 0xffff8801c996e988 count:2->3
vsftpd-5102  [003] ....  3921.502565: switch_task_namespaces: exiting: 0xffff8801c996e988 count:3
vsftpd-5102  [003] ....  3921.522296: free_nsproxy: put_pid_ns: 0xffff8801c996e988 count:3->2
vsftpd-5055  [003] ....  3921.574201: proc_kill_sb: put_pid_ns: 0xffff8801c996e988 count:2->1

..but that should be..

vsftpd-5055  [003] ....  3921.497313: proc_set_super: get_pid_ns: 0xffff8801c6e65ff0 count:1->2
vsftpd-5055  [003] ....  3921.497330: alloc_pid: get_pid_ns: 0xffff8801c6e65ff0 count:2->3
vsftpd-5124  [003] ....  3921.502977: switch_task_namespaces: exiting: 0xffff8801c6e65ff0 count:3
vsftpd-5124  [003] ....  3921.522308: free_nsproxy: put_pid_ns: 0xffff8801c6e65ff0 count:3->2
vsftpd-5055  [003] ....  3921.698349: proc_kill_sb: put_pid_ns: 0xffff8801c6e65ff0 count:2->1
ksoftirqd/3-16    [003] ..s.  3921.702182: put_pid: put_pid_ns: 0xffff8801c6e65ff0 count:1->0

Anyway, here's what I did for one of the little buggers.

SIGCHLD delivery during fork() may cause failure, resulting in the aborted
child being cloned with CLONE_NEWPID leaking namespaces due to proc being
mounted during pid namespace creation, but not unmounted on fork() failure.

Call pid_ns_release_proc() to prevent the leaks.

Signed-off-by: Mike Galbraith <efault@gmx.de>
 
 kernel/nsproxy.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b576f7f..fd751d3 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	rcu_assign_pointer(p->nsproxy, new);
 
 	if (ns && atomic_dec_and_test(&ns->count)) {
+		/* Handle fork() failure, unmount proc before proceeding */
+		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
+			struct pid_namespace *pid_ns = ns->pid_ns;
+
+			if (pid_ns && pid_ns != &init_pid_ns)
+				pid_ns_release_proc(pid_ns);
+		}
+
 		/*
 		 * wait for others to get what they want from this nsproxy.
 		 *


--=-DN6+atMkmN1sreDdbpVc
Content-Disposition: attachment; filename="vsftpd.c"
Content-Type: text/x-csrc; name="vsftpd.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sched.h>
#include <linux/sched.h>
#include <unistd.h>
#include <sys/syscall.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <string.h>

#if !defined(WITH_SIGCHLD)
#define WITH_SIGCHLD 1
#endif

#if WITH_SIGCHLD == 1
/*
 * vsftpd 
 * sysutil.c vsf_sysutil_wait_reap_one()
 * standalone.c handle_sigchld()
 * 
 */
int vsf_sysutil_wait_reap_one(void)
{
    int retval = waitpid(-1, NULL, WNOHANG);
    if (retval == 0 || (retval < 0 && errno == ECHILD)) {
        /* No more children */
        return 0;
    }
    if (retval < 0) {
        perror("waitpid");
        exit(EXIT_FAILURE);
    }
    /* Got one */
    return retval;
}

int received;
int reaped;

void handle_sigchld(int sig)
{
    unsigned int reap_one = 1;

    received++;
    while (reap_one) {
        reap_one = (unsigned int) vsf_sysutil_wait_reap_one();
	if (reap_one)
            reaped++;
    }
}
#endif

int zombies;

int main(int argc, char *argv[])
{
    int i, ret;

#if WITH_SIGCHLD == 1
    /*
     * vsftpd sysutil.c vsf_sysutil_set_sighandler()
     */
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = handle_sigchld;
    if (-1 == sigfillset(&sa.sa_mask)) {
        perror("sigfillset");
        exit(EXIT_FAILURE);
    }
    if (-1 == sigaction(SIGCHLD, &sa, NULL)) {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }
    fprintf(stderr, "SIGCHLD handler enabled\n");
#else
    fprintf(stderr, "SIGCHLD handler not enabled\n");
#endif

    for (i = 0; i < 100; i++) {

//        if (0 == (ret = syscall(__NR_clone, CLONE_NEWPID | CLONE_NEWIPC | CLONE_NEWNET | CLONE_NEWUSER | SIGCHLD, NULL)))
        if (0 == (ret = syscall(__NR_clone, CLONE_NEWPID | SIGCHLD, NULL)))
            return 0;

        if (-1 == ret) {
            perror("clone");
            exit(EXIT_FAILURE);
        }

    }
#if 1
    while (1) {
	int res = waitpid(-1, NULL, WNOHANG);
	if (res < 0)
		break;
	if (!res)
		continue;
        zombies++;
    }
//    printf("received %d signals, reaped %d - %d zombies left\n", received, reaped, zombies);
//    sleep(1);
#endif
    return 0;
}

--=-DN6+atMkmN1sreDdbpVc--

