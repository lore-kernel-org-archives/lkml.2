Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1JVCAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 22:00:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46727 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752063Ab1JVCAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 22:00:14 -0400
Date: Fri, 21 Oct 2011 22:00:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
In-Reply-To: <20111022093436.0742176c@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110212125020.8657-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Oct 2011, NeilBrown wrote:

> > >     It uses files in /var/run/suspend for all communication.
> > 
> > I'm not so keen on using files for communication.  At best, they are
> > rather awkward for two-way messaging.  If you really want to use them,
> > then at least put them on a non-backed filesystem, like something under
> > /dev.
> 
> Isn't /var/run a tmpfs filesystem?  It should be.
> Surely /run is, so in the new world order the files should probably go
> there.   But that is just a detail.

On my Fedora-14 systems there is no /run, and /var/run is a regular 
directory in a regular filesystem.

> I like files...  I particularly like 'flock' to block suspend.   The
> rest.... whatever..
> With files, you only need a context switch when there is real communication.
> With sockets, every message sent must be read so there will be a context
> switch.
> 
> Maybe we could do something with futexes...

Not easily -- as far as I can tell, futexes enjoy relatively little 
support.  In any case, they provide the same service as a mutex, which 
means you'd have to build a shared lock on top of them.

> > >     lsusd does not try to be event-loop based because:
> > >       - /sys/power/wakeup_count is not pollable.  This could probably be
> > >         'fixed' but I want code to work with today's kernel.  It will probably
> > 
> > Why does this matter?
> 
> In my mind an event based program should never block.  Every action should be
> non-blocking and only taken when 'poll' says it can.
> Reading /sys/power/wakeup_count can be read non-blocking, but you cannot find
> out when it is sensible to try to read it again.  So it doesn't fit.

There shouldn't be any trouble about making wakeup_count pollable.  It
also would need to respect nonblocking reads, which it currently does 
not do.

At the worst, you could always have a separate thread to read 
wakeup_count.

> > >       - I cannot get an event notification when a lock is removed from a
> > >         file. :-(  And I think locks are an excellent light-weight
> > >         mechanism for blocking suspend.
> > 
> > Except for this one drawback.  Socket connections are superior in that 
> > regard.
> 
> I'm very happy for someone else write an all-socket based daemon.

Hmmm...  Maybe I'll take you up on that.


> > >       lsused will send a 'S' message to the client and await an 'R' reply
> > >       (S == suspend, R == ready).  When all replies are in, lsused will
> > >       allow the suspend to complete.  When it does (or aborts), it will send
> > >       'A' (awake) to those clients to which it sent 'S'.
> > 
> > But not to the client which failed to send an 'R'?
> 
> Every client must send an R before suspend can continue.

I was referring to the case where you abort before receiving an 'R'.  
The current suspend attempt will fail, but then what happens during the
next attempt?

>  I don't currently
> have an special handling for clients that misbehave.  I'm not even certain
> that I correctly hand the case where the client dies and the socket closes.

Clients that misbehave will prevent the system from suspending.  It's 
probably not a good idea to try and second-guess them.

On the other hand, the daemon certainly should be able to handle 
socket closure at any time.

> My original plan was to have a single daemon with a main loop and a bunch of
> loadable modules that provided different protocols to clients: simple-socket,
> file-based, dbus, "suspend.d" script directory etc.   That might still be fun
> but it won't be a priority for a while.

Yeah.  I don't see much advantage over a single protocol plus a client 
library.

Alan Stern

