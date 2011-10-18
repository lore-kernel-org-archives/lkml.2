Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab1JRRLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:11:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55820 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932219Ab1JRRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:11:06 -0400
Date: Tue, 18 Oct 2011 13:11:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: NeilBrown <neilb@suse.de>
cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <20111018131358.1c964c32@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110181135070.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, NeilBrown wrote:

> On Mon, 17 Oct 2011 16:47:04 -0700 John Stultz <john.stultz@linaro.org> wrote:
> 
> > On Tue, 2011-10-18 at 09:49 +1100, NeilBrown wrote:
> > > However for the bits that I feel I do understand, this is what I (currently)
> > > think it should (or could) look like.
> > > 
> > > 
> > > 1/ There is a suspend-management daemon that starts very early and is the only
> > >    process that is allowed to initiate suspend or hibernate.  Any other
> > >    process which tries to do this is a BUG.
> > > 
> > > 2/ The daemon has two modes:
> > >    A/ on-demand.  In this mode it will only enter suspend when requested to,
> > >       and then only if there is nothing else blocking the suspend.
> > >    B/ immediate.  In this mode it will enter suspend whenever nothing is
> > >       blocking the suspend.  The daemon is free to add a small delay
> > >       proportional to the resume latency if so configured.
> > >    The daemon is in on-demand mode at start up.

A minor point...  This distinction may not truly be necessary.  
On-demand mode is pretty much the same as immediate mode with an
implicit client that is almost never ready to suspend.

That business about "only if nothing else is blocking the suspend" in 
on-demand mode is troubling.  What happens if something else _is_ 
blocking the suspend?  Will the GNOME power manager go into a tight 
loop, asking over and over for suspends that all fail?

> > > 3/ The daemon can handle 5 sorts of interactions with clients.
> > > 
> > >    i/ Change mode - a request to switch between on-demand and immediate mode.

May or may not be needed, depending on what we decide about these 
modes.

> > >   ii/ suspend now - a request to suspend which is only honoured if no client
> > >       has blocked suspend, and if the kernel is not blocking suspend.
> > >       Thus it is meaningless in immediate mode.
> > >  iii/ be-awake-after - this request carries a timestamp and is stateful - it
> > >       must be explicitly cancelled.  It requests that the system be fully
> > >       active from that time onwards.
> > 
> > This initially wasn't super clear to me why this is necessary. I see
> > below it is trying to handle the non-fd timer method to keeping the
> > system awake.
> > 
> > Although does this also duplex as the  suspend-inhibit/suspend-allow
> > call made by applications? Or was that interaction just skipped here?
> 
> Yes, exactly.  This is primarily allowing an application to say "inhibit
> suspend" (aka "be awake").  Being able to make the request for a future time
> seemed a natural and simple extension.
> If you can do timer wakeups like other wakeups and find it easier that way,
> then we can leave the timestamp out of it.

There's another way to implement "inhibit suspend" -- via the notify 
mechanism.  If the client doesn't respond to a callback, the server 
won't suspend.  Hence if people use the fd-timer approach, 
be-awake-after isn't needed.

On the other hand, the notify-fd mechanism _does_ need a "stay awake"
call (it could be something as simple as a 'W' message in the
protocol).  Without it, you run the risk that the client might read the
fd data before the server sees it.  The server would think the client
was idle while it was busily processing the data.

> > >   iv/ notify - this establishes a 'session' between client and server.
> > >       Server will call-back and await respond before entering suspend and
> > >       again after resuming (no response needed for resume).
> > >       The client is explicitly permitted to make a be-awake-after request
> > >       during the suspend call-back.
> > 
> > With the notify-fd example included below, I'm curious what specific use
> > cases you see as requiring the notify interaction? 
> 
> None specifically.  However while I'm convinced that all events must be
> visible to user-space I am not convinced that they will be visible to a
> poll.  You might occasionally require a read on a sysfs file, and then parse
> the contents to see if the event happened.
> We can do poll on sysfs files now so that can probably be avoided.
> But I didn't want to close doors before I was sure no-one needed them.

Agreed; a non-poll arrangement should not be ruled out.

