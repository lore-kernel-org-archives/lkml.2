Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102Ab2JLSup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:50:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49088 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2JLSun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:50:43 -0400
Date: Fri, 12 Oct 2012 11:50:37 -0700
From: Kees Cook <keescook@chromium.org>
To: halfdog <me@halfdog.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] binfmt_script: do not leave interp on stack
Message-ID: <20121012185037.GJ24964@outflux.net>
References: <20121012023240.GA24232@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012023240.GA24232@www.outflux.net>
Organization: Chrome OS
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 07:32:40PM -0700, Kees Cook wrote:
> +	/*
> +	 * Since bprm is already modified, we cannot continue if the the
> +	 * handlers for starting the new interpreter have failed.
> +	 * Make sure that we do not return -ENOEXEC, as that would
> +	 * allow searching for handlers to continue.
> +	 */
> +	if (retval == -ENOEXEC)
> +		retval = -EINVAL;

After looking at this some more, I wonder if this should be -ELOOP
instead? Or maybe that should happen if/when the recursion depth problem is
fixed?

This is much more obvious, instead of "Invalid argument":
$ ./dotest.sh 
file-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfile-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA: bad interpreter: Too many levels of symbolic links


More importantly, I also wonder if interp handling to just be
changed to be an allocation that needs to be cleaned up, as done with
argv? Right now interp just points to the filename argument handed to
do_execve. Especially since it looks like binfmt_misc is vulnerable
to this as well, since it runs the risk of getting -ENOEXEC from
search_binary_handler, leaving bprm->interp pointing into the stack,
only to get it recalled after module loading attempts:

static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
{
...
        char iname[BINPRM_BUF_SIZE];
...
        bprm->interp = iname;   /* for binfmt_script */
...
        retval = search_binary_handler (bprm, regs);
        if (retval < 0)
                goto _error;
...
_ret:
        return retval;
_error:
        if (fd_binary > 0)
                sys_close(fd_binary);
        bprm->interp_flags = 0;
        bprm->interp_data = 0;
        goto _ret;
}

:(

-Kees

-- 
Kees Cook
Chrome OS Security
