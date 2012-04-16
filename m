Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2DPQYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:24:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2DPQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:24:10 -0400
Date: Mon, 16 Apr 2012 11:24:02 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
 force_sig()
Message-ID: <20120416162402.GA7995@sergelap>
References: <20120413004446.GA8376@redhat.com>
 <20120413182051.GA11149@sergelap>
 <20120413192455.GA24464@redhat.com>
 <20120416135931.GB4234@sergelap>
 <20120416153843.GA9302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416153843.GA9302@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 04/16, Serge Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > >
> > > Strange... I even tested this change, but only in the root namespace.
> > > OK, thanks, I'll investigate. I hope you verified your kernel has
> > > 629d362b commit ;)
> >
> > I took friday's HEAD of Linus tree.  All went fine.  Added this patch.
> > The container can shutdown, but reboot causes shutdown.  Don't undersrtand
> > why.
> 
> Heh. This looks "impossible". I'd like to understand the reason.
> So, LINUX_REBOOT_CMD_RESTART results in WIFSIGNALED() == SIGINT?
> 
> OK, I'll try to test this patch in the non-root namespace.

Playing with the test case below (based on the one Daniel submitted
alongside his container reboot patches), it looks like
WIFSIGNALED(status) and WTERMSIG(status) are 0 with this kernel, not
1 and sig.

-serge

#include <alloca.h>
#include <stdio.h>
#include <sched.h>
#include <unistd.h>
#include <signal.h>
#include <sys/reboot.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <linux/sched.h>
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

	printf("WIFSIGNALED is %d\n", WIFSIGNALED(status));

	printf("signal termination is %d, expected %d)\n", WTERMSIG(status), sig);

        if (!WIFSIGNALED(status)) {
		if (sig != -1)
			printf("child process exited but was not signaled\n");
                return -1;
        }

        if (WTERMSIG(status) != sig) {
                printf("signal termination is not the one expected\n");
                return -1;
        }

        return 0;
}

static int have_reboot_patch(void)
{
	FILE *f = fopen("/proc/sys/kernel/ctrl-alt-del", "r");
	int ret;
	int v;

	if (!f)
		return 0;

	ret = fscanf(f, "%d", &v);
	fclose(f);
	if (ret != 1)
		return 0;
	ret = reboot(v ? LINUX_REBOOT_CMD_CAD_ON : LINUX_REBOOT_CMD_CAD_OFF);
	if (ret != -1)
		return 0;
	return 1;
}

int main(int argc, char *argv[])
{
        int status;

	if (getuid() != 0) {
                printf("Must run as root.\n");
                return 1;
	}

	status = have_reboot_patch();
	if (status != 0) {
                printf("Your kernel does not have the container reboot patch\n");
                return 1;
	}

#if 0
        status = test_reboot(LINUX_REBOOT_CMD_CAD_ON, -1);
        if (status >= 0) {
                printf("reboot(LINUX_REBOOT_CMD_CAD_ON) should have failed\n");
                return 1;
        }
        printf("reboot(LINUX_REBOOT_CMD_CAD_ON) has failed as expected\n");
#endif

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

        printf("All tests passed\n");
        return 0;
}
