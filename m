Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2B2UNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab2B2UNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:13:43 -0500
Date: Wed, 29 Feb 2012 21:06:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] epoll: introduce POLLFREE to flush
	->signalfd_wqh before kfree()
Message-ID: <20120229200636.GA15729@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com> <20120224190651.GA22287@redhat.com> <20120224190711.GB22287@redhat.com> <4F4E830E.3040307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E830E.3040307@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29, Andy Lutomirski wrote:
>
> On 02/24/2012 11:07 AM, Oleg Nesterov wrote:
> > This patch adds the special event, POLLFREE, currently only for
> > epoll. It expects that init_poll_funcptr()'ed hook should do the
> > necessary cleanup. Perhaps it should be defined as EPOLLFREE in
> > eventpoll.
>
> I have a bunch of userspace code that uses signalfd via epoll.  Does
> this affect the ABI?

I hope not ;)

> Will epoll_wait ever set POLLFREE?

No.

> Does
> EPOLL_CTL_MOD accept POLLFREE?

Yes, it doesn't check the bits. EPOLL_CTL_MOD accepts any bit.

> IOW, from a userspace point of view, wtf does this do?

I hope this is transparent to the user-space. If the application
does EPOLL_CTL_MOD(POLLFREE) by mistake then ep_poll_callback(POLLFREE)
can trigger the unnecessary wakeup and move the file to ep->rdllist
but this is harmless. The subsequent ->poll() can't return POLLFREE.

Oleg.

