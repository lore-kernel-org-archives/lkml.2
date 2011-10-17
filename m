Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1JQXrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:47:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58061 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1JQXrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:47:13 -0400
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
From: John Stultz <john.stultz@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111018094950.22d282a3@notabene.brown>
References: <20111017093401.21cd4461@notabene.brown>
	 <Pine.LNX.4.44L0.1110171030440.2430-100000@iolanthe.rowland.org>
	 <20111018094950.22d282a3@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 16:47:04 -0700
Message-ID: <1318895224.3125.158.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11101723-3352-0000-0000-000000355749
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 09:49 +1100, NeilBrown wrote:
> However for the bits that I feel I do understand, this is what I (currently)
> think it should (or could) look like.
> 
> 
> 1/ There is a suspend-management daemon that starts very early and is the only
>    process that is allowed to initiate suspend or hibernate.  Any other
>    process which tries to do this is a BUG.
> 
> 2/ The daemon has two modes:
>    A/ on-demand.  In this mode it will only enter suspend when requested to,
>       and then only if there is nothing else blocking the suspend.
>    B/ immediate.  In this mode it will enter suspend whenever nothing is
>       blocking the suspend.  The daemon is free to add a small delay
>       proportional to the resume latency if so configured.
>    The daemon is in on-demand mode at start up.
> 
> 3/ The daemon can handle 5 sorts of interactions with clients.
> 
>    i/ Change mode - a request to switch between on-demand and immediate mode.
>   ii/ suspend now - a request to suspend which is only honoured if no client
>       has blocked suspend, and if the kernel is not blocking suspend.
>       Thus it is meaningless in immediate mode.
>  iii/ be-awake-after - this request carries a timestamp and is stateful - it
>       must be explicitly cancelled.  It requests that the system be fully
>       active from that time onwards.

This initially wasn't super clear to me why this is necessary. I see
below it is trying to handle the non-fd timer method to keeping the
system awake.

Although does this also duplex as the  suspend-inhibit/suspend-allow
call made by applications? Or was that interaction just skipped here?

>   iv/ notify - this establishes a 'session' between client and server.
>       Server will call-back and await respond before entering suspend and
>       again after resuming (no response needed for resume).
>       The client is explicitly permitted to make a be-awake-after request
>       during the suspend call-back.

With the notify-fd example included below, I'm curious what specific use
cases you see as requiring the notify interaction? 

>    v/ notify-fd.  This is a special form of 'notify' which carries a file
>       descriptor.  The server is not required to (and not expected to)
>       initiate the 'suspend' callback unless the fd is reporting POLL_IN or
>       POLL_ERR while preparing for suspend.

I'd think it would be "the server is not allowed to" instead of "not
required to".

> 4/ The daemon manages the RTC alarm.  Any other process programing the alarm
>    is a BUG.  Before entering suspend it will program the RTC to wake the
>    system at (or slightly before) the time of the earliest active
>    be-awake-after request.

So, this may need to be revised. My RTC virtualization and alarmtimer
rework gives us a lot more flexibility with RTC events. Given the array
of existing applications that use the RTC chardev, I think its not
realistic to consider it a bug if someone else is using it. 

That said, the posix alarmtimer interface allows us to trigger wakeup
events in the future, without disrupting the legacy chardev programming
(this is possible because the kernel now virtualizes the chardev).

I'd probably rather add alarmtimer functionality to the timerfd, in
order to allow the notify-fd method to work with timers. But its not a
huge deal. I'd just like to avoid reimplementing a timer dispatch system
in userland.


> 5/ Possible implementation approaches for the client interactions:
>    I/ A SOCK_STREAM unix domain socket which takes commands.
>      On connect, server says "+READY".
>      Client writes "MODE ON-DEMAND" or "MODE IMMEDIATE"
>      Server replies "+MODE $MODE"
> 
>   II/ The same unix domain socket as I. 
>      Client writes "SUSPEND"
>      Server replies "+RESUMED" if the suspend happened, or
>                     "-BUSY"  if it didn't.
>      +RESUMED is no guarantee that an measurable time was in suspend, so
>      maybe it isn't needed.
> 
>  III/ A separate Unix domain socket.
>      On connect, server says "Awake" meaning that this connection is ensuring
>      the system will be awake now.
>      Client can write a seconds-since-epoch number, which the server will echo
>      back when confirmed.  When that time arrives - which might be immediately
>      - the server will write "Awake" again.
>      When the client closes the connection, the suspend-block is removed.

