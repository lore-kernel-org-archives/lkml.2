Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2LYOdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 09:33:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2LYOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:33:42 -0500
Date: Tue, 25 Dec 2012 15:30:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/4] signalfd: add ability to return siginfo in a raw
	format
Message-ID: <20121225143043.GA1813@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-2-git-send-email-avagin@openvz.org> <20121224165306.GA9553@redhat.com> <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25, Andrey Wagin wrote:
>
> 2012/12/24 Oleg Nesterov <oleg@redhat.com>:
> > On 12/24, Andrey Vagin wrote:
> >>
> >> signalfd should be called with the flag SFD_RAW for that.
> >>
> >> signalfd_siginfo is not full for siginfo with a negative si_code.
> >> copy_siginfo_to_user() is copied a full siginfo to user-space, if
> >> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
> >> expanded, because it has not compatiable format with siginfo_t.
> >
> > Yes, but otoh perhaps we should change (fix) signalfd_siginfo/copyinfo,
> > its "default" case makes no sense if si_code < 0.
>
> Its "default" case makes sense if a signal is sent by sigqueue(pid,sig,ptr).

But it doesn't really work, that is what I was trying to say. And that
is why you want copy_siginfo_to_user ;)

> I'm afraid, we can change (fix) signalfd_copyinfo, because for
> negative si_code a whole siginfo should be copied to userspace.

Exactly, this is what I meant. We simply do not know what this info
contains if it was sent by sigqueueinfo().

> Currently if si_code is unknown, signalfd_copyinfo sets only ssi_ptr
> and that can't be changed due to backward compatibility. ssi_ptr is in
> the midle of signalfd_siginfo and a sizeof(signalfd_siginfo) is equal
> to sizeof(siginfo_t). We don't have space to copied siginfo into
> signalfd_siginfo.

Yes, I understand.

> If we want to have another format with SFD_RAW, I prefer to have
> siginfo_t instead of signalfd_siginfo. Because if si_code is negative,
> it should be siginfo_t in any case. A minor thing is that it can be
> sent back without modifications.

"without modifications" is not actually true, your patch changes the
meaning of ->si_code. Yes, I understand why do you do this, and I am
not going to argue. But it looks a bit sad that, say, sigtimedwait()
and read(SFD_RAW) will return the "same" siginfo_t except the subtle
difference in ->si_code.

What I am trying to say, is that SFD_RAW should be named
SFD_signalfd_siginfo_SUCKS_BUT_WE_CANT_CHANGE_IT_FOR_COMPATIBILITY ;) So
you need another format. And if we add another format we should think
twice. For example, if it is _RAW, why we can't simply do memcpy()
instead of copy_siginfo_to_user() ? Not that I really suggest this.

And if we change the meaning of ->si_code then, perhaps, we should
think what else we should change to avoid SFD_RAW_RAW in future.
Just for example, we can set MSB in ->si_signo if the signal was
private.

Oleg.

