Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab2EVPvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:51:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59049 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab2EVPve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:51:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH] epoll: Fix user space breakage related to EPOLLWAKEUP (was: Re: [-next regression] TCP window full with EPOLLWAKEUP)
Date: Tue, 22 May 2012 17:56:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
References: <4FB81981.3050509@suse.cz> <201205212128.38157.rjw@sisk.pl> <CAMP5XgcOgpRmbVoWvZ0ZqVCKXuyOCrB1yrTUv=qhY1tsg+SUGA@mail.gmail.com>
In-Reply-To: <CAMP5XgcOgpRmbVoWvZ0ZqVCKXuyOCrB1yrTUv=qhY1tsg+SUGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205221756.34780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2012, Arve Hjønnevåg wrote:
> On Mon, May 21, 2012 at 12:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Commit 4d7e30d (epoll: Add a flag, EPOLLWAKEUP, to prevent
> > suspend while epoll events are ready) caused some applications to
> > malfunction, because they set the bit corresponding to the new
> > EPOLLWAKEUP flag in their eventpoll flags and they don't have the
> > new CAP_EPOLLWAKEUP capability.
> >
> > To prevent that from happening, change epoll_ctl() to clear
> > EPOLLWAKEUP in epds.events if the caller doesn't have the
> > CAP_EPOLLWAKEUP capability instead of failing and returning an
> > error code, which allows the affected applications to function
> > normally.
> >
> > Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  fs/eventpoll.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux/fs/eventpoll.c
> > ===================================================================
> > --- linux.orig/fs/eventpoll.c
> > +++ linux/fs/eventpoll.c
> > @@ -1711,7 +1711,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
> >
> >        /* Check if EPOLLWAKEUP is allowed */
> >        if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
> > -               goto error_tgt_fput;
> > +               epds.events &= ~EPOLLWAKEUP;
> >
> >        /*
> >         * We have to check that the file structure underneath the file descriptor
> 
> Is there any way for the application to detect that it did not get the
> EPOLLWAKEUP feature?

Well, it should check its capabilities beforehand if it really cares ...

Moreover, if the creation of the wakeup source in ep_modify() fails, the
application won't be notified either.

Thanks,
Rafael

