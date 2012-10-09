Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2JIVbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:31:11 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44917 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2JIVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:31:08 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120920232737.GA2953@www.outflux.net>
References: <20120920232737.GA2953@www.outflux.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 9 Oct 2012 23:30:47 +0200
Message-ID: <CAKgNAkheF8=ssrE=_JP-ApDP5zXeHSYVG+0x6Wfd6U28TcPSHQ@mail.gmail.com>
Subject: Re: [PATCH] init_module: update to modern interfaces
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-man <linux-man@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC widened, so that some more review might come in. Rusty?]

Hello Kees,

Comments below.

On Fri, Sep 21, 2012 at 1:27 AM, Kees Cook <keescook@chromium.org> wrote:
> This updates init_module(2) to reflect the reality of 2.6+ module
> loading interfaces. It additionally drops references to the extra
> deprecated module functions create_module(2) and query_module(2).
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  man2/delete_module.2 |    7 ++--
>  man2/init_module.2   |   90 +++++++++++++++++--------------------------------
>  2 files changed, 34 insertions(+), 63 deletions(-)
>
> diff --git a/man2/delete_module.2 b/man2/delete_module.2
> index 90c9d7e..55b0d7e 100644
> --- a/man2/delete_module.2
> +++ b/man2/delete_module.2
> @@ -4,8 +4,9 @@
>  .\"
>  .\" 2006-02-09, some reformatting by Luc Van Oostenryck; some
>  .\" reformatting and rewordings by mtk
> +.\" 2012-09-20, drop references to deprecated syscalls, by Kees Cook.
>  .\"
> -.TH DELETE_MODULE 2 2006-02-09 "Linux" "Linux Programmer's Manual"
> +.TH DELETE_MODULE 2 2012-09-20 "Linux" "Linux Programmer's Manual"
>  .SH NAME
>  delete_module \- delete a loadable module entry
>  .SH SYNOPSIS
> @@ -52,6 +53,4 @@ capability).
>  .BR delete_module ()
>  is Linux-specific.
>  .SH "SEE ALSO"
> -.BR create_module (2),
> -.BR init_module (2),
> -.BR query_module (2)
> +.BR init_module (2)
> diff --git a/man2/init_module.2 b/man2/init_module.2
> index d324b51..bf37bdc 100644
> --- a/man2/init_module.2
> +++ b/man2/init_module.2
> @@ -1,64 +1,40 @@
>  .\" Copyright (C) 1996 Free Software Foundation, Inc.
>  .\" This file is distributed according to the GNU General Public License.
>  .\" See the file COPYING in the top level source directory for details.
> +.\" and Copyright (C) 2012 Kees Cook <keescook@chromium.org>
>  .\"
>  .\" 2006-02-09, some reformatting by Luc Van Oostenryck; some
>  .\" reformatting and rewordings by mtk
> +.\" 2012-09-20, updated for current interface realities by Kees Cook.
>  .\"
> -.TH INIT_MODULE 2 2006-02-09 "Linux" "Linux Programmer's Manual"
> +.TH INIT_MODULE 2 2012-09-20 "Linux" "Linux Programmer's Manual"
>  .SH NAME
>  init_module \- initialize a loadable module entry
>  .SH SYNOPSIS
>  .nf
>  .B #include <linux/module.h>
>  .sp
> -.BI "int init_module(const char *" name ", struct module *" image );
> +.BI "int init_module(const void *" module ", unsigned long " length ","
> +.BI "                const char *" args );
>  .fi
>  .SH DESCRIPTION
>  .BR init_module ()
> -loads the relocated module image into kernel space and runs the
> -module's
> +loads an ELF image of
> +.I length
> +bytes from
> +.I module
> +into kernel space, performs relocations and runs the module's
>  .I init
> -function.
> +function, passing the user option string
> +.I args
> +for parsing by the newly running kernel module.
>  .PP
> -The module image begins with a module structure and is followed by
> -code and data as appropriate.
> -The module structure is defined as follows:
> +The module image should be a valid ELF image, built for the running kernel.
>  .PP
> -.in +4n
> -.nf
> -struct module {
> -    unsigned long         size_of_struct;
> -    struct module        *next;
> -    const char           *name;
> -    unsigned long         size;
> -    long                  usecount;
> -    unsigned long         flags;
> -    unsigned int          nsyms;
> -    unsigned int          ndeps;
> -    struct module_symbol *syms;
> -    struct module_ref    *deps;
> -    struct module_ref    *refs;
> -    int                 (*init)(void);
> -    void                (*cleanup)(void);
> -    const struct exception_table_entry *ex_table_start;
> -    const struct exception_table_entry *ex_table_end;
> -#ifdef __alpha__
> -    unsigned long gp;
> -#endif
> -};
> -.fi
> -.in
> -.PP
> -All of the pointer fields, with the exception of
> -.I next
> -and
> -.IR refs ,
> -are expected to point within the module body and be
> -initialized as appropriate for kernel space, that is, relocated with
> -the rest of the module.
> -.PP
> -This system call requires privilege.
> +This system call requires privilege, and for module loading to be enabled
> +on the system. This is controlled by the
> +.I /proc/sys/kernel/modules_disabed
> +sysctl file.
>  .SH "RETURN VALUE"
>  On success, zero is returned.
>  On error, \-1 is returned and
> @@ -66,37 +42,33 @@ On error, \-1 is returned and
>  is set appropriately.
>  .SH ERRORS
>  .TP
> +.B EEXISTS
> +The module with the same name is already loaded in the kernel.
> +.TP
>  .B EBUSY
>  The module's initialization routine failed.
>  .TP
>  .B EFAULT
> -.I name
> -or
> -.I image
> +.I module
>  is outside the program's accessible address space.
>  .TP
>  .B EINVAL
> -Some
> -.I image
> -slot is filled in incorrectly,
> -.I image\->name
> -does not correspond to the original module name, some
> -.I image\->deps
> -entry does not correspond to a loaded module,
> -or some other similar inconsistency.
> +Some part of the ELF image in
> +.I module
> +contains inconsistencies.
>  .TP
> -.B ENOENT
> -No module by that name exists.
> +.B ENOEXEC
> +The ELF image in
> +.I module
> +is too small or has corrupted segments.
>  .TP
>  .B EPERM
>  The caller was not privileged
>  (did not have the
>  .B CAP_SYS_MODULE
> -capability).
> +capability), or module loading was disabled.
>  .SH "CONFORMING TO"
>  .BR init_module ()
>  is Linux-specific.
>  .SH "SEE ALSO"
> -.BR create_module (2),
> -.BR delete_module (2),
> -.BR query_module (2)
> +.BR delete_module (2)
> --
> 1.7.0.4

