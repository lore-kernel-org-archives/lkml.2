Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1JUQHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:07:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40963 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752650Ab1JUQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:07:08 -0400
Date: Fri, 21 Oct 2011 12:07:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
In-Reply-To: <20111021162340.669742c0@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110211139420.2131-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, NeilBrown wrote:

> Hi,
> 
> I wasn't going to do this... but then I did.  I think that sometimes coding is
> a bit like chocolate.

Getting started is always a big hurdle, for me anyway.

> At:
>     git://neil.brown.name/lsusd
> or
>     http://neil.brown.name/git/lsusd
> 
> you can find a bunch of proof-of-concept sample code that implements a
> "Linux SUSpend Daemon" with client support library and test programs.
> 
> I haven't actually tested it as root and had it actually suspend and resume
> and definitely haven't had it even close to a race condition, but the
> various bits seem to work with each other properly when I run them under
> strace and watch.
> 
> It didn't turn out quite the way I imagined, but then cold harsh reality has
> a way of destroying our dreams, doesn't it :-)
> 
> 
> Below is the README file.  Comment welcome as always.
> I'm happy for patches too, but I'm equally happy for someone to re-write it
> completely and make something really useful and maintainable.
> 
> NeilBrown
> 
> -----------------------------------------------------------------
> 
> This directory contains a prototype proof-of-concept system
> for managing suspend in Linux.
> Thus the Linux SUSpend Daemon.
> 
> It contains:
> 
>  lsusd:

This name is no good; it's too much like "lsusb".  In fact, anything 
starting with "ls" is going to be confusing.  Not that I have any 
better suggestions at the moment...

>     The main daemon.  It is written to run a tight loop and blocks as
>      required.  It obeys the wakeup_count protocol to get race-free
>      suspend and allows clients to register to find out about
>      suspend and to block it either briefly or longer term.
>     It uses files in /var/run/suspend for all communication.

I'm not so keen on using files for communication.  At best, they are
rather awkward for two-way messaging.  If you really want to use them,
then at least put them on a non-backed filesystem, like something under
/dev.

>     File are:
> 
>       disabled:  This file always exists.  If any process holds a
>         shared flock(), suspend will not happen.
>       immediate:  If this file exists, lsusd will try to suspend whenever
>         possible.
>       request:  If this is created, then lsusd will try to suspend
>         once, and will remove the file when suspend completes or aborts.
>       watching:  This is normally empty.  Any process wanting to know
>         about suspend should take a shared flock and check the file is
>         still empty, and should watch for modification.
>         When suspend is imminent, lsusd creates 'watching-next', writes
>          a byte to 'watching' and waits for an exclusive lock on 'watching'.
>         Clients should move their lock to 'watching-next' when ready for
>         suspend.
>         When suspend completes, another byte (or 2) is written to
>         'watching', and 'watching-next' is renamed over it.  Clients can
>         use either of these to know that resume has happened.
> 
>       watching-next: The file that will be 'watching' in the next awake cycle.
> 
>     lsusd does not try to be event-loop based because:
>       - /sys/power/wakeup_count is not pollable.  This could probably be
>         'fixed' but I want code to work with today's kernel.  It will probably

Why does this matter?

>         only block 100msec at most, but that might be too long???

Too long for what?

>       - I cannot get an event notification when a lock is removed from a
>         file. :-(  And I think locks are an excellent light-weight
>         mechanism for blocking suspend.

Except for this one drawback.  Socket connections are superior in that 
regard.

>   lsused:
>       This is an event-loop based daemon that can therefore easily handle
>       socket connections and client protocols which need prompt
>       response.  It communicates with lsusd and provides extra
>       services to client.
> 
>       lsused (which needs a better name) listens on the socket
>             /var/run/suspend/registration
>       A client may connect and send a list of file descriptors.

Including an empty list?

>       When a suspend is immanent, if any file descriptor is readable,

Or if no file descriptors were sent?

>       lsused will send a 'S' message to the client and await an 'R' reply
>       (S == suspend, R == ready).  When all replies are in, lsused will
>       allow the suspend to complete.  When it does (or aborts), it will send
>       'A' (awake) to those clients to which it sent 'S'.

But not to the client which failed to send an 'R'?

>       This allows a client to get a chance to handle any wakeup events,
>       but not to be woken unnecessarily on every suspend.

In practice, it may be best for clients that handle a large number of 
wakeup events to avoid using the fd mechanism.  Clients that handle 
only occasional wakeups may be better off using it.

You left out an important element: A client must be allowed to send
'A' at any time, indicating that it does not want to suspend now.  Of 
course, this will work reliably only if the client uses the fd 
mechanism.

I'm not sure it's such a good idea to separate this from the main 
daemon.  A crucial point of the protocol is that the daemon reads 
/sys/power/wakeup_count before sending all the 'S' messages, and waits 
for all the 'R' replies before writing wakeup_count.  The two-program 
approach would make this difficult.

>    wakealarmd:
>       This allows clients to register on the socket.
>              /var/run/suspend/wakealarm
>       They write a timestamp in seconds since epoch, and will receive
>       a 'Now' message when that time arrives.
>       Between the time the connection is made and the time a "seconds"
>       number is written, suspend will be blocked.
>       Also between the time that "Now" is sent and when the socket is
>       closed, suspend is also blocked.

In theory, this could be integrated with the previous program.

Alan Stern


