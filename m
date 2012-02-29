Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2B2T5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:57:16 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:47636 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab2B2T5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:57:15 -0500
X-AuditID: 1209190d-b7fbf6d0000008ba-ad-4f4e831a703e
Message-ID: <4F4E830E.3040307@mit.edu>
Date: Wed, 29 Feb 2012 11:57:02 -0800
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] epoll: introduce POLLFREE to flush ->signalfd_wqh
 before kfree()
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com> <20120224190651.GA22287@redhat.com> <20120224190711.GB22287@redhat.com>
In-Reply-To: <20120224190711.GB22287@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsUixCmqrCvV7Odv8KpR3mLO+jVsFg3HLzFb
	nP9+iN1i3/uzbBabnotbnFswg9Hi1uml7BaXd81hs7ix9wWzxdb9rYwWCx/cYLZ41PeW3YHH
	Y33/fRaPnbPusnssX3GQ1ePwg5+sHm8fBnicmPGbxeP9vqtsHp83yXm0v3rEFMAZxWWTkpqT
	WZZapG+XwJXx49gO9oJfXBWn+mezNjC+5Ohi5OSQEDCROPfvJhOELSZx4d56ti5GLg4hgX2M
	Eiuuf2GGcDYwSnxceYEVwnnBJLHq22ywFl4BNYnfU6+wg9gsAqoSW1ctZQGx2QRUJDqWPgCr
	ERWIkNiz9i8zRL2gxMmZT8BqRASUJf7cWwC2gVngHLPEql/drCAJYYE4iVm/JjBCbGtkkug5
	uRqsm1PAQKJl/xawqcwCOhLv+h4wQ9jyEtvfzmGewCg4C8mSWUjKZiEpW8DIvIpRNiW3Sjc3
	MTOnODVZtzg5MS8vtUjXSC83s0QvNaV0EyM41iR5dzC+O6h0iFGAg1GJh5ep0M9fiDWxrLgy
	9xCjJAeTkijv3EagEF9SfkplRmJxRnxRaU5q8SFGCQ5mJRHet1JAOd6UxMqq1KJ8mJQ0B4uS
	OK+q1js/IYH0xJLU7NTUgtQimKwMB4eSBO+EJqBGwaLU9NSKtMycEoQ0EwcnyHAeoOH9IDW8
	xQWJucWZ6RD5U4yKUuK8GSAJAZBERmkeXC8sFb5iFAd6RZi3EKSKB5hG4bpfAQ1mAhocwOkN
	MrgkESEl1cBoxrrdNfO6X1S5SHd/WJ/b/z03md7Hdx133KacyPd9mrt1tol4grRijXJ3Y86j
	yfbKy5WffLjcdmS7y4t0Y3/3KZ/XhnRJ+9xrcPvcKPLF/l9pmM3V9OfH/jzsMAk5sYpL/4Ty
	wl554QU5bMEvq2KKW643/c32fWwWUFI0t0761LSKO3b7OpRYijMSDbWYi4oTATNo1KlgAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 11:07 AM, Oleg Nesterov wrote:
> This patch is intentionally incomplete to simplify the review.
> It ignores ep_unregister_pollwait() which plays with the same wqh.
> See the next change.
> 
> epoll assumes that the EPOLL_CTL_ADD'ed file controls everything
> f_op->poll() needs. In particular it assumes that the wait queue
> can't go away until eventpoll_release(). This is not true in case
> of signalfd, the task which does EPOLL_CTL_ADD uses its ->sighand
> which is not connected to the file.
> 
> This patch adds the special event, POLLFREE, currently only for
> epoll. It expects that init_poll_funcptr()'ed hook should do the
> necessary cleanup. Perhaps it should be defined as EPOLLFREE in
> eventpoll.

> [lots of kernel-internal technical stuff]

I have a bunch of userspace code that uses signalfd via epoll.  Does
this affect the ABI?  Will epoll_wait ever set POLLFREE?  Does
EPOLL_CTL_MOD accept POLLFREE?

IOW, from a userspace point of view, wtf does this do?  I don't want to
end up with another POLLRDHUP-like* special case in my code.

--Andy

* IMO the right fix would have been to make EPOLLET fire POLLIN again
when the read point advances to EOF but before EOF is actually seen when
read() returns zero.  Then POLLRDHUP would be unnecessary and user code
could do its thing in blissful ignorance.  I hope POLLFREE isn't like that.
