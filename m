Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab2L1OcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 09:32:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab2L1OcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 09:32:17 -0500
Date: Fri, 28 Dec 2012 15:32:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
	dequeuing signals (v3)
Message-ID: <20121228143200.GB24229@redhat.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org> <1356690181-1796-4-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356690181-1796-4-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28, Andrey Vagin wrote:
>
> pread(fd, buf, size, pos) with non-zero pos returns siginfo-s
> without dequeuing signals.
>
> A sequence number and a queue are encoded in pos.
>
> pos = seq + SFD_*_OFFSET
>
> seq is a sequence number of a signal in a queue.
>
> SFD_PER_THREAD_QUEUE_OFFSET - read signals from a per-thread queue.
> SFD_SHARED_QUEUE_OFFSET - read signals from a shared (process wide) queue.
>
> This functionality is required for checkpointing pending signals.
>
> v2: llseek() can't be used here, because peek_offset/f_pos/whatever
> has to be shared with all processes which have this file opened.
>
> Suppose that the task forks after sys_signalfd(). Now if parent or child
> do llseek this affects them both. This is insane because signalfd is
> "strange" to say at least, fork/dup/etc inherits signalfd_ctx but not
> the" source" of the data. // Oleg Nesterov

I think we should cc Linus.

This patch adds the hack and it makes signalfd even more strange.

Yes, this hack was suggested by me because I can't suggest something
better. But if Linus dislikes this user-visible API it would be better
to get his nack right now.

> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
> +				siginfo_t *info, loff_t *ppos)
> +{
> +	struct sigpending *pending;
> +	struct sigqueue *q;
> +	loff_t seq;
> +	int ret = 0;
> +
> +	spin_lock_irq(&current->sighand->siglock);
> +
> +	if (*ppos >= SFD_SHARED_QUEUE_OFFSET) {
> +		pending = &current->signal->shared_pending;
> +		seq = *ppos - SFD_SHARED_QUEUE_OFFSET;
> +	} else {
> +		pending = &current->pending;
> +		seq = *ppos - SFD_PER_THREAD_QUEUE_OFFSET;
> +	}

You can do this outside of spin_lock_irq().

And I think it would be better to check SFD_PRIVATE_QUEUE_OFFSET too
although this is not strictly necessary. Otherwise this code assumes
that sys_pread() cheks pos >= 0 and SFD_PRIVATE_QUEUE_OFFSET == 1.

> +	list_for_each_entry(q, &pending->list, list) {
> +		if (sigismember(&ctx->sigmask, q->info.si_signo))
> +			continue;
> +
> +		if (seq-- == 0) {
> +			copy_siginfo(info, &q->info);
> +			ret = info->si_signo;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irq(&current->sighand->siglock);
> +
> +	if (ret)
> +		(*ppos)++;

We can change it unconditionally but I won't argue.

> @@ -338,6 +379,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>  		}
>
>  		file->f_flags |= flags & SFD_RAW;
> +		file->f_mode |= FMODE_PREAD;

Again, this is not needed or the code was broken by the previous patch.

Given that 2/3 passes O_RDWR to anon_inode_getfile() I think FMODE_PREAD
should be already set. Note OPEN_FMODE(flags) in anon_inode_getfile().

Oleg.

