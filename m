Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2BYQPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 11:15:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab2BYQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 11:15:46 -0500
Date: Sat, 25 Feb 2012 17:08:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] signalfd/epoll fixes
Message-ID: <20120225160845.GA13324@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com> <20120224190651.GA22287@redhat.com> <CA+55aFz6EoiKjzisFmU0j4aezXsPinDyfv3DdKeeKQibkaO6DQ@mail.gmail.com> <CA+55aFyPCHiESkfGMLOA7vNYz46FOnTrvQFJhwCFz9wAehP=7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyPCHiESkfGMLOA7vNYz46FOnTrvQFJhwCFz9wAehP=7w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Linus Torvalds wrote:
>
> On Fri, Feb 24, 2012 at 12:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'm *really* conflicted, because I have this really strong feeling
> > that it's just papering over a symptom, and we damn well shouldn't be
> > doing that.

Heh. This is even documented in the changelog.

> I really think that what we really should do is allow
> > "poll()" to have a "poll_remove" callback (so each "add_poll_wait()"
> > will have a callback when it gets remove).

Yes. I also thought about this. In fact I think this probably makes
sense even ignoring epoll problems. Although I was thinking about
file_operations::poll_v2(file, poll_table, poll_table_entry, mode)
which could could replace the old ->poll() eventually. But perhaps
the explicit poll_rm() is better.

However, speaking about epoll/sigfd, imho this hides the problem too.

> +static void signalfd_poll_rm(struct file *file, wait_queue_head_t *p)
> +{
> +	struct sighand_struct *sighand;
> +
> +	sighand = container_of(p, struct sighand_struct, signalfd_wqh);
> +	__cleanup_sighand(sighand);
> +}
> +
>  static unsigned int signalfd_poll(struct file *file, poll_table *wait)
>  {
>  	struct signalfd_ctx *ctx = file->private_data;
>  	unsigned int events = 0;
>
> -	poll_wait(file, &current->sighand->signalfd_wqh, wait);
> +	if (poll_wait(file, &current->sighand->signalfd_wqh, wait))
> +		atomic_inc(&current->sighand->count);

Yes, this fixes use-after-free. But suppose the the application does:

	sigfd = signalfd(...);
	epoll_ctl(epollfd, EPOLL_CTL_ADD, sigfd);
	execve();

de_thread() unshares ->sighand because of atomic_inc() above and
epollfd no longer works after exec, and the application can't know
this. (yes, currently we have the same problem with CLONE_SIGHAND'ed
apps, but still).

We can turn ->signalfd_wqh into the pointer to the refcountable
memory, or add another counter, but this is not nice.

And in any case. If the task exits, to me it looks simply pointless
to keep its ->sighand until __fput(). This only makes poll_rm() or
whatever safe, it can't report a signal. OK, OK, I am not arguing,
POLLFREE is equally ugly or even worse.

I _think_ that the right fix should move wait_queue_head_t from
sighand_struct to signalfd_ctx (file->private_data) somehow...

Oleg.