> And I think that with notify-fd you still need a hand-shake of some sort, and
> this provides a simple starting point.
> 
> > 
> > >    v/ notify-fd.  This is a special form of 'notify' which carries a file
> > >       descriptor.  The server is not required to (and not expected to)
> > >       initiate the 'suspend' callback unless the fd is reporting POLL_IN or
> > >       POLL_ERR while preparing for suspend.
> > 
> > I'd think it would be "the server is not allowed to" instead of "not
> > required to".

That doesn't make sense.  The fd state could change between the time 
the server checks it and the time the suspend callback is sent.

> Maybe.  When specifying a protocol I am cautious of excluding things that are
> merely inconvenient.  So "should not" but not "shall not" in rfc-speak.
> However it might be easier on the client if it knew there would never be a
> call-back so it might be best to make it "shall now".

I'm not convinced that notify-fd is a good idea.  Compare the messages 
needed for notify vs. notify-fd:

	notify: The server queries clients and needs to receive a 
		response before each suspend.

	notify-fd: The server queries clients only when it knows they
		are likely to be busy, and the clients must notify the
		server every time they get a wakeup event.

It's not immediately obvious which involves more back-and-forth
messaging.  But then consider when those messages occur:

	With notify, clients send and receive messages only when they 
	are idle.

	With notify-fd, clients have to send a message before starting
	to process each wakeup event.

Sending more messages when you are idle seems better than sending fewer
when you have work to do.

> > > 4/ The daemon manages the RTC alarm.  Any other process programing the alarm
> > >    is a BUG.  Before entering suspend it will program the RTC to wake the
> > >    system at (or slightly before) the time of the earliest active
> > >    be-awake-after request.
> > 
> > So, this may need to be revised. My RTC virtualization and alarmtimer
> > rework gives us a lot more flexibility with RTC events. Given the array
> > of existing applications that use the RTC chardev, I think its not
> > realistic to consider it a bug if someone else is using it. 
> 
> If multiple applications think they can independently "own" the RTC alarm
> then that sounds like it is already a bug quite apart from anything I add.
> 
> We must have some way to virtualise the rtc-alarm so that any app can be sure
> there will we be a wakeup at-or-before some time.  I suggested doing that via
> the suspend daemon.  If there is a strong case for a more general
> kernel-based virtualisation of the RTC alarm in the kernel - then maybe that
> is OK.
> 
> > 
> > That said, the posix alarmtimer interface allows us to trigger wakeup
> > events in the future, without disrupting the legacy chardev programming
> > (this is possible because the kernel now virtualizes the chardev).
> > 
> > I'd probably rather add alarmtimer functionality to the timerfd, in
> > order to allow the notify-fd method to work with timers. But its not a
> > huge deal. I'd just like to avoid reimplementing a timer dispatch system
> > in userland.
> 
> Yep.  Exactly which solution gets implemented isn't important as long as it
> is clean and well defined.

Agreed.

> > > 5/ Possible implementation approaches for the client interactions:
> > >    I/ A SOCK_STREAM unix domain socket which takes commands.
> > >      On connect, server says "+READY".
> > >      Client writes "MODE ON-DEMAND" or "MODE IMMEDIATE"
> > >      Server replies "+MODE $MODE"
> > > 
> > >   II/ The same unix domain socket as I. 
> > >      Client writes "SUSPEND"
> > >      Server replies "+RESUMED" if the suspend happened, or
> > >                     "-BUSY"  if it didn't.
> > >      +RESUMED is no guarantee that an measurable time was in suspend, so
> > >      maybe it isn't needed.

I like the single-letter messages better than complete words.  Not a 
big deal either way...

