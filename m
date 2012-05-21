Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2EUTGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:06:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab2EUTGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:06:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [-next regression] TCP window full with EPOLLWAKEUP
Date: Mon, 21 May 2012 21:11:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <4FB81981.3050509@suse.cz> <201205202034.24541.rjw@sisk.pl> <4FBA4946.8080905@suse.cz>
In-Reply-To: <4FBA4946.8080905@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205212111.34800.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2012, Jiri Slaby wrote:
> On 05/20/2012 08:34 PM, Rafael J. Wysocki wrote:
> > On Sunday, May 20, 2012, Rafael J. Wysocki wrote:
> >> On Sunday, May 20, 2012, Rafael J. Wysocki wrote:
> >>> On Sunday, May 20, 2012, Jiri Slaby wrote:
> >>>> Hi,
> >>>>
> >>>> a bisection shows that with the following commit from -next:
> >>>> commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
> >>>> Author: Arve Hjønnevåg <arve@android.com>
> >>>> Date:   Tue May 1 21:33:34 2012 +0200
> >>>>
> >>>>     epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll
> >>>> events are ready
> >>>>
> >>>> ====
> >>>>
> >>>> one of mono programs I use stops receiving data from the network.
> >>>> Wireshark shows that the TCP window of a connection is filled. This
> >>>> means the program does not read the data fast enough after requesting
> >>>> the data.
> >>>>
> >>>> If I revert that commit on the top of -next (20120518), everything works
> >>>> as expected.
> >>>
> >>> Hmm.  I suppose that the failing program doesn't set EPOLLWAKEUP by mistake,
> >>> does it?
> >>
> >> If it doesn't, we can assume that epi-ws is always NULL and all of the added
> >> overhead comes from the function calls.  So, I wonder if the appended patch
> >> makes any difference?
> > 
> > Having thought more about this I have to say this doesn't seem to make much
> > sense, because in that case you'd see some progress, although probably a bit
> > slower than before.
> > 
> > So, I think what happens is that the application tries to set EPOLLWAKEUP,
> > but doesn't have the capability, so the entire operation fails for it, but
> > it doesn't check the return value.
> > 
> > I wonder if the following helps, then.
> > 
> > Thanks,
> > Rafael
> > 
> > 
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
> >  	/* Check if EPOLLWAKEUP is allowed */
> >  	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
> > -		goto error_tgt_fput;
> > +		epds.events &= ~EPOLLWAKEUP;
> 
> Yes, this fixed the issue.

Cool, thanks for testing!

I'll resend it in a while with a changelog and tags.

Thanks,
Rafael
