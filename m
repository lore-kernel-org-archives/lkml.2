Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1L2MK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 07:10:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab1L2MKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 07:10:53 -0500
Date: Thu, 29 Dec 2011 13:05:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: Possible bug introduced in commit 9b84cca
Message-ID: <20111229120506.GA23653@redhat.com>
References: <201112281955.55200.vda.linux@googlemail.com> <20111229113245.GA18062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111229113245.GA18062@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Oleg Nesterov wrote:
>
> On 12/28, Denys Vlasenko wrote:
> >
> > Looks like after commit 9b84cca, waitpid under strace
> > sometimes returns bogus ECHILD while child does exist.
> >
> > I did not yet confirm that the bug appeared exactly
> > at this commit - Łukasz says that.
> >
> > I confirmed that bug exists on kernels 3.1.6 (in Fedora)
> > and 3.1.0-rc4 (vanilla).
> >
> > We have a testcase which spawns N threads, each of them
> > performs an infinite loop "fork, exit in child, waitpid
> > in parent for the child". When straced, sometimes waitpid
> > returns ECHILD.
>
> You mean, the natural parent gets ECHILD, not strace?
>
> > The key part is here:
> >
> > 931   clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xf763dbd8) = 1048
> > 1048  exit_group(42)                    = ?
> > 931   waitpid(1048,  <unfinished ...>
> > 1048  +++ exited with 42 +++
> > 931   <... waitpid resumed> 0xf763d3a0, 0) = -1 ECHILD (No child processes)
>
> Argh. I seem to understand
>
> I didn't check, but I think the offending commit is 823b018e5b1196d8
> "job control: Small reorganization of wait_consider_task()".
>
> ptracer sees EXIT_ZOMBIE and temporary sets EXIT_DEAD, this fools
> the ->real_parent.
>
> I need to think. The fix should be simple, but perhaps it is the
> time to kill EXIT_DEAD altogether. I'll try to make the patch
> after vacation. In the next year ;)
>
> Thanks a lot Denys!

I've made the simple test-case, it triggers the bug.

Oleg.

#include <sys/ptrace.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>

int main(void)
{
	int pid, status;

	pid = fork();
	if (!pid) {
		for (;;) {
			if (!fork())
				return 0x23;
			assert(waitpid(-1, &status, 0) > 0);
			assert(status == 0x2300);
		}
	}

	assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);
	assert(waitpid(-1, NULL, 0) == pid);

	assert(ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_TRACEFORK) == 0);

	for (;;) {
		ptrace(PTRACE_CONT, pid, 0, 0);
		pid = waitpid(-1, NULL, 0);
		assert(pid > 0);
	}

	return 0;
}