First, thanks for the patch. I didn't take it as given for a couple of
reasons. First was that I independently also did some review of the
man page and had made some changes to it. Also, man-pages tends to
maintain information about historical behavior, so I wouldn't want to
just drop the old text. Instead I relegated it to NOTES. In addition,
I did also take some pieces from your patch, and since the page
init_modules(2) has by now undergone a fairly significant rewrite,
I'll just insert the whole page below. Could you check it over? And,
Rusty, if you are listening, I'd be happy also to have your review.

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
.TH INIT_MODULE 2 2012-10-09 "Linux" "Linux Programmer's Manual"
.SH NAME
init_module \- load a kernel module
.SH SYNOPSIS
.nf
.BI "int init_module(void *" module_image ", unsigned long " len ,
.BI "                const char *" param_values );
.fi

.IR Note :
There is no glibc wrapper for this system call; see NOTES.
.SH DESCRIPTION
.BR init_module ()
loads an ELF image into kernel space,
performs any necessary symbol relocations,
initializes module parameters to values provided by the caller,
and then runs the module's
.I init
function.
This system call requires privilege.

The
.I module_image
argument points to a buffer containing the binary image
to be loaded;
.I len
specifies the size of that buffer.
The module image should be a valid ELF image, built for the running kernel.

The
.I param_values
argument is a string containing space-delimited specifications of the
values for module parameters.
The kernel parses this string and initializes the specified
parameters
Each of the parameter specifications has the form:

.RI "        " name [ =value [ ,value ...]]

The parameter name is one of those defined within the module using
.IR module_param ()
(see the Linux kernel source file
.IR include/linux/moduleparam.h ).
The parameter value is optional in the case of
.I bool
and
.I invbool
parameters.
Values for array parameters are specified as a comma-separated list.
.SH "RETURN VALUE"
On success, zero is returned.
On error, \-1 is returned and
.I errno
is set appropriately.
.SH ERRORS
.TP
.B EBUSY
The module's initialization routine failed.
.TP
.B EEXIST
A module with this name is already loaded.
.TP
.B EFAULT
An address argument referred to an location that
is outside the process's accessible address space.
.TP
.BR EINVAL " (Linux 2.6 onward)"
.I param_values
is invalid, or some part of the ELF image in
.IR module_image
contains inconsistencies.
.TP
.BR EINVAL " (Linux 2.4 and earlier)"
Some
.I image
slot is filled in incorrectly,
.I image\->name
does not correspond to the original module name, some
.I image\->deps
entry does not correspond to a loaded module,
or some other similar inconsistency.
.TP
.B ENOEXEC
The ELF image in
.I module_image
is too small or has corrupted segments.
.TP
.B EPERM
The caller was not privileged
(did not have the
.B CAP_SYS_MODULE
capability),
or module loading is disabled
(see
.IR /proc/sys/kernel/modules_disabled
in
.BR proc (5)).
.SH "CONFORMING TO"
.BR init_module ()
is Linux-specific.
.SH NOTES
Glibc does not provide a wrapper for this system call; call it using
.BR syscall (2).

Information about currently loaded modules can be found in
.IR /proc/modules
and in the file trees under the per-module subdirectories under
.IR /sys/module .

See the Linux kernel source file
.I include/linux/module.h
for some useful background information.
.SS Linux 2.4 and earlier
.PP
In Linux 2.4 and earlier, this system call was rather different:

.B "    #include <linux/module.h>"

.BI "    int init_module(const char *" name ", struct module *" image );

This version of the system call
loads the relocated module image pointed to by
.I image
into kernel space and runs the module's
.I init
function.
The caller is responsible for providing the relocated image (since
Linux 2.6, the
.BR init_module ()
system call does the relocation).
.PP
The module image begins with a module structure and is followed by
code and data as appropriate.
The module structure is defined as follows:
.PP
.in +4n
.nf
struct module {
    unsigned long         size_of_struct;
    struct module        *next;
    const char           *name;
    unsigned long         size;
    long                  usecount;
    unsigned long         flags;
    unsigned int          nsyms;
    unsigned int          ndeps;
    struct module_symbol *syms;
    struct module_ref    *deps;
    struct module_ref    *refs;
    int                 (*init)(void);
    void                (*cleanup)(void);
    const struct exception_table_entry *ex_table_start;
    const struct exception_table_entry *ex_table_end;
#ifdef __alpha__
    unsigned long gp;
#endif
};
.fi
.in
.PP
All of the pointer fields, with the exception of
.I next
and
.IR refs ,
are expected to point within the module body and be
initialized as appropriate for kernel space, that is, relocated with
the rest of the module.
.SH "SEE ALSO"
.BR create_module (2),
.BR delete_module (2),
.BR query_module (2),
.BR modprobe (8)



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
