Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab2JKDT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:19:29 -0400
Received: from ozlabs.org ([203.10.76.45]:53837 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab2JKDTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:19:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-man <linux-man@vger.kernel.org>
Subject: Re: [PATCH] init_module: update to modern interfaces
In-Reply-To: <CAKgNAkheF8=ssrE=_JP-ApDP5zXeHSYVG+0x6Wfd6U28TcPSHQ@mail.gmail.com>
References: <20120920232737.GA2953@www.outflux.net> <CAKgNAkheF8=ssrE=_JP-ApDP5zXeHSYVG+0x6Wfd6U28TcPSHQ@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 11 Oct 2012 13:20:08 +1030
Message-ID: <87wqyx7me7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> [CC widened, so that some more review might come in. Rusty?]

Sure.

Looks good. but:

> .B EBUSY
> The module's initialization routine failed.

Possibly.  You should mention that the individual module's
initialization routine can return other errors as appropriate.

> .BR EINVAL " (Linux 2.4 and earlier)"
> Some
> .I image
> slot is filled in incorrectly,
> .I image\->name
> does not correspond to the original module name, some
> .I image\->deps
> entry does not correspond to a loaded module,
> or some other similar inconsistency.
> .TP

Why document this?

> .B ENOEXEC
> The ELF image in
> .I module_image
> is too small or has corrupted segments.

Or is not an ELF image, or wrong arch...

> .TP
> .B EPERM
> The caller was not privileged
> (did not have the
> .B CAP_SYS_MODULE
> capability),
> or module loading is disabled
> (see
> .IR /proc/sys/kernel/modules_disabled
> in
> .BR proc (5)).
> .SH "CONFORMING TO"
> .BR init_module ()
> is Linux-specific.
> .SH NOTES
> Glibc does not provide a wrapper for this system call; call it using
> .BR syscall (2).
>
> Information about currently loaded modules can be found in
> .IR /proc/modules
> and in the file trees under the per-module subdirectories under
> .IR /sys/module .
>
> See the Linux kernel source file
> .I include/linux/module.h
> for some useful background information.
> .SS Linux 2.4 and earlier
> .PP
> In Linux 2.4 and earlier, this system call was rather different:
>
> .B "    #include <linux/module.h>"
>
> .BI "    int init_module(const char *" name ", struct module *" image );
>
> This version of the system call
> loads the relocated module image pointed to by
> .I image
> into kernel space and runs the module's
> .I init
> function.
> The caller is responsible for providing the relocated image (since
> Linux 2.6, the
> .BR init_module ()
> system call does the relocation).
> .PP
> The module image begins with a module structure and is followed by
> code and data as appropriate.
> The module structure is defined as follows:
> .PP
> .in +4n
> .nf
> struct module {
>     unsigned long         size_of_struct;
>     struct module        *next;
>     const char           *name;
>     unsigned long         size;
>     long                  usecount;
>     unsigned long         flags;
>     unsigned int          nsyms;
>     unsigned int          ndeps;
>     struct module_symbol *syms;
>     struct module_ref    *deps;
>     struct module_ref    *refs;
>     int                 (*init)(void);
>     void                (*cleanup)(void);
>     const struct exception_table_entry *ex_table_start;
>     const struct exception_table_entry *ex_table_end;
> #ifdef __alpha__
>     unsigned long gp;
> #endif
> };
> .fi
> .in
> .PP
> All of the pointer fields, with the exception of
> .I next
> and
> .IR refs ,
> are expected to point within the module body and be
> initialized as appropriate for kernel space, that is, relocated with
> the rest of the module.

You might want to note that the 2.4 syscall can be detected by calling
query_module(): 2.6 and above give ENOSYS.

Cheers,
Rusty.
