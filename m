Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2HBJPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 05:15:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50309 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2HBJPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 05:15:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120802065557.GI6481@ZenIV.linux.org.uk>
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org>
 <5019B36A.4030604@zytor.com> <CAD=T17Esguer01OsrxMtqEcHKZ-Ovg05+MxSdF7NhXENsUubgg@mail.gmail.com>
 <5019BC0E.4010109@zytor.com> <20120802065557.GI6481@ZenIV.linux.org.uk>
From: Meredydd Luff <meredydd@senatehouse.org>
Date: Thu, 2 Aug 2012 10:14:53 +0100
Message-ID: <CAD=T17Gkryua5TQW5h18kCu+yiViuVv6NyxtMw3C9we0RWzmKQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 7:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> This means you need an x32 version of the function -- execve
>> unfortunately is one of the few system calls which require a special x32
>> version (although it's a simple wrapper around sys32_execve).  See
>> sys_x32_execve.
>
> I *really* strongly object to doing that thing before we sanitize the
> situation with sys_execve().

"That thing" = "creating an x32 entry stub", or "merging execveat() at all"?

(snip)
> The thing is, there's essentially no reason to have more than one
> implementation.  What they are (badly) doing is "we need to find
> pt_regs to pass to do_execve(), the thing we are after has to be near
> our stack frame, so let's try to get to it that way".

Hang on...it's not just sys_execve that fits that description, is it?
You seem to be describing every call that needs a pt_regs parameter,
which at a glance is anything with a stub_ or PTREGSCALL in
arch/x86/kernel/entry_{32,64}.S. That's: clone, fork, vfork,
sigaltstack, iopl, execve, sigreturn, rt_sigreturn, vm86, vm86old.
Most of those are handled by a common PTREGSCALL macro, but there are
a few that get special treatment (different set on each arch - on
x86-64 it's execve and rt_sigreturn ; on i386 it's just clone).

Is there's something special about execve in particular, or do you
want to overhaul all the ptregscalls?

Meredydd
