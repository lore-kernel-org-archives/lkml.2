Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2L0PbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 10:31:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab2L0PbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:31:08 -0500
Date: Thu, 27 Dec 2012 16:30:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 1/4] signalfd: add ability to return siginfo in
	a raw format
Message-ID: <20121227153020.GA1864@redhat.com>
References: <1356336807-5517-2-git-send-email-avagin@openvz.org> <20121224165306.GA9553@redhat.com> <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com> <20121225143043.GA1813@redhat.com> <20121225152716.GA3198@redhat.com> <50D9C8E9.6020602@parallels.com> <20121225165803.GA9066@redhat.com> <20121226144751.GA18767@paralelels.com> <20121226163112.GA6593@redhat.com> <20121227143626.GA15154@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121227143626.GA15154@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27, Andrey Wagin wrote:
>
> On Wed, Dec 26, 2012 at 05:31:12PM +0100, Oleg Nesterov wrote:
> >
> > So I think we should not use llseek. But, probably we can rely on pread() ?
> > This way we can avoid the problem above, and this looks even simpler.
>
> Yes. It is a good idea. A new patch is attached to this email. I
> implemented pread for signalfd and fixed all your previous comments.
>
> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
> +				siginfo_t *info, unsigned long ppos)
> +{
> +	struct sigpending *pending;
> +	struct sigqueue *q;
> +	bool group = 0;
> +	loff_t seq, i;
> +	int ret = 0;
> +
> +	if (ppos < SIGNALFD_PRIVATE_OFFSET)
> +		return -EINVAL;
> +
> +	if (ppos >= SIGNALFD_SHARED_OFFSET) {
> +		seq = ppos - SIGNALFD_SHARED_OFFSET;
> +		group = 1;
> +	} else
> +		seq = ppos - SIGNALFD_PRIVATE_OFFSET;
> +
> +	spin_lock_irq(&current->sighand->siglock);
> +
> +	if (group)
> +		pending = &current->signal->shared_pending;
> +	else
> +		pending = &current->pending;

Oh, this looks overcomplicated. Why do you need "bool group" ? Just do

	if (ppos > SHARED) {
		seq = ppos - SHARED;
		pending = &current->signal->shared_pending;
	} else if (ppos > PRIVATE) {
		seq = ppos - PRIVATE;
		pending = &current->pending;
	} else {
		return -EINVAL;
	}

	spin_lock_irq(&current->sighand->siglock);
	...

note also I made the PRIVATE/SHARED checks more symmetric, but this is minor.

In fact I think "loff_t i" is not needed as well. You can check --seq == 0
instead in the loop below, but this is up to you.

> @@ -230,7 +274,11 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
>
>  	siginfo = (struct signalfd_siginfo __user *) buf;
>  	do {
> -		ret = signalfd_dequeue(ctx, &info, nonblock);
> +		if (*ppos == 0)
> +			ret = signalfd_dequeue(ctx, &info, nonblock);
> +		else
> +			ret = signalfd_peek(ctx, &info, *ppos);

I think it would be better to pass ppos, not *ppos, because ...

> +		if (*ppos)
> +			(*ppos)++;

in this case we can update *ppos in signalfd_peek() and simplify the
code a bit.

Compared to the previous version it is "safe" to change *ppos even if
copy_to_user() fails, *ppos will be "lost" anyway after we return.

> @@ -321,6 +372,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>  		}
>
>  		file->f_flags |= flags & SFD_RAW;
> +		file->f_mode |= FMODE_PREAD;
>
>  		fd_install(ufd, file);

Hmm. Looks like it is based on other patches I didnt see...

But I don't understand how FMODE_PREAD connects to this patch, we need
this flag set even for regular sys_read() ???

> +#define SIGNALFD_SHARED_OFFSET (1LL << 62)

OK... this assumes we are not going to add more SIGNAL_*_OFFSET's, and
probably this is true...

Oleg.

