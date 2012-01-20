Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2ATR52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:57:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37413 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab2ATR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:57:24 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hbUm2Ff7iL5jraE7-J_GqYPf3_r4X+TJKVMeOJBZ9X-Yw@mail.gmail.com>
References: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
 <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
 <CABqD9hbUm2Ff7iL5jraE7-J_GqYPf3_r4X+TJKVMeOJBZ9X-Yw@mail.gmail.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Fri, 20 Jan 2012 09:56:58 -0800
Message-ID: <CAB=4xho3i=snOZ2+KugF4pN063gKztXzJLnyT2534XVqa43+Sg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Will Drewry <wad@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Andrew Lutomirski <luto@mit.edu>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch_ptrace, task_user_regset_view is called on current.  On an x86-64
kernel, that path is only reached for a 64-bit syscall.  compat_arch_ptrace
doesn't use it at all, always using the 32-bit view.  So your change would
have no effect on PTRACE_GETREGS.

It would only affect PTRACE_GETREGSET, which calls task_user_regset_view on
the target task.  Is that what you meant?  I think that would be confusing
at best.  A caller of PTRACE_GETREGSET is expecting a particular layout
based on what type of task he thinks he's dealing with.  The caller can
look at the iov_len in the result to discern which layout it actually got
filled in, but I don't think that's what callers expect.

The other use of task_user_regset_view is in core dump
(binfmt_elf.c:fill_note_info).  Off hand I don't think there's a way a core
dump can be started while still "inside" a syscall so that TS_COMPAT could
ever be set.  But that should be double-checked.

As to whether it was considered before, I doubt that it was.  I don't
really recall the sequence of events, but I think that I did all the
user_regset code before I was really cognizant of the TS_COMPAT subtleties.


Thanks,
Roland
