Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1HYOUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:20:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1HYOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:20:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Todd Poynor <toddpoynor@google.com>
Cc: fuse-devel@lists.sourceforge.net,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fuse: Freeze client on suspend when request sent to userspace
References: <1314230364-776-1-git-send-email-toddpoynor@google.com>
Date: Thu, 25 Aug 2011 16:20:07 +0200
In-Reply-To: <1314230364-776-1-git-send-email-toddpoynor@google.com> (Todd
	Poynor's message of "Wed, 24 Aug 2011 16:59:24 -0700")
Message-ID: <87hb55fu94.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Poynor <toddpoynor@google.com> writes:

> Suspend attempts can abort when the FUSE daemon is already frozen
> and a client is waiting uninterruptibly for a response, causing
> freezing of tasks to fail.
>
> Use the freeze-friendly wait API, but disregard other signals.
>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> ---
> Have seen reports in which repeated suspend attempts were aborted
> due to a task waiting uninterruptibly in this function, but
> have only reproduced this artificially, by causing the daemon to
> sleep.  Only modified the normal request path, not request aborts
> and such, under the assumption that these should be rare and
> should make progress upon resume.  Certain apps that read or
> write a lot of data on the filesystem may apparently run into
> this case rather frequently.


Yes, this is a well known problem with no (known) trivial solutions.

Problem with the patch is, it's going to solve only a subset of the
suspend aborts.  It will allow any operation sent to userspace to
freeze, which is fine.  But imagine that such a request is holding a VFS
lock (e.g. write(2) is hoding i_mutex) and another operation is waiting
on that lock.  That one still won't be freezable and will prevent
suspend to proceed.

I'm not sure it's really worth fixing only a subset of the problematic
cases.  We should definitely be thinking about solving it properly, in
all cases.

Thanks,
Miklos

>
>  fs/fuse/dev.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 168a80f..bded2e5 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -19,6 +19,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/swap.h>
>  #include <linux/splice.h>
> +#include <linux/freezer.h>
>  
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
> @@ -383,7 +384,10 @@ __acquires(fc->lock)
>  	 * Wait it out.
>  	 */
>  	spin_unlock(&fc->lock);
> -	wait_event(req->waitq, req->state == FUSE_REQ_FINISHED);
> +
> +	while (req->state != FUSE_REQ_FINISHED)
> +		wait_event_freezable(req->waitq,
> +				     req->state == FUSE_REQ_FINISHED);
>  	spin_lock(&fc->lock);
>  
>  	if (!req->aborted)
