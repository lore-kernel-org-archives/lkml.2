Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2LZQcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 11:32:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab2LZQct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 11:32:49 -0500
Date: Wed, 26 Dec 2012 17:31:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Andrey Wagin <avagin@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 1/4] signalfd: add ability to return siginfo in
	a raw format
Message-ID: <20121226163112.GA6593@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-2-git-send-email-avagin@openvz.org> <20121224165306.GA9553@redhat.com> <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com> <20121225143043.GA1813@redhat.com> <20121225152716.GA3198@redhat.com> <50D9C8E9.6020602@parallels.com> <20121225165803.GA9066@redhat.com> <20121226144751.GA18767@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121226144751.GA18767@paralelels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26, Andrew Vagin wrote:
>
> On Tue, Dec 25, 2012 at 05:58:03PM +0100, Oleg Nesterov wrote:
> > On 12/25, Pavel Emelyanov wrote:
> > >
> > > On 12/25/2012 07:27 PM, Oleg Nesterov wrote:
> > > >
> > > > I guess that probably you actually need DUMP, not DEQUEUE. but the
> > > > latter is not trivial. However, perhaps we can do this assuming that
> > > > all other threads are sleeping and nobody can do dequeue_signal().
> > > > Say, we can play with ppos/llseek. If *ppos is not zero,
> > > > signalfd_dequeue() could dump the nth entry from list or return 0.
> > >
> > > This would be perfect, but isn't it better to preserve the pos
> > > semantics -- we do know size of entry we're about to copy, we can
> > > treat pos as offset in bytes, not in elements.
> >
> > nr-of-records looks better (more flexible) than nr-of-bytes to me. And
> > perhaps we can also encode private-or-shared into ppos. But I will not
> > argue in any case.
>
> Oleg and Pavel, could you look at these two patches. I implemented in them,
> what you described here.

cosmetics nits below, feel free to ignore...

Damn. But after I wrote this email I realized that llseek() probably can't
work. Because peek_offset/f_pos/whatever has to be shared with all processes
which have this file opened.

Suppose that the task forks after sys_signalfd(). Now if parent or child
do llseek this affects them both. This is insane because signalfd is
"strange" to say at least, fork/dup/etc inherits signalfd_ctx but not the
"source" of the data.

So I think we should not use llseek. But, probably we can rely on pread() ?
This way we can avoid the problem above, and this looks even simpler.

> +int peek_signal(struct task_struct *tsk, sigset_t *mask,
> +			siginfo_t *info, int offset, bool group)
> +{
> +	struct sigpending *pending;
> +	struct sigqueue *q;
> +	int i = 0, ret = 0;
> +
> +	if (group)
> +		pending = &tsk->signal->shared_pending;
> +	else
> +		pending = &tsk->pending;
> +
> +	list_for_each_entry(q, &pending->list, list) {
> +		if (sigismember(mask, q->info.si_signo))
> +			continue;
> +
> +		if (i == offset) {
> +			copy_siginfo(info, &q->info);
> +			ret = info->si_signo;
> +			break;
> +		}
> +
> +		i++;
> +	}
> +
> +	return ret;
> +}

This helper is trivial. Any reason it should live in signal.c ? Just put
this code into signalfd_peek(). Besides, this helps if !CONFIG_SIGNALFD.

> If lseek sets a positive position, signals are taken from a shared queue.
> If lseek sets a negative position, signals are taken from a private queue.

Personally, I'd prefer, say,

	#define SIGNALFD_SHARED_OFFSET		big-enough-number

if offset >= SIGNALFD_SHARED_OFFSET we use ->shared_pending.
Again, I won't insist. And if we add SIGNALFD_SHARED_OFFSET
then we should probably define SIGNALFD_PRIVATE_OFFSET as
well for consistency.

>  struct signalfd_ctx {
>  	sigset_t sigmask;
> +	loff_t peek_offset;

Why we can't simply use ->f_pos ?

> @@ -242,6 +259,13 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
>  		if (ret < 0)
>  			break;
>
> +		if (ctx->peek_offset) {
> +			if (ctx->peek_offset > 0)
> +				ctx->peek_offset++;
> +			else
> +				ctx->peek_offset--;

...

> +loff_t signalfd_llseek(struct file *f, loff_t offset, int whence)
> +{
> +	struct signalfd_ctx *ctx = f->private_data;
> +
> +	switch (whence) {
> +	case SEEK_SET:
> +		ctx->peek_offset = offset;
> +		break;
> +	case SEEK_CUR:
> +		ctx->peek_offset += offset;

probably you need some locking (say, f_lock) to ensure that these
peek_offset modifications can't race with each other. If you rely
on f_pos you only need to ensure thar signalfd_llseek() can't race
with itself.

Oleg.

