Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1IRPE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:04:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36938 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab1IRPE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:04:27 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 18 Sep 2011 17:04:06 +0200
Message-ID: <CAKgNAkipOC3kcq3jXxTxpKDECXjwNwv_aRF5ycp6pUTMw8YhHg@mail.gmail.com>
Subject: rt_sigqueueinfo/rt_tgsigqueueinfo man page
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
        Michael Kerrisk <mtk.manpages@googlemail.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas

Long ago (see below) you added the rt_tgsigqueueinfo() syscall, and
provided the essential documentation:

On Thu, Feb 26, 2009 at 2:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.
>
> Find below the raw documentation.
>
> Thanks,
>
>        tglx
> ----
>
> NAME
>       rt_tgsigqueueinfo - Send signal information to a signal to a thread
>
> SYNOPSIS
>       long sys_rt_tgsigqueueinfo (int tgid, int tid, int sig, siginfo_t *uinfo);
>
> DESCRIPTION
>
>       rt_tgsigqueueinfo sends signal sig information uinfo to the
>       thread with the thread ID tid in the thread group tgid.  (By
>       contrast, rt_sigqueueinfo(2) can only be used to send a signal
>       info to a process (i.e., thread group) as a whole, and the
>       signal will be delivered to an arbitrary thread within that
>       process.)
>
> RETURN VALUE
>
>       rt_tgsigqueueinfo returns 0 on success; otherwise,
>       rt_sigqueueinfo returns one of the errors listed in the
>       "Errors" section.
>
> ERRORS
>       -EFAULT
>              An invalid value for uinfo was specified.
>
>       -EINVAL
>              An invalid TID, TGID or signal was specified.
>
>       -EPERM
>              Permission denied.  For the required permissions,
>              see rt_sigqueueinfo(2).
>
>       -ESRCH
>              No process with the specified thread ID and thread group
>              ID exists.

I've incorporated that documentation into a new rt_sigqueueinfo(2) man
page that documents both rt_sigqueueinfo() and rt_tgsigqueueinfo(). If
you have a moment, could you take a brief look ("man -l <file">) to
see that everything seems sane?

Thanks,

Michael

.\" Copyright (c) 2002, 2011 Michael Kerrisk <mtk.manpages@gmail.com>
.\"
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\"
.TH RT_SIGQUEUEINFO 2 2011-09-18 "Linux" "Linux Programmer's Manual"
.SH NAME
rt_sigqueueinfo, rt_tgsigqueueinfo \- queue a signal and data
.SH SYNOPSIS
.nf
.BI "int rt_sigqueueinfo(pid_t " tgid ", int " sig ", siginfo_t *" uinfo );
.sp
.BI "int rt_tgsigqueueinfo(pid_t " tgid ", pid_t " tid ", int " sig ,
.BI "                      siginfo_t *" uinfo );
.fi
.SH DESCRIPTION
The
.BR rt_sigqueueinfo()
and
.BR rt_tgsigqueueinfo()
system calls are the low-level interfaces used to send a signal plus data
to a process or thread.
The receiver of the signal can obtain the accompanying data
by establishing a signal handler with the
.BR sigaction (2)
.B SA_SIGINFO
flag.

These system calls are not intended for direct application use;
they are provided to allow the implementation of
.BR sigqueue (3)
and
.BR pthread_sigqueue (3).

The
.BR rt_sigqueueinfo()
system call sends the signal
.I sig
to the thread group with the ID
.IR tgid .
(The term "thread group" is synonomous with "process", and
.I tid
corresponds to the traditional UNIX process ID.)
The signal will be delivered to an arbitrary member of the thread group
(i.e., one of the threads that is not currently blocking the signal).

The
.I uinfo
argument specifies the data to accompany the signal.
This argument is a pointer to a structure of type
.IR siginfo_t ,
described in
.BR sigaction (2)
(and defined by including
.IR <sigaction.h> ).
The caller should set the following fields in this structure:
.TP
.I si_code
This must be one of the
.B SI_*
codes in the kernel source file
.IR include/asm-generic/siginfo.h ,
with the restriction that the code must be negative
(i.e., cannot be
.BR SI_USER ,
which is used by the kernel to indicate a signal sent by
.BR kill (2))
and cannot (since Linux 2.6.39) be
.BR SI_TKILL
(which is used by the kernel to indicate a signal sent using
.\" tkill(2) or
.BR tgkill (2)).
.TP
.I si_pid
This should be set to a process ID,
typically the process ID of the sender.
.TP
.I si_uid
This should be set to a user ID,
typically the real user ID of the sender.
.TP
.I si_value
This field contains the user data to accompany the signal.
For more information, see the description of the last
.RI ( "union sigval" )
argument of
.BR sigqueue (3).
.PP
Internally, the kernel sets the
.I si_signo
field to the value specified in
.IR sig ,
so that the receiver of the signal can also obtain
the signal number via that field.

The
.BR rt_tgsigueueinfo ()
system call is like
.BR rt_sigueueinfo (),
but sends the signal and data to the single thread
specified by the combination of
.IR tgid ,
a thread group ID,
and
.IR tid ,
a thread in that thread group.
.SH "RETURN VALUE"
On success, these system calls return 0.
On error, they return \-1 and
.I errno
is set to indicate the error.
.SH ERRORS
.TP
.B EAGAIN
The limit of signals which may be queued has been reached.
(See
.BR signal (7)
for further information.)
.TP
.B EINVAL
.IR sig ,
.IR tgid ,
or
.IR tid
was invalid.
.TP
.B EPERM
The caller does not have permission to send the signal to the target.
For the required permissions, see
.BR kill (2).
Or:
.I uinfo->si_code
is invalid.
.TP
.B ESRCH
.BR rt_sigqueinfo ():
No thread group matching
.I tgid
was found.
.br
.BR rt_rtsigqueinfo ():
No thread matching
.I tgid
and
.I tid
was found.
.SH VERSIONS
The
.BR rt_sigqueueinfo ()
system call was added to Linux in version 2.2.
The
.BR rt_tgsigqueueinfo ()
system call was added to Linux in version 2.6.31.
.SH "CONFORMING TO"
These system calls are Linux-specific.
.SH NOTES
Since these system calls are not intended for application use,
there are no glibc wrapper functions; use
.BR syscall (2)
in the unlikely case that you want to call them directly.

As with
.BR kill (2),
the null signal (0) can be used to check if the specified process
or thread exists.
.SH "SEE ALSO"
.BR kill (2),
.BR sigaction (2),
.BR sigprocmask (2),
.BR tgkill (2),
.BR pthread_sigqueue (3),
.BR sigqueue (3),
.BR signal (7)



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
