Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2KVS3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:29:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2KVS3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:29:04 -0500
Date: Thu, 22 Nov 2012 17:12:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range check)
Message-ID: <20121122161238.GA27078@redhat.com>
References: <20121121141627.GB21030@redhat.com> <20121121173043.F0319592076@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121173043.F0319592076@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22, Amnon Shiloh wrote:
>
> Now however, that "vsyscall" was effectively replaced by vdso, it
> creates a new problem for me and probably for anyone else who uses
> some form of checkpoint/restore:

Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
seem to enjoy trying to solve the c/r problems.

> Suppose a process is checkpointed because the system needs to reboot
> for a kernel-upgrade, then restored on the new and different kernel.
> The new VDSO page may no longer match the new kernel - it could for
> example fetch data from addresses in the vsyscall page that now
> contain different things; or in case the hardware also was changed,
> it may use machine-instructions that are now illegal.

Sure. You shouldn't try to save/restore this page(s) directly. But
I do not really understand why do you need. IOW, I don't really
understand the problem, it depends on what c/r actually does.

> As I don't mind to forego the "fast" sys_time(), my obvious solution
> is to disable the vdso for traced processes that may be checkpointed.
>
> One way to do it would be by brute-force: straight after "execve"
> unmap the tracee's vdso page,

Not sure this will be always possible. For example, my (old) glibc
assumes that vsyscall() must work, I won't be surprised if some time
later it won't work without vdso. But again, I do not know.

> then manipulate the ELF tables in
> its memory so the VDSO entry is gone and the library will not go
> looking for it.

Probably it would be enough to simply erase AT_SYSINFO_EHDR note,
but again, I can be easily wrong.

> I just wonder whether you know of an easier and more standard way
> to disable the vdso in user-mode

Only the kernel parameter, afaics. vdso=0

> - ideally on a per-process basis,
> or otherwise, if it's too hard, on the whole computer.  I searched
> the web and found references to "/proc/sys/vm/vdso_enable", but I
> have no such file or "sysctl" option on my system.

sys/vm/vdso_enabled, but only if CONFIG_X86_32 for some reason. See
kernel/sysctl.c

Oleg.

