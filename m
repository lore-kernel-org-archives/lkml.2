Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2BCPop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:44:45 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39298 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2BCPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:44:44 -0500
Date: Fri, 3 Feb 2012 16:44:11 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>
Cc: linux-kernel@vger.kernel.org, Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: cgroup_release_agent() with call_usermodehelper() with UMH_WAIT_EXEC
 may crash
Message-ID: <20120203154411.GB2471@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020315-5024-0000-0000-00000198A936
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sebastian today sent me a dump with this crash:

[    9.642907] Unable to handle kernel pointer dereference at virtual kernel address 0000000039768000
[    9.642918] Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    9.642934] Modules linked in: qeth_l3 lcs ctcm fsm vmur qeth ccwgroup autofs4 [last unloaded: scsi_wait_scan]
[    9.642965] CPU: 0 Not tainted 3.3.0-rc2-00037-gbd3ce7d-dirty #48
[    9.643011] Process kworker/u:3 (pid: 245, task: 000000003a3dc840, ksp: 0000000039453818)
[    9.643015] Krnl PSW : 0704000180000000 0000000000282e94 (setup_new_exec+0xa0/0x374)
[    9.643026]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[    9.643032] Krnl GPRS: 0000000030844dcb fffffffffffffffd 0000000039768000 0000000000000000
[    9.643039]            00000000000000cd 0000000000243c18 00000000000001f8 0000000039453dd0
[    9.643045]            000000003dc55220 0000000000000000 00000000006f4800 000000003dc55220
[    9.643051]            0000000000000000 00000000005dd958 00000000002830f0 0000000039453a18
[    9.643067] Krnl Code: 0000000000282e84: c0e5ffffff52        brasl   %r14,282d28
[    9.643079]            0000000000282e8a: e320b0c80004        lg      %r2,200(%r11)
[    9.643092]           #0000000000282e90: a7380000            lhi     %r3,0
[    9.643108]           >0000000000282e94: e31020000090        llgc    %r1,0(%r2)
[    9.643123]            0000000000282e9a: 41202001            la      %r2,1(%r2)
[    9.643162]            0000000000282e9e: 1241                ltr     %r4,%r1
[    9.643168]            0000000000282ea0: a7840018            brc     8,282ed0
[    9.643175]            0000000000282ea4: a74e002f            chi     %r4,47
[    9.643183] Call Trace:
[    9.643186] ([<0000000000282e2c>] setup_new_exec+0x38/0x374)
[    9.643192]  [<00000000002dd12e>] load_elf_binary+0x402/0x1bf4
[    9.643201]  [<0000000000280a42>] search_binary_handler+0x38e/0x5bc
[    9.643210]  [<0000000000282b6c>] do_execve_common+0x410/0x514
[    9.643218]  [<0000000000282cb6>] do_execve+0x46/0x58
[    9.643225]  [<00000000005bce58>] kernel_execve+0x28/0x70
[    9.643236]  [<000000000014ba2e>] ____call_usermodehelper+0x102/0x140
[    9.643245]  [<00000000005bc8da>] kernel_thread_starter+0x6/0xc
[    9.643254]  [<00000000005bc8d4>] kernel_thread_starter+0x0/0xc
[    9.643264] INFO: lockdep is turned off.
[    9.643269] Last Breaking-Event-Address:
[    9.643275]  [<00000000002830f0>] setup_new_exec+0x2fc/0x374
[    9.643311]  
[    9.643315] Kernel panic - not syncing: Fatal exception: panic_on_oops

As it happens it is a use-after-free bug. It crashes in setup_new_exec() when
trying to dereference name:

setup_new_exec(...)
	[...]
	name = bprm->filename;

	/* Copies the binary name from after last slash */
	for (i=0; (ch = *(name++)) != '\0';) {	<-- crashes here
		if (ch == '/')

Looking into the dump I was able to tell that the piece of memory got freed
by cgroup_release_agent().
Which has the following code sequence:

static void cgroup_release_agent(struct work_struct *work)
{
		[...]
		agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
		[...]
		i = 0;
		argv[i++] = agentbuf;
		[...]
		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
		[...]
		kfree(agentbuf);
		[...]
}

So obviously cgroup_release_agent() freed the filename before do_execve()
was finished.

call_usermodehelper() will enqueue a struct work which will call
__call_usermodehelper() which in turn will create a kernel_thread which
executes ____call_usermodehelper(). Here it sets the flag CLONE_VFORK to
ensure that all needed structures stay alive until the code from
____call_usermodehelper() gets replaced by the to be executed process.

So due to CLONE_VFORK kernel_thread() will block until the child process
has replaced it's mm, which happens in
load_elf_binary() -> flush_old_exec() -> exec_mmap() -> mm_release()
and which subsequently wakes up the parent again. So the parent will
continue and in the end return from call_usermodehelper() and free
the passed path (aka agentbuf).

However the call to flush_old_exec() happens right _before_ the call
to setup_new_exec() which still needs the path and may crash if
it got freed (like it did this time).

So the question is: what is broken? The cgroup stuff which doesn't take
into account that the passed path may still be in use and hence can't
be freed (simple fix would be to simply use UMH_WAIT_PROC instead).
Or is it that call_usermodehelper() still uses the passed path after
it returned?

