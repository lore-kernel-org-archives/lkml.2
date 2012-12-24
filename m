Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2LXRF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 12:05:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2LXRFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 12:05:53 -0500
Date: Mon, 24 Dec 2012 18:05:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 3/4] signalfd: add ability to choose a private or
	shared queue
Message-ID: <20121224170540.GB9553@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-4-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356336807-5517-4-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Andrey Vagin wrote:
>
>  static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
> -				int nonblock)
> +				int nonblock, int queue)
>  {
>  	ssize_t ret;
>  	DECLARE_WAITQUEUE(wait, current);
>
>  	spin_lock_irq(&current->sighand->siglock);
> -	ret = dequeue_signal(current, &ctx->sigmask, info);
> +	ret = do_dequeue_signal(current, &ctx->sigmask, info, queue);

Hmm. queue != 0 && !nonblock ?

And in this case you should also update signalfd_poll().

> +	if (file->f_flags & SFD_GROUP)
> +		queue++;
> +
> +	if (file->f_flags & SFD_PRIVATE)
> +		queue--;

To be honest, personally I think this looks ugly. If you add an
argumemt to dequeue_signal() it would be better to use bitmask.
But this is minor.


Well. Perhaps we can avoid all these complications? IIUC, all you
need is to know if the dequeued signal is private or shared. Since
you add SFD_RAW anyway perhaps we can report this fact instead?
This doesn't need any changes in signal.c, signalfd_dequeue() can
easily know which queue dequeue_signal() will use.

Oleg.