> > >  III/ A separate Unix domain socket.
> > >      On connect, server says "Awake" meaning that this connection is ensuring
> > >      the system will be awake now.
> > >      Client can write a seconds-since-epoch number, which the server will echo
> > >      back when confirmed.  When that time arrives - which might be immediately
> > >      - the server will write "Awake" again.
> > >      When the client closes the connection, the suspend-block is removed.
> > 
> > What is the seconds-since-epoch bit for? 
> 
> That is the time when the server will ensure the system is awake from.  i.e.
> the wakeup timer.  If it is in the past, it means "be awake now".
> 
> 
> > 
> > >   IV/ A third Unix domain socket.
> > >      On connect, server writes a single character 'A' meaning 'system is
> > >      awake'.
> > >      When initiating suspend, server writes 'S' meaning 'suspend soon'.
> > >      Client must reply to each 'S' with 'R' meaning 'ready'.  Server does not
> > >      enter resume until the 'R' is received.
> > >      On resume, server will write 'A' meaning 'awake' again.  Many clients
> > >      might ignore this.
> > 
> > Again, still not sure about this bit, but how do you handle aborted
> > suspends? If you have one blocked task that takes a really long time to
> > respond, what happens if you've had multiple attempts to suspend that
> > have aborted? Just want to make sure you don't end up getting an late
> > ack for an old suspend attempt (although I'm not really sure if that
> > matters).
> 
> The server just needs to ensure that on every connection that it sends an 'S',
> it waits for an 'R', and subsequently sends an 'A'.

It shouldn't send the 'A' unless the client asked it to.

> Whether a suspend actually happens between the R and the A, or whether it was
> aborted, is irrelevant.
> After a suspend, whether aborted or not, the server must send 'A' to all
> clients that it sent 'S' to.

No -- only to clients that responded with 'R' and that asked for the
'A'.  If 'S' was sent to a client, the server must not send anything
more to that client until an 'R' is received.

>  Then it must sent S and wait for R before
> trying to suspend again.
> 
> So a client that has been blocked for a while might see an 'A' and an 'S' but
> that is all.  If it blocked for too long and the server was allowed to reject
> it, it might see a closed connection.
> There should be no confusion.

Is there any reason for the server ever to close a connection, other
than perhaps insufficient access rights?

> > >    V/ Same socket as IV, with extra message from client to server.
> > >      Client writes 'M' (monitor) in a message with SCM_RIGHTS containing one
> > >      or more fds.  Server will now only send 'S' when one or more of those fds
> > >      are readable, but the client cannot rely on that and must (as always)
> > >      not assume that a read will succeed, or will not block.
> > 
> > Err. Not following this. If this is the notify-fd bit, I'd expect the
> > client to provide the fds, and then that's it. Then the server will
> > check those fds before trying to suspend, and if any have data, it will
> > wait until that data is read. Why does the server send an S in this one?
> > Doesn't the task also see that there is data there?
> 
> As I said in another email "wait until data has been read" is not an
> operation that Linux supports directly.
> The server sends the S so that it can then wait for the R.

Right.  Besides, "wait until data has been read" is the wrong thing to 
do.  The client needs time to process the data after reading it.

> But maybe it can wait for a separate "stay awake" request - that can be in
> v0.2 of the protocol.

The client has to send a "stay awake" request to avoid races.  It 
should be sufficient for the server to wait until it gets either that 
or the 'R'.

> > > 6/ The daemon may impose access control on be-awake messages.  In the above
> > >    protocol it could be based on SCM_CREDENTIAL messages which might be
> > >    required.
> > >    It may also impose timeout on the 'R' reply from the 'S' request, or at
> > >    least log clients which do not reply promptly.
> > 
> > This again feels more complex then necessary, but I'll leave it be for
> > now.

We would be better off requiring proper access control at the start of
each connection.  Random processes should not be able to prevent the 
system from suspending.

> > > 7/ A client should not delay at all in replying to 'suspend
> > >    soon' (S) with 'ready' (R).  It should only check if there is anything to
> > >    do and should make a stay_awake request if there is something.  Then it
> > >    must reply with 'R'.
> > >    I should *not* use the fact that suspend is waiting for its reply to
> > >    respond to an event as this misleads other clients as to the true state of
> > >    the system.
> > 
> > Again, while I'm not sure about the notify method, this interleaving
> > seems right to me. 
> > 
> > > 8/ I haven't treated hibernate here.  My feeling is that it would be a
> > >    different configuration for the daemon.
> > >    If hibernate were possible and the soonest stay-awake time were longer
> > >    than X in the future, then the daemon might configure the RTCalarm for X,
> > >    and when that arrives, it pops out of suspend and goes into hibernate.
> > >    But the details can wait for revision 2 of the spec..
> > 
> > I'm not sure if hibernate is different in my mind, other then it taking
> > much longer. It just seems like it would be a subtlety of the type of
> > "suspend-now" request made to the PM daemon.

That's my feeling too.

Alan Stern

