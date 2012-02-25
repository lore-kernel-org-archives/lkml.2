Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2BYTAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 14:00:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55436 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab2BYTAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 14:00:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.107.68 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120225160845.GA13324@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com>
 <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com>
 <20120224190651.GA22287@redhat.com> <CA+55aFz6EoiKjzisFmU0j4aezXsPinDyfv3DdKeeKQibkaO6DQ@mail.gmail.com>
 <CA+55aFyPCHiESkfGMLOA7vNYz46FOnTrvQFJhwCFz9wAehP=7w@mail.gmail.com> <20120225160845.GA13324@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Feb 2012 11:00:10 -0800
X-Google-Sender-Auth: husLeg2_jAtSzAODCBP2AxWELOU
Message-ID: <CA+55aFzvMjTsiwL2zNwtxwOPNr5DB9Dn8LNTMM=ciC2VByJeqA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] signalfd/epoll fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 8:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Yes, this fixes use-after-free. But suppose the the application does:
>
>        sigfd = signalfd(...);
>        epoll_ctl(epollfd, EPOLL_CTL_ADD, sigfd);
>        execve();

Well, that can't work anyway. We're adding to the wrong sighand.

Sure, we can force a wakeup for it at execve(), but that's not the old
behavior either, so why would we care about the above case? It's not a
sane thing to do, and it has never worked before either, so why
bother? My patch should make it "work" as well as it ever did.

Quite frankly, if you wanted to make signalfd work sanely with
eventpoll, you'd need to change the semantics entirely, and just say
"signalfd works in the context it was creared in, no other". Those
aren't the semantics we have, though, and there's no point in trying
to make up some *new* semantics for "if you execve() we'll still
follow it"

> And in any case. If the task exits, to me it looks simply pointless
> to keep its ->sighand until __fput(). This only makes poll_rm() or
> whatever safe, it can't report a signal. OK, OK, I am not arguing,
> POLLFREE is equally ugly or even worse.

That's my point. POLLFREE really does look worse, and doesn't really
give any saner behaviors.

> I _think_ that the right fix should move wait_queue_head_t from
> sighand_struct to signalfd_ctx (file->private_data) somehow...

I looked at it - and it requires the same "poll_rm()" callback, and
then instead you have to make allocations in poll() (for the list) and
de-allocate in "poll_rm()".

I do agree that in many ways it would be the "right" thing to do, but
it does require the same infrastructure, and the advantage is dubious
for this case. The main advantage is that we can extend the signalfd +
epoll interaction in new directions (like the "across execve" or other
cases), but I'd argue that we don't *want* to do that.

So your POLLFREE patches are merged, and I think they work. The reason
I like the poll_rm() thing is that I think it's conceptually the right
solution, and while our "poll_wait()" interface has really worked very
well, the fact that you cannot do anything stateful in it (because
there is never any way to undo anything except for the "remove from
wait queue" action) is very rigid and inflexible.

Of course, aside from signalfd, that inflexibility has never really
mattered. So..

                  Linus
