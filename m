Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab1CDTAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:00:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64860 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1CDTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Rqt0tjbpUMxWk9XNxPVtvlHRGBAo1Z6Jkl5KVpZEWLPVBVCxRTbAjNez/DD0iHCeoX
         GpOYgT6E5hQczQO+6y3tVrKynjSQOnjlx03kvEProSkdnwC7akkyfTgrDeAFcOlRGAOj
         QBpjP3NsqRIhI/GDvj4BFAHlZxsQC28ZYPX4k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] Proposal for ptrace improvements
Date: Fri, 4 Mar 2011 19:59:57 +0100
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTinn_J3fxyjgQk02mHpbxh_5fXNk1qT-YwjgCGqK@mail.gmail.com> <AANLkTinwo05bRQ8YE2-gmD0cY-8ML7vkiCkbhWOWn+=C@mail.gmail.com>
In-Reply-To: <AANLkTinwo05bRQ8YE2-gmD0cY-8ML7vkiCkbhWOWn+=C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103041959.57966.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011 18:12, Linus Torvalds wrote:
> On Fri, Mar 4, 2011 at 9:05 AM, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> >
> > Here's a typical sequence of operations strace is doing:
> >
> > wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGTRAP}], __WALL, NULL) = 10445
> > ptrace(PTRACE_GETSIGINFO, 10445, 0, {si_signo=SIGTRAP, si_code=0x5,
> > si_pid=10445, si_uid=0, si_value={int=0, ptr=0}}) = 0
> > ptrace(PTRACE_PEEKUSER, 10445, 8*ORIG_RAX, [0x36]) = 0
> > ptrace(PTRACE_PEEKUSER, 10445, 8*CS, [0x23]) = 0
> > ptrace(PTRACE_PEEKUSER, 10445, 8*RAX, [0xffffffffffffffda]) = 0
> > ptrace(PTRACE_PEEKUSER, 10445, 8*RBX, [0x1]) = 0
> > ptrace(PTRACE_PEEKUSER, 10445, 8*RCX, [0x5401]) = 0
> > ptrace(PTRACE_PEEKUSER, 10445, 8*RDX, [0xffb83f10]) = 0
> > ptrace(PTRACE_SYSCALL, 10445, 0x1, SIG_0) = 0
> >
> > IOW: strace wastes a lot of time just transiting to the kernel and back
> > with simple syscalls to get the information.
> >
> > What would help here is a "vectorized" waitpid operation
> > which retrieves much more information in one go:
> >
> > waitpid_vec(int max_results, int status_vector[], siginfo_t
> > si_vector[], struct pt_regs reg_vector[])
> 
> No. Start off with what we already have: make ptrace use
> "PTRACE_GETREGSET" instead of PTRACE_PEEKUSER.
> 
> That should get the whole "user_regs_struct" in one single system call.

Aye. That's the idea: get more info in one go.

I bet a part of the rationale for PTRACE_GETREGSET
was to get not one register per syscall, but all of them.

We have more of these:

readv/writev

Get not one signal, but many of them (signalfd).

Get not one task's wait notification, but many of them,
    and also get accompanying siginfo etc (waitpidv?
    or better, waitfd?)

-- 
vda
