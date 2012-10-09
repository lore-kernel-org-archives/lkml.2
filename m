Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2JIVfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:35:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36713 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab2JIVf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:35:29 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 9 Oct 2012 23:35:08 +0200
Message-ID: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
Subject: [Request for review] Revised delete_module(2) manual page
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-man <linux-man@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees, Rusty,

The current delete_module(2) page is severely out of date (basically,
its content corresponds to 2.4 days, and was even pretty thin in
covering that). So, I took a shot at revising the page to Linux 2.6+
reality. Would it be possible that you could review it?

Thanks,

Michael



.\" Copyright (C) 1996 Free Software Foundation, Inc.
.\" and Copyright (C) 2012 Michael Kerrisk <mtk.manpages@gmail.com>
.\" This file is distributed according to the GNU General Public License.
.\" See the file COPYING in the top level source directory for details.
.\"
.\" 2006-02-09, some reformatting by Luc Van Oostenryck; some
.\" reformatting and rewordings by mtk
.\"
.TH DELETE_MODULE 2 2012-10-09 "Linux" "Linux Programmer's Manual"
.SH NAME
delete_module \- unload a kernel module
.SH SYNOPSIS
.nf
.BI "int delete_module(const char *" name ", int " flags );
.fi

.IR Note :
There is no glibc wrapper for this system call; see NOTES.
.SH DESCRIPTION
.BR delete_module ()
attempts to remove the unused loadable module entry
identified by
.IR name .
This system call requires privilege.

If there are other loaded modules that depend on
(i.e., refer to symbols defined in) this module,
then the call fails.
Otherwise, by default,
.BR delete_module ()
marks a module so that no new references are permitted.
If the module's reference count
(i.e., the number of processes currently using the module) is nonzero,
it then places the caller in an uninterruptible sleep
state until all reference count is zero,
at which point the call unblocks.
When the reference count reaches zero, the module is unloaded.
When the module is unloaded, the kernel executes its
.I exit
function.

The
.IR flags
argument can be used to modify the behavior of the system call.
The following values can be ORed in this argument:
.TP
.B O_TRUNC
.\"  	KMOD_REMOVE_FORCE in kmod library
Force unloading of the module, even if the following conditions are true:
.RS
.IP * 3
The module has no
.I exit
function.
By default, attempting to unload a module that has no
.I exit
function fails.
.IP *
The reference count for (i.e., the number of processes currently using)
this module is nonzero.
See the description of
.BR O_NONBLOCK .
.RE
.IP
Using this flag taints the kernel (TAINT_FORCED_RMMOD).
.IP
.IR "Using this flag is dangerous!"
If the kernel was not built with
.BR CONFIG_MODULE_FORCE_UNLOAD ,
this flag is silently ignored.
.TP
.B O_NONBLOCK
.\"  	KMOD_REMOVE_NOWAIT in kmod library
If both
.B O_NONBLOCK
and
.B O_TRUNC
are specified in
.IR flags
(and the kernel was built with
.BR CONFIG_MODULE_FORCE_UNLOAD ),
then the module is unloaded immediately,
regardless of whether it has a nonzero reference count.
If
.B O_NONBLOCK
was specified, but
.B O_TRUNC
was not, then an error is returned
if the module has a nonzero reference count.
.SH "RETURN VALUE"
On success, zero is returned.
On error, \-1 is returned and
.I errno
is set appropriately.
.SH ERRORS
.TP
.B EBUSY
The module is not "live"
(i.e., it is still being initialized or is already marked for removal);
or, the module has no
.I exit
function and
.B O_TRUNC
was not specified in
.IR flags .

.TP
.B EFAULT
.I name
is outside the program's accessible address space.
.TP
.B EINVAL
.I name
was an empty string.
.TP
.B ENOENT
No module by that name exists.
.TP
.B EPERM
The caller was not privileged
(did not have the
.B CAP_SYS_MODULE
capability),
or module unloading is disabled
(see
.IR /proc/sys/kernel/modules_disabled
in
.BR proc (5)).
.TP
.B EWOULDBLOCK
Other modules depend on this module;
or,
.BR O_NONBLOCK
was specified in
.IR flags ,
but the reference count of this module is nonzero and
.B O_TRUNC
was not specified in
.IR flags .
.SH "CONFORMING TO"
.BR delete_module ()
is Linux-specific.
.SH NOTES
Glibc does not provide a wrapper for this system call; call it using
.BR syscall (2).

See the Linux kernel source file
.I include/linux/module.h
for some useful background information.

.SS Linux 2.4 and earlier
In Linux 2.4 and earlier, the system call took only one argument:

.BI "   int delete_module(const char *" name );

If
.I name
is NULL, all unused modules marked auto-clean are removed.

Some further details of differences in the behavior of
.BR delete_module ()
in Linux 2.4 and earlier are
.I not
currently explained in this manual page.
.SH "SEE ALSO"
.BR create_module (2),
.BR init_module (2),
.BR query_module (2),
.BR rmmod (8)
