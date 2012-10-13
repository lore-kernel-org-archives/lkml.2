Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2JMFuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 01:50:52 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:41333 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2JMFuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 01:50:51 -0400
Message-ID: <5079012A.90407@halfdog.net>
Date: Sat, 13 Oct 2012 05:50:34 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:19.0) Gecko/19.0 Firefox/19.0 SeaMonkey/2.16a1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] binfmt_script: do not leave interp on stack
References: <20121012023240.GA24232@www.outflux.net> <20121012185037.GJ24964@outflux.net>
In-Reply-To: <20121012185037.GJ24964@outflux.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> On Thu, Oct 11, 2012 at 07:32:40PM -0700, Kees Cook wrote:
>> +	/*
>> +	 * Since bprm is already modified, we cannot continue if the the
>> +	 * handlers for starting the new interpreter have failed.
>> +	 * Make sure that we do not return -ENOEXEC, as that would
>> +	 * allow searching for handlers to continue.
>> +	 */
>> +	if (retval == -ENOEXEC)
>> +		retval = -EINVAL;
> 
> After looking at this some more, I wonder if this should be -ELOOP
> instead? Or maybe that should happen if/when the recursion depth problem is
> fixed?
> 
> This is much more obvious, instead of "Invalid argument":
> $ ./dotest.sh 
> file-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfile-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA: bad interpreter: Too many levels of symbolic links

In my opinion, a different, more specific error code is nice, but when
not self-explanatory, it would need to be documented to avoid confusion.
I do not know, what would be the most accepted way to change syscall
return value semantics, if to change semantics or add new ones. From
man-pages, many have already some meaning and only some could be
re-interpreted in that way:

E2BIG: The total number of bytes in the environment (envp) and argument
list (argv) is too large. (not perfect, because usually only associated
with mem/file size issues)
ELOOP: Too many  symbolic links were encountered in resolving filename
or the name of a script or ELF interpreter. (currently no distinction
from real symlink problems)
EMFILE: The process has the maximum number of files open. (too generic?)


This one has already a meaning, but only for ELF not script (but since
script might also call ELF in the end, user cannot know):

EINVAL: An ELF executable had more than  one  PT_INTERP  segment (i.e.,
tried to name more than one interpreter).

Those are not yet unused, but I think it is a bad idea to add them,
since some programs might be confused by unexpected error code:

ELIBMAX: Attempting to link in too many shared libraries (not a really
good match)
EMLINK: Too many links (somehow generic, do not know if usually used
another way).


It is strange: from current description, this one suits best, the only
reason why we want to get rid of it is, that it triggers module
reloading and another round of execution.

ENOEXEC: An  executable is not in a recognized format, is for the wrong
 architecture, or has some other format error that means it  cannot be
executed.

Perhaps it would be better to continue returning ENOEXEC from syscall in
that case but change the logic for module-reloading (use some other
return value meaning in binfmt handlers in kernel internally)?

> More importantly, I also wonder if interp handling to just be
> changed to be an allocation that needs to be cleaned up, as done with
> argv?

You mean like an allocation on the stack of the new process' growing
stack? This would be cleaned automatically if something goes wrong
during exec.

> Right now interp just points to the filename argument handed to
> do_execve. Especially since it looks like binfmt_misc is vulnerable
> to this as well, since it runs the risk of getting -ENOEXEC from
> search_binary_handler, leaving bprm->interp pointing into the stack,
> only to get it recalled after module loading attempts:
> 
> static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
> {
> ...
>         char iname[BINPRM_BUF_SIZE];
> ...
>         bprm->interp = iname;   /* for binfmt_script */
> ...
>         retval = search_binary_handler (bprm, regs);
>         if (retval < 0)
>                 goto _error;
> ...
> _ret:
>         return retval;
> _error:
>         if (fd_binary > 0)
>                 sys_close(fd_binary);
>         bprm->interp_flags = 0;
>         bprm->interp_data = 0;
>         goto _ret;
> }

Correct. I hope the patch should be a formality, as soon as discussion
on this one is done.

-- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
