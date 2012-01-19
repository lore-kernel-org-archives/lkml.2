Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2ASAqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:46:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2ASAp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:45:59 -0500
Date: Wed, 18 Jan 2012 16:45:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: arjan@linux.intel.com, richard@nod.at, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kmod: Avoid deadlock by recursive kmod call.
Message-Id: <20120118164558.a10d7821.akpm@linux-foundation.org>
In-Reply-To: <201201062139.JFC73472.SMQFOFOFHLVOtJ@I-love.SAKURA.ne.jp>
References: <201112270701.pBR713wO005588@www262.sakura.ne.jp>
	<201201040743.q047h9OD055670@www262.sakura.ne.jp>
	<201201042208.JHG52695.OLStHFQOFFMVJO@I-love.SAKURA.ne.jp>
	<201201062139.JFC73472.SMQFOFOFHLVOtJ@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 21:39:17 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Tetsuo Handa wrote:
> > An example operation for triggering this deadlock:
> > 
> >   # : > /tmp/dummy
> >   # chmod 755 /tmp/dummy
> >   # echo /tmp/dummy > /proc/sys/kernel/hotplug
> >   # modprobe whatever
> 
> I wrote two patches. Please review.
> 
> ----- Patch A start -----
> [PATCH v3] kmod: Avoid deadlock by recursive kmod call.
> 
> The system deadlocks when call_usermodehelper(UMH_WAIT_EXEC) request triggered
> call_usermodehelper(UMH_WAIT_PROC) request.
> 
> This is because "khelper thread is waiting at wait_for_completion() in
> do_fork() since the worker thread was created with CLONE_VFORK flag" and
> "the worker thread cannot call complete() because do_execve() is blocked at
> UMH_WAIT_PROC request (e.g. request_module() from search_binary_handler())" and
> "the khelper thread cannot start processing UMH_WAIT_PROC request because
> the khelper thread is waiting at wait_for_completion() in do_fork()".
> 
> In order to avoid deadlock, do not try to call wait_for_completion() in
> call_usermodehelper_exec() if the worker thread was created by khelper thread
> with CLONE_VFORK flag.

I suppose we should fix this, although it's obscure.

The changelog doesn't tell people how the bug might occur, which is
bad.  I suggest adding this text to it:

: This bug was observed when using a corrupted /sbin/hotplug binary.  The
: corrupted binary caused a call to request_module("binfmt-0000"). 
: search_binary_handler() uses UMH_WAIT_EXEC.
: 
: An example operation for triggering this deadlock:
: 
:    # : > /tmp/dummy
:    # chmod 755 /tmp/dummy
:    # echo /tmp/dummy > /proc/sys/kernel/hotplug
:    # modprobe whatever

which might be inaccurate/inadequate.  I didn't try very hard.  Please
provide a complete description and analysis of the bug.

I prefer patch A - all that poking around at stack slots is hacky.

> --- linux-3.2.orig/fs/exec.c
> +++ linux-3.2/fs/exec.c
> @@ -1406,6 +1406,7 @@ int search_binary_handler(struct linux_b
>  					fput(bprm->file);
>  				bprm->file = NULL;
>  				current->did_exec = 1;
> +				current->kmod_thread = 0;
>  				proc_exec_connector(current);
>  				return retval;
>  			}

Special-casing this assignment down in this particular client of kmod
looks bad.  We need to find somewhere else to do this.  Perferably
within the kmod code itself, or possibly over in exec.c or fork.c.

