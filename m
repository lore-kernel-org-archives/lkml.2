Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab0KPXKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:10:55 -0500
Received: from tango.0pointer.de ([85.214.72.216]:52690 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453Ab0KPXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:10:53 -0500
Date: Wed, 17 Nov 2010 00:10:24 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116231023.GB27594@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
 <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
 <20101116171447.29336514@lxorguk.ukuu.org.uk>
 <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
 <20101116213622.GA17824@tango.0pointer.de>
 <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 22:56, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> > Sorry, the WAITEVENT stuff interface you created is unusably broken:
> > 
> >   a) it's a sleeping ioctl which makes it unusable in anything but the
> >   most trivial applications, because most programs need to respond to
> >   more than once wakeup event. Of course, you can then introduce threads
> >   but that's horrible.
> > 
> >   b) It loses events, because events that happen after you woke up and
> >   before you go back into WAITEVENT are completely lost. And those
> >   events might actually be relevant, since they might be the most recent events
> >   that happened. And those tend to be ones that matter.
> 
> So those are both trivial enough to fix as far as I can see but by the
> sound of it neither actually solve what you want to do.

Trivial enough to fix? No it isn't. We tried to come up with a sane fix
for the current ioctl() iface, but it's not feasible. a) is unfixable
anyway without some kind of additional fd, since the tty fd is not
really something you want to overload with new POLLxxx events. For b)
you either need a per-consumer queue, so that no events are lost. That
is cumbersome, and would add a massive amount of code to the kernel. Or
you need some kind of atomic extenstion a la "wait only if this
information is still current". Which would work for our use case but
still eat events that happen between the WAITEVENT calls. Or you would
have to do this synchronous, which would basically allow userspace to
block VT switches and the kernel indefinitely. Which is dangerous.

> > Kay's interface also drops events, but only historic events that happened
> > but aren't current anymore. And that's a good thing, because when you
> > track which VT is in the foreground for presentation, or for permission
> > management purposes then you care little of who else should have had
> > access in the past but didn't get it. You are only interested in the most
> > recent update, which is what Kay's interface gives you.
> 
> No Kay's interface gives you some random reasonably recent answer that
> could well be wrong.

The POLLPRI bit is set until the moment you read the current VT
value. Then it is atomically reset at the same time as your read(). At
that time the VT info is up-to-date and the newest one. If it then
changes again, the POLLPRI bit is set again, and the next time you call
poll() you will be notified about that and wakeup right away. With other
words: the moment you read the VT info from the kernel it is always the
latest info available. And the POLLPRI makes sure that you will notice
it isn't up-to-date the moment you enter poll() again. Race-free.

> > Kay's interface is not intended to be useful for logging purposes. It is
> > useful to track VT changes for service activation, for permission
> > management.
> 
> You wish to do permission management based upon stale unlocked data,
> yeah that sounds about the standard of some of the current shipping
> desktops.

What matters is that we fix the perms before we inform clients about the
VT switches. It does not matter that change the perms before the kernel
officially went through with the VT switch. Or in other words:
delivery of notification about VT switches can be done asynchronously
between the kernel and the perm manager. But from the perm manager to
the services we need synchronous notification. (Or, alternatively, they
just use inotify on the device nodes, which in fact many already do).

> > Well, the suff it provides is purely informational. You cannot actually
> > influence the TTY in anyway, you can just watch which VT is currently
> > active.
> 
> Try that with "keystrokes" for example. its a bogus argument.

Jeez. Kay's interface does not expose keystrokes. Just a simple integer
which tells yu which VT is current.

> > events. And voila, you'll have created Kay's interface.
> 
> Which also doesn't work reliably and you want to use it for permissions
> management !
> 
> Describe this permission management you are doing please.

When two users A and B are logged in, on tty1 resp. tty2, then as long
as tty1 is active user A should get access to the sound card, usb key,
.... As soon as we switch to tty2 user B should.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
