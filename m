Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1JPOvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 10:51:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59131 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753705Ab1JPOvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 10:51:02 -0400
Date: Sun, 16 Oct 2011 10:51:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate
 interfaces
In-Reply-To: <Pine.LNX.4.44L0.1110152224461.19724-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1110161018580.28864-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, Alan Stern wrote:

> Basically, what we need is a reliable way to intercept the existing
> mechanisms for suspend/hibernate and to redirect the requests to the PM
> daemon.  When the daemon is started up in "legacy" mode, it assumes
> there is a legacy client (representing the entire set of
> non-wakeup-aware programs) that always forbids suspend _except_ when
> one of the old mechanisms is invoked.

The more I think about this, the better it seems.  In essence, it 
amounts to "virtualizing" the existing PM interface.

Let's add /sys/power/manage, and make it single-open.  Whenever that 
file is open, writes to /sys/power/state and /dev/snapshot don't work 
normally; instead they get forwarded over /sys/power/manage (and 
results get sent back).  Suspend is easy; hibernation (because of its 
multi-step nature) will be more difficult.

The only important requirement is that processes can use poll system 
calls to wait for wakeup events.  This may not always be true (consider 
timer expirations, for example), but we ought to be able to make some 
sort of accomodation.

The PM daemon will communicate with its clients over a Unix-domain
socket.  The protocol can be extremely simple: The daemon sends a byte
to the client when it wants to sleep, and the client sends the byte
back when it is ready to allow the system to go to sleep.  There's
never more than one byte outstanding at any time in either direction.

The clients would be structured like this:

	Open a socket connection to the PM daemon.

	Loop:

		Poll on possible events and the PM socket.

		If any events occurred, handle them.

		Otherwise if a byte was received from the PM daemon,
		send it back.

In non-legacy mode, the PM daemon's main loop is also quite simple:

	1. Read /sys/power/wakeup_count.

	2. For each client socket:

		If a response to the previous transmission is still
		pending, wait for it.

		Send a byte (the data can be just a sequence number).

		Wait for the byte to be echoed back.

	3. Write /sys/power/wakeup_count.

	4. Write a sleep command to /sys/power/manage.

A timeout can be added to step 2 if desired, but in this mode it isn't
needed.

With legacy support enabled, we probably will want something like a 
1-second timeout for step 2.  We'll also need an extra step at the 
beginning and one at the end:

	0. Wait for somebody to write "standy" or "mem" to 
	   /sys/power/state (received via the /sys/power/manage file).

	5. Send the final status of the suspend command back to the
	   /sys/power/state writer.

Equivalent support for hibernation is left as an exercise for the 
reader.

Obviously the PM daemon will need a secondary thread to accept new 
incoming socket connections, and these connections will have to be 
synchronized with the end of the iteration in step 2 (i.e., don't 
accept new connections between the end of step 2 and the end of step 
4).

Initial startup of the daemon will be a little tricky, because it
shouldn't start carrying out suspends until some clients have had a
chance to connect.  For that matter, in non-legacy mode the daemon
might not want to initiate suspends when there are no clients -- the
system would never get anything done because it would go back to sleep
as soon as the kernel finished processing each wakeup event.

This really seems like it could work, and it wouldn't be tremendously 
complicated.  The only changes needed in the kernel would be the 
"virtualization" (or forwarding) mechanism for legacy support.

Alan Stern

