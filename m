Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1JQUHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:07:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59041 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752461Ab1JQUHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:07:02 -0400
Date: Mon, 17 Oct 2011 16:07:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: John Stultz <john.stultz@linaro.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate
 mode
In-Reply-To: <1318878529.3125.80.camel@work-vm>
Message-ID: <Pine.LNX.4.44L0.1110171531190.1749-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, John Stultz wrote:

> I agree that the dual-timer approach is not really a good solution, and
> doesn't help with similar races on non-timer based wakeups.
> 
> Though I also think proposed userland implementations that require
> communication with all wakeup consumers before suspending (which really,
> once you get aggressive about suspending when you can, means
> communicating with all wakeup consumers on every wakeup event) isn't
> really a good solution either.

I think you're not going to be able to do any better.  After a wakeup
event, any of the wakeup consumers could in theory become busy.  
Either you hope that the busy ones will tell the PM daemon they are
busy before the daemon tries another suspend (racy), or else the daemon
has to explicitly check the status of every client.

It doesn't get much better if you replace communication with the PM
daemon by communication with the kernel.

> Though as I've been thinking about it, there may be a way to do a
> userland solution that uses the wakeup_count that isn't so inefficient.
> Basically, its a varient of Mark's wakeup-device idea, but moved out to
> userland.
> 
> There is a userland PM daemon. Its responsible for both suspending the
> system, *and* handing all wakeup events.
> 
> Normal wakeup consumers open wakeup devices with a special library which
> passes the open request through the PM daemon. The PM daemon opens the
> device and provides a pipe fd back to the application, and basically
> acts as a middle-man.
> 
> The PM daemon then cycles, doing the following:
> 
> while(1) {
> 	wakeup_count = read_int(wakeup_count_fd) /*possibly blocking*/
> 	if (wakeup_count != last_wakeup) {
> 		have_data = check_open_fds(fds);
> 		if (have_data)
> 			process_fds(fds);
> 		last_wakeup = wakeup_count;
> 	}
> 	write_int(wakeup_count_fd, wakeup_count);
> 	attempt_suspend();
> }
> 
> 
> Where check_open_fds() does a non-blocking select on all the fds that
> the PM deamon has opened on behalf of applications, and process_fds()
> basically writes any available data from the opened fds over to the
> application through the earlier setup pipe. The daemon's write to the
> pipe could be blocking, to ensure the application has read all of the
> necessary data before the deamon continues trying to suspend.
> 
> Provided there is some suspend_inhibit/allow command that userspace can
> make to the PM damon, this approach then provides a similar
> select/wakelock/read pattern as what Android uses. The only other
> features we might want is suggestion from Peter that
> the /sys/power/state be only able to be opened by one application, so
> that on systems which don't have the PM deamon running, applications
> like the firmware update tool can try opening /sys/power/state and
> blocking anyone from suspending under it.
> 
> Thoughts?

So now, instead of contacting every client on every wakeup event, your 
daemon has to contact a client on every I/O operation!  That hardly 
seems more efficient.

Also, this doesn't cope well with wakeup conditions that aren't 
expressed in terms of data flowing through a pipe, such as a timer 
expiration.

Alan Stern

