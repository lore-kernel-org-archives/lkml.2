Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1JSF02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:26:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54194 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1JSF00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <4E9E17F4.7080306@gmail.com>
References: <4E9E17F4.7080306@gmail.com>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 18 Oct 2011 22:26:06 -0700
X-Google-Sender-Auth: DefgEHYU-TPR6CcVcVQrphxt4V0
Message-ID: <CALdu-PDzw=6oGBU25K0TSAckuRmfQOnA6Aw-WZJkxLj1LyvNWg@mail.gmail.com>
Subject: Re: [RFC] cgroup: syscalls limiting subsystem
To: =?UTF-8?B?xYF1a2FzeiBTb3dh?= <luksow@gmail.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 5:21 PM, Łukasz Sowa <luksow@gmail.com> wrote:
> Hi,
>
> Currently, I'm writing BSc thesis about security in modern Linux.
> Together with my thesis mentor, I decided that as practical part of my
> work I'll implement cgroup subsystem that allows to limit particular
> (defined by number) syscalls for groups of processes. The patch is ready
> for first review and we decided that I may try to push it to the
> mainline - so here it is.
>

The major problem with this approach is that denying/allowing system
calls based purely on the syscall number is very coarse. I'd guess
that most vulnerabilities in a system can be exploited just using
system calls that almost all applications need in order to get regular
work done (open, write, exec ,mmap, etc) which limits the utility of
only being able to turn them off by syscall number. So overall I don't
think you'll find very much support for this patch.

Having said that, to address the patch itself:

>
> Things that I dislike or particularly need comments are:
> 1. The asm parts where I push/pop callee-modified registers are ugly.
> I'm aware of macros (for x64) like SAVE_ARGS and RESTORE_ARGS but they
> simply don't work for me because they modify EFLAGS registers (because
> of sub instruction I suppose), forcing me to write uglier and less
> efficient code (additional jump needed). I can elaborate on this, if
> someone's in doubt. Maybe another version of the SAVE_ARGS/RESTORE_ARGS
> macro is needed?

Can't you hook into the ptrace callpath? That's already implemented on
every architecture. Set the thread bit that triggers diverting to
syscall_trace_enter() only when any of the thread's syscalls are
denied, and then you don't have to work in assembly.

> 2. Performance. It's not that bad: I measured 5% more sys time for
> process on root level, and 8% more sys time for processes on first
> level. However, I think it may and should be improved but currently
> I have no idea how to do it.

Do you mean for all processes, or just for processes that had deny
bits set? If the former, then 8% is a non-starter, I think. But if you
hook into the ptrace as I suggested above, you can probably get it to
zero overhead for threads in allow-all cgroups, and I suspect people
would scream much less about slowing down threads that are being
specifically limited anyway.

> 3. Naming convention - it's not bad either but I don't like the names -
> 'scs' abbreviation sound a little bit silly but full form (syscalls)
> makes lines far too long.

I'd suggest syscall rather than scs.

> +       switch (cftype->private) {
> +       case SCS_CGROUP_ALLOW:
> +               for (bit = 0; bit < NR_syscalls; ++bit) {
> +                       if (__scs_cgroup_perm(scg, bit))
> +                               seq_printf(seq_file, "%d\n", bit);

Since this is presumably meant to be only used programmatically (as
syscall numbers can be different on different platforms, so you'll
need programs to translate between names and numbers) I wouldn't
bother with the \n - a plain space will be fine for the process
reading it, and less destructive to screen real-estate if someone
happens to cat it by hand.

> +       switch (cftype->private) {
> +       case SCS_CGROUP_ALLOW:
> +               if (__scs_cgroup_perm(parent_scg, number)) {
> +                       write_seqlock(&scg->seqlock);
> +                       set_bit(number, scg->syscalls_bitmap);
> +                       write_sequnlock(&scg->seqlock);
> +               } else {
> +                       return -EPERM;
> +               }
> +               break;
> +       case SCS_CGROUP_DENY:
> +               write_seqlock(&scg->seqlock);
> +               clear_bit(number, scg->syscalls_bitmap);
> +               write_sequnlock(&scg->seqlock);
> +               break;

Deny needs to clear the bit in all descendants as well. And there
would need to be synchronization between checking the parent bit
during an ALLOW write, and someone changing the parent bit to a DENY.

Paul
