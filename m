Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1LLARx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:17:53 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:26476 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1LLARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:17:51 -0500
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: [PATCH 0/1][V4] Handle reboot in a child pid namespace
Date: Mon, 12 Dec 2011 01:17:43 +0100
Message-Id: <1323649064-7960-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



ChangeLog:
==========

 * V4
   - store the signal number the child pid namespace init should
     exit from. It is simpler, cleaner, and does not add more encoding
     bits to the exit code of the process.
 * V3
   - removed lock and serialization of pid_ns_reboot
 * V2
   - added a lock for the pid namespace to prevent racy call
     to the 'reboot' syscall
   - Moved 'reboot' command assigned in zap_pid_ns_processes
     instead of wait_task_zombie
   - added tasklist lock around force_sig
   - added do_exit in pid_ns_reboot
   - used task_active_pid_ns instead of declaring a new variable in sys_reboot
   - moved code up before POWER_OFF changed to HALT in sys_reboot


Test case:
==========

#include <alloca.h>
#include <stdio.h>
#include <sched.h>
#include <unistd.h>
#include <signal.h>
#include <sys/reboot.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <linux/reboot.h>

static int do_reboot(void *arg)
{
        int *cmd = arg;

        if (reboot(*cmd))
                printf("failed to reboot(%d): %m\n", *cmd);
}

int test_reboot(int cmd, int sig)
{
        long stack_size = 4096;
        void *stack = alloca(stack_size) + stack_size;
        int status;
        pid_t ret;

        ret = clone(do_reboot, stack, CLONE_NEWPID | SIGCHLD, &cmd);
        if (ret < 0) {
                printf("failed to clone: %m\n");
                return -1;
        }

        if (wait(&status) < 0) {
                printf("unexpected wait error: %m\n");
                return -1;
        }

        if (!WIFSIGNALED(status)) {
                printf("child process exited but was not signaled\n");
                return -1;
        }

        if (WTERMSIG(status) != sig) {
                printf("signal termination is not the one expected\n");
                return -1;
        }

        return 0;
}

int main(int argc, char *argv[])
{
        int status;

        status = test_reboot(LINUX_REBOOT_CMD_RESTART, SIGHUP);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_RESTART) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_RESTART2, SIGHUP);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_RESTART2) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_HALT, SIGINT);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_HALT) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_POWER_OFF, SIGINT);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_POWERR_OFF) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_CAD_ON, -1);
        if (status >= 0) {
                printf("reboot(LINUX_REBOOT_CMD_CAD_ON) should have failed\n");
                return 1;
        }
        printf("reboot(LINUX_REBOOT_CMD_CAD_ON) has failed as expected\n");

        return 0;
}

Daniel Lezcano (1):
  Add reboot_pid_ns to handle the reboot syscall

 include/linux/pid_namespace.h |    8 +++++++-
 kernel/pid_namespace.c        |   33 +++++++++++++++++++++++++++++++++
 kernel/sys.c                  |    3 +++
 3 files changed, 43 insertions(+), 1 deletions(-)

-- 
1.7.5.4

