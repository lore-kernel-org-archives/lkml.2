Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab0KPVgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:36:43 -0500
Received: from tango.0pointer.de ([85.214.72.216]:60042 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0KPVgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:36:42 -0500
Date: Tue, 16 Nov 2010 22:36:22 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116213622.GA17824@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
 <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
 <20101116171447.29336514@lxorguk.ukuu.org.uk>
 <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 19:55, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> 
> > we always will apply the final result just fine, when stuff stops
> > changing. It's actually a nice feature and no a problem at all, that
> > we only see the most recent state.
> 
> Stuff never stops changing until the machine shuts down, its undefined.
> 
> > Sure, with the ioctl() we've seen many not interesting changes, but we
> > often miss the single one that is important -- the last last one. The
> > thing is that we don't need to sleep here and miss changes.
> 
> So we fix the ioctl interface, it's not exactly hard to do now is it.

Sorry, the WAITEVENT stuff interface you created is unusably broken:

  a) it's a sleeping ioctl which makes it unusable in anything but the
  most trivial applications, because most programs need to respond to
  more than once wakeup event. Of course, you can then introduce threads
  but that's horrible.

  b) It loses events, because events that happen after you woke up and
  before you go back into WAITEVENT are completely lost. And those
  events might actually be relevant, since they might be the most recent events
  that happened. And those tend to be ones that matter.

Kay's interface also drops events, but only historic events that happened
but aren't current anymore. And that's a good thing, because when you
track which VT is in the foreground for presentation, or for permission
management purposes then you care little of who else should have had
access in the past but didn't get it. You are only interested in the most
recent update, which is what Kay's interface gives you. 

Kay's interface is not intended to be useful for logging purposes. It is
useful to track VT changes for service activation, for permission
management.

> > It's a straight-forward and simple text interface that does all we
> > need to track console and vt changes.
> 
> Except that it doesn't address things like the permissions side of
> things.

Well, the suff it provides is purely informational. You cannot actually
influence the TTY in anyway, you can just watch which VT is currently
active.

I don't think that information should be protected more than
necessary. If 

> "We have an interface that doesn't quite work for our case and we think
> that is a bug" is not the reasoning behind writing a new random one with
> a totally disconnected permission model that doesn't work either.

I am sorry, but WAITEVENT doesn't work for *any* case. It is completely
broken. Have you actually ever tried to use it yourself? Do it. Write me
a race-free program with it that tracks VT switches and i'd be amazed!

> Fix the one we have.

Well, to fix the existing one, you'd a) have to turn it into something
with a pollable fd, and b) something that doesn't lose current
events. And voila, you'll have created Kay's interface.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
