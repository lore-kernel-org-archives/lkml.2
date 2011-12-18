Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1LRSWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:22:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1LRSWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:22:31 -0500
Date: Sun, 18 Dec 2011 19:17:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Roland McGrath <roland@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] ptrace: add ability to attach a file descriptor to
	another task
Message-ID: <20111218181702.GA22240@redhat.com>
References: <1324032383-791758-1-git-send-email-avagin@openvz.org> <1324032383-791758-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324032383-791758-3-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Andrew Vagin wrote:
>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Nice changelog ;)

I agree with Tejun, this doesn't look like the good idea to me...



As for the patch itself,

> @@ -826,6 +827,32 @@ int ptrace_request(struct task_struct *child, long request,
>  		break;
>  	}
>  #endif
> +	case PTRACE_DUPFD:
> +	{
> +		struct file *file = fget_raw(data);
> +		ret = -EBADF;
> +
> +		if (!file)
> +			break;
> +
> +		task_lock(child);
> +		if (!child->files)
> +			goto out_getfd;
> +
> +		ret = alloc_task_fd(child, 0, 0);

alloc_fdtable() does kmalloc(GFP_KERNEL)/vmalloc(), not good under
spin_lock().

> +		if (ret < 0) {
> +			fput(file);

We can't do this under task_lock() too.

A tracer's sub-thread (or any CLONE_FILES task) can close this file,
it is possible that we have the last reference.


Probably, instead of the new *_task_* helpers, you can add
alloc_file_fd/fd_files_install which take the result of
get_files_struct() as the additional argument. This way you can
avoid task_lock().

Oleg.

