Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab0LEXFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:05:33 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17201 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0LEXFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:05:32 -0500
Date: Sun, 5 Dec 2010 23:58:35 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Colin Walters <walters@verbum.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ray Lee <ray-lk@madrabbit.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
In-Reply-To: <AANLkTi=jN83+w8AC8bOMtmqmgp3SLpTvtfoAYE9nR=H0@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012052348400.16078@swampdragon.chaosbits.net>
References: <1289783580.495.58.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net> <20101116150319.GA3475@redhat.com>
 <1289922108.5169.185.camel@maggy.simson.net> <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net> <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com> <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
 <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com> <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com> <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com> <AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com>
 <AANLkTi=7FRCK9R2PVCTdtSqKo9FZemD5cXQTFoOKLEFB@mail.gmail.com> <AANLkTinOQ5sWigfW844dSBc2PvVwFj5c7yu+scNXxMcv@mail.gmail.com> <AANLkTi=jN83+w8AC8bOMtmqmgp3SLpTvtfoAYE9nR=H0@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Dec 2010, Colin Walters wrote:

> On Sun, Dec 5, 2010 at 3:47 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The semantics of "nice" are not - and have never been - to put things
> > into process scheduling groups of their own.
> 
> Again, I obviously understand that - the point is to explore the space
> of changes here and consider what would (and wouldn't) break.  And
> actually, what would improve.
> 
> > This is very much documented. People rely on it.
> 
> Well, we established my Fedora 14 system doesn't.  You said "no one"
> uses "nice" interactively.  So...that leaves - who?  If you were
> saying to me something like "I know Yahoo has some code in their data
> centers which uses a range of nice values; if we made this change, all
> of a sudden they'd get more CPU contention..."  Or like, "I'm pretty
> sure Maemo uses very low nice values for some UI code".  But you so
> far haven't really done that, it's just been (mostly)
> assertions/handwaving.  Now you obviously have a lot more experience
> that gives those assertions and handwaving a lot of credibility - but
> all we need is one concrete example to shut me up =)
> 
[...]

I'll give you two re-world examples from two (closed source, but 
still) apps we develop at my current employer.

The first one is a server/network monitoring app where there are lots of 
child processes devoted to performing checks, storing data, displaying 
results etc. Most of these processes just run at the default nice level. 
One of the processes sometimes has a need for a cryptographic key pair and 
it can generate this when it needs it, but it's better if one is reaily 
available, so we have a seperate child process running that maintains a 
small pool of new key pairs - this process runs at a high nice level since 
it should not take CPU time away from the rest of the processes (it's not 
important, it's just a small optimization), the need for key pairs comes 
at large intervals, so the pool will almost never be depleted even if 
this process doesn't get very much CPU time for a long time and besides, 
if the pool ever gets depleted its no disaster since the consumer will 
then just generate a key pair when needed and burn the required CPU.

The second is a backup aplication where one child process is in charge of 
doing background disk scanning, compression and encryption. This process 
is not interactive, it must result in minimal interference with whatever 
the user is currently using the machine for as his primary task and 
time-to-completion is not really that important. So, this process runs at 
a rather high nice level to avoid stealing CPU from the users primary 
task(s).


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

