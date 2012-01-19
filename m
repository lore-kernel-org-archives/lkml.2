Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2ASPlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:41:21 -0500
Received: from mail2.shareable.org ([80.68.89.115]:37465 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2ASPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:41:19 -0500
Date: Thu, 19 Jan 2012 15:40:14 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Evans <scarybeasts@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
Message-ID: <20120119154014.GM7180@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org>
 <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org>
 <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
 <fbc1f44dffce6079fa7ec827c1b1e40e.squirrel@webmail.greenhost.nl>
 <CAMnK33WAUA7bNFKA8BmLHq9+sdMV9xeOvZ8T1iZSH1GFKNe3ZQ@mail.gmail.com>
 <54555afe915a79f7e77ee0f44ee6cb67.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54555afe915a79f7e77ee0f44ee6cb67.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Wed, January 18, 2012 22:13, Chris Evans wrote:
> > On Wed, Jan 18, 2012 at 4:12 AM, Indan Zupancic <indan@nul.nu> wrote:
> >> On Wed, January 18, 2012 06:43, Chris Evans wrote:
> >>> 2) Tracee traps
> >>> 2b) Tracee could take a SIGKILL here
> >>> 3) Tracer looks at registers; bad syscall
> >>> 3b) Or tracee could take a SIGKILL here
> >>> 4) The only way to stop the bad syscall from executing is to rewrite
> >>> orig_eax (PTRACE_CONT + SIGKILL only kills the process after the
> >>> syscall has finished)
> >>
> >> Yes, we rewrite it to -1.
> >>
> >>> 5) Disaster: the tracee took a SIGKILL so any attempt to address it by
> >>> pid (such as PTRACE_SETREGS) fails.
> >>
> >> I assume that if a task can execute system calls and we get ptrace events
> >> for that, that we can do other ptrace operations too. Are you saying that
> >> the kernel has this ptrace gap between SIGKILL and task exit where ptrace
> >> doesn't work but the task continues executing system calls? That would be
> >> a huge bug, but it seems very unlikely too, as the task is stopped and
> >> shouldn't be able to disappear till it is continued by the tracer.
> >>
> >> I mean, really? That would be stupid.
> 
> Okay, I tested this scenario and you're right, we're screwed.

Ha!

Perhaps this could be fixed generically in
tracehook_report_syscall_entry(), for those architectures which bother
to call it and bother to disable the syscall if it says to.

-- Jamie
