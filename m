Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1LMWJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:09:58 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:45948 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab1LMWJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:09:57 -0500
Message-ID: <4EE7CD0B.60404@free.fr>
Date: Tue, 13 Dec 2011 23:09:15 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: containers@lists.linux-foundation.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH 0/1][V4] Handle reboot in a child pid namespace
References: <1323649064-7960-1-git-send-email-daniel.lezcano@free.fr>
In-Reply-To: <1323649064-7960-1-git-send-email-daniel.lezcano@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 01:17 AM, Daniel Lezcano wrote:

Does someone have an opinion for this patch ?

I cc'ed Bruno who should be interested by this feature too (sorry for
not cc'ing you before).

Oleg, I did not add your signed-off-by because I changed the patch but I
guess the V4 is what you expected to see, right ?

Thanks
  -- Daniel

> ChangeLog:
> ==========
>
>  * V4
>    - store the signal number the child pid namespace init should
>      exit from. It is simpler, cleaner, and does not add more encoding
>      bits to the exit code of the process.
>  * V3
>    - removed lock and serialization of pid_ns_reboot
>  * V2
>    - added a lock for the pid namespace to prevent racy call
>      to the 'reboot' syscall
>    - Moved 'reboot' command assigned in zap_pid_ns_processes
>      instead of wait_task_zombie
>    - added tasklist lock around force_sig
>    - added do_exit in pid_ns_reboot
>    - used task_active_pid_ns instead of declaring a new variable in sys_reboot
>    - moved code up before POWER_OFF changed to HALT in sys_reboot
>
>
> Test case:
> ==========
>
> #include <alloca.h>
> #include <stdio.h>
> #include <sched.h>
> #include <unistd.h>
> #include <signal.h>
> #include <sys/reboot.h>
> #include <sys/types.h>
> #include <sys/wait.h>
>
> #include <linux/reboot.h>
>
> static int do_reboot(void *arg)
> {
>         int *cmd = arg;
>
>         if (reboot(*cmd))
>                 printf("failed to reboot(%d): %m\n", *cmd);
> }
>
> int test_reboot(int cmd, int sig)
> {
>         long stack_size = 4096;
>         void *stack = alloca(stack_size) + stack_size;
>         int status;
>         pid_t ret;
>
>         ret = clone(do_reboot, stack, CLONE_NEWPID | SIGCHLD, &cmd);
>         if (ret < 0) {
>                 printf("failed to clone: %m\n");
>                 return -1;
>         }
>
>         if (wait(&status) < 0) {
>                 printf("unexpected wait error: %m\n");
>                 return -1;
>         }
>
>         if (!WIFSIGNALED(status)) {
>                 printf("child process exited but was not signaled\n");
>                 return -1;
>         }
>
>         if (WTERMSIG(status) != sig) {
>                 printf("signal termination is not the one expected\n");
>                 return -1;
>         }
>
>         return 0;
> }
>
> int main(int argc, char *argv[])
> {
>         int status;
>
>         status = test_reboot(LINUX_REBOOT_CMD_RESTART, SIGHUP);
>         if (status < 0)
>                 return 1;
>         printf("reboot(LINUX_REBOOT_CMD_RESTART) succeed\n");
>
>         status = test_reboot(LINUX_REBOOT_CMD_RESTART2, SIGHUP);
>         if (status < 0)
>                 return 1;
>         printf("reboot(LINUX_REBOOT_CMD_RESTART2) succeed\n");
>
>         status = test_reboot(LINUX_REBOOT_CMD_HALT, SIGINT);
>         if (status < 0)
>                 return 1;
>         printf("reboot(LINUX_REBOOT_CMD_HALT) succeed\n");
>
>         status = test_reboot(LINUX_REBOOT_CMD_POWER_OFF, SIGINT);
>         if (status < 0)
>                 return 1;
>         printf("reboot(LINUX_REBOOT_CMD_POWERR_OFF) succeed\n");
>
>         status = test_reboot(LINUX_REBOOT_CMD_CAD_ON, -1);
>         if (status >= 0) {
>                 printf("reboot(LINUX_REBOOT_CMD_CAD_ON) should have failed\n");
>                 return 1;
>         }
>         printf("reboot(LINUX_REBOOT_CMD_CAD_ON) has failed as expected\n");
>
>         return 0;
> }
>
> Daniel Lezcano (1):
>   Add reboot_pid_ns to handle the reboot syscall
>
>  include/linux/pid_namespace.h |    8 +++++++-
>  kernel/pid_namespace.c        |   33 +++++++++++++++++++++++++++++++++
>  kernel/sys.c                  |    3 +++
>  3 files changed, 43 insertions(+), 1 deletions(-)
>