What is the seconds-since-epoch bit for? 

>   IV/ A third Unix domain socket.
>      On connect, server writes a single character 'A' meaning 'system is
>      awake'.
>      When initiating suspend, server writes 'S' meaning 'suspend soon'.
>      Client must reply to each 'S' with 'R' meaning 'ready'.  Server does not
>      enter resume until the 'R' is received.
>      On resume, server will write 'A' meaning 'awake' again.  Many clients
>      might ignore this.

Again, still not sure about this bit, but how do you handle aborted
suspends? If you have one blocked task that takes a really long time to
respond, what happens if you've had multiple attempts to suspend that
have aborted? Just want to make sure you don't end up getting an late
ack for an old suspend attempt (although I'm not really sure if that
matters).

>    V/ Same socket as IV, with extra message from client to server.
>      Client writes 'M' (monitor) in a message with SCM_RIGHTS containing one
>      or more fds.  Server will now only send 'S' when one or more of those fds
>      are readable, but the client cannot rely on that and must (as always)
>      not assume that a read will succeed, or will not block.

Err. Not following this. If this is the notify-fd bit, I'd expect the
client to provide the fds, and then that's it. Then the server will
check those fds before trying to suspend, and if any have data, it will
wait until that data is read. Why does the server send an S in this one?
Doesn't the task also see that there is data there?


> 6/ The daemon may impose access control on be-awake messages.  In the above
>    protocol it could be based on SCM_CREDENTIAL messages which might be
>    required.
>    It may also impose timeout on the 'R' reply from the 'S' request, or at
>    least log clients which do not reply promptly.

This again feels more complex then necessary, but I'll leave it be for
now.

> 7/ A client should not delay at all in replying to 'suspend
>    soon' (S) with 'ready' (R).  It should only check if there is anything to
>    do and should make a stay_awake request if there is something.  Then it
>    must reply with 'R'.
>    I should *not* use the fact that suspend is waiting for its reply to
>    respond to an event as this misleads other clients as to the true state of
>    the system.

Again, while I'm not sure about the notify method, this interleaving
seems right to me. 

> 8/ I haven't treated hibernate here.  My feeling is that it would be a
>    different configuration for the daemon.
>    If hibernate were possible and the soonest stay-awake time were longer
>    than X in the future, then the daemon might configure the RTCalarm for X,
>    and when that arrives, it pops out of suspend and goes into hibernate.
>    But the details can wait for revision 2 of the spec..

I'm not sure if hibernate is different in my mind, other then it taking
much longer. It just seems like it would be a subtlety of the type of
"suspend-now" request made to the PM daemon.


So while I'm excited to be making some headway on the userland approach,
I'm also concerned about how this approach might mesh with other dynamic
run-time power-saving methods that might be used in the future. For
instance, if some future scheduler does some form of rate limiting, and
avoids scheduling applications to keep the cpu in deep idle for longer,
would this keep the kernel from knowing enough to not freeze tasks that
might need to do something so that suspend can occur?   This in effect
would cause one power-saving strategy to block a potentially more
power-saving method from occurring. 

This is in part what I was trying to address with my original
SCHED_STAYAWAKE proposal, trying to find a mechanism that provides
adequate information for the kernel to make appropriate decisions. I
worry a little bit about having too narrow a view on these solutions. 

That of course won't keep me from trying to start work on this user-land
approach, but it is something I think we should keep in mind. It seems
with too many things (Dave Hansens' virtualization talk at Plumbers
covered some examples), we end up with 4-5 small solutions to smaller
problems that don't really work well together instead of stepping back
and seeing the broader picture.

thanks
-john

