Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab1CDRNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:13:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759270Ab1CDRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:13:18 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinn_J3fxyjgQk02mHpbxh_5fXNk1qT-YwjgCGqK@mail.gmail.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com> <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
 <20110304134126.GL20499@htj.dyndns.org> <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
 <20110304140745.GP20499@htj.dyndns.org> <AANLkTina7D3QffUK7vYvc3aVTvbcJQqm8VgQP3xJKYdw@mail.gmail.com>
 <20110304144059.GS20499@htj.dyndns.org> <AANLkTinn_J3fxyjgQk02mHpbxh_5fXNk1qT-YwjgCGqK@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Mar 2011 09:12:57 -0800
Message-ID: <AANLkTinwo05bRQ8YE2-gmD0cY-8ML7vkiCkbhWOWn+=C@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 9:05 AM, Denys Vlasenko <vda.linux@googlemail.com> wrote:
>
> Here's a typical sequence of operations strace is doing:
>
> wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTRAP}], __WALL, NULL) = 10445
> ptrace(PTRACE_GETSIGINFO, 10445, 0, {si_signo=SIGTRAP, si_code=0x5,
> si_pid=10445, si_uid=0, si_value={int=0, ptr=0}}) = 0
> ptrace(PTRACE_PEEKUSER, 10445, 8*ORIG_RAX, [0x36]) = 0
> ptrace(PTRACE_PEEKUSER, 10445, 8*CS, [0x23]) = 0
> ptrace(PTRACE_PEEKUSER, 10445, 8*RAX, [0xffffffffffffffda]) = 0
> ptrace(PTRACE_PEEKUSER, 10445, 8*RBX, [0x1]) = 0
> ptrace(PTRACE_PEEKUSER, 10445, 8*RCX, [0x5401]) = 0
> ptrace(PTRACE_PEEKUSER, 10445, 8*RDX, [0xffb83f10]) = 0
> ptrace(PTRACE_SYSCALL, 10445, 0x1, SIG_0) = 0
>
> IOW: strace wastes a lot of time just transiting to the kernel and back
> with simple syscalls to get the information.
>
> What would help here is a "vectorized" waitpid operation
> which retrieves much more information in one go:
>
> waitpid_vec(int max_results, int status_vector[], siginfo_t
> si_vector[], struct pt_regs reg_vector[])

No. Start off with what we already have: make ptrace use
"PTRACE_GETREGSET" instead of PTRACE_PEEKUSER.

That should get the whole "user_regs_struct" in one single system call.

                                      Linus
