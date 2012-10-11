Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2JKDT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:19:26 -0400
Received: from ozlabs.org ([203.10.76.45]:54031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab2JKDTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:19:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-man <linux-man@vger.kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Jon Masters" <jonathan@jonmasters.org>
Subject: Re: [Request for review] Revised delete_module(2) manual page
In-Reply-To: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
References: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 11 Oct 2012 13:32:59 +1030
Message-ID: <87txu17lss.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hello Kees, Rusty,
>
> The current delete_module(2) page is severely out of date (basically,
> its content corresponds to 2.4 days, and was even pretty thin in
> covering that). So, I took a shot at revising the page to Linux 2.6+
> reality. Would it be possible that you could review it?

OK.  Main suggestion is that I discussed with Lucas removing the
!O_NONBLOCK case.  It's not supported by modprobe -r, and almost
unheard-of for rmmod (it's --wait).

In practice, people want the unload-or-fail semantics, or the
force-unload semantics.

> Otherwise, by default,
> .BR delete_module ()
> marks a module so that no new references are permitted.
> If the module's reference count
> (i.e., the number of processes currently using the module) is nonzero,
> it then places the caller in an uninterruptible sleep
> state until all reference count is zero,
> at which point the call unblocks.
> When the reference count reaches zero, the module is unloaded.

So this should be inverted:

        Otherwise (assuming O_NONBLOCK, see flags below), if the
        module's reference count (i.e., the number of processes
        currently using the module) is nonzero, the call fails.

> The
> .IR flags
> argument can be used to modify the behavior of the system call.

It is usually set to O_NONBLOCK, which may be required in future kernel
versions (see NOTES).

> The following values can be ORed in this argument:
> .TP
> .B O_TRUNC
> .\"  	KMOD_REMOVE_FORCE in kmod library
> Force unloading of the module, even if the following conditions are true:
> .RS
> .IP * 3
> The module has no
> .I exit
> function.
> By default, attempting to unload a module that has no
> .I exit
> function fails.
> .IP *
> The reference count for (i.e., the number of processes currently using)
> this module is nonzero.
...
> .IP
> Using this flag taints the kernel (TAINT_FORCED_RMMOD).
> .IP
> .IR "Using this flag is dangerous!"
> If the kernel was not built with
> .BR CONFIG_MODULE_FORCE_UNLOAD ,
> this flag is silently ignored.

NOTES:

If O_NONBLOCK is not set, then the kernel may enter uninterruptible
sleep until the module reference count reaches zero.  This is not
generally desirable, so this flag may be compulsory in future kernel
configurations.

Cheers,
Rusty.
