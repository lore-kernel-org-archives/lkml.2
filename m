Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1JQUez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:34:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33490 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1JQUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:34:54 -0400
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
From: John Stultz <john.stultz@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
In-Reply-To: <Pine.LNX.4.44L0.1110171531190.1749-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1110171531190.1749-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 13:34:21 -0700
Message-ID: <1318883661.3125.94.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 16:07 -0400, Alan Stern wrote:
> > Though as I've been thinking about it, there may be a way to do a
> > userland solution that uses the wakeup_count that isn't so inefficient.
> > Basically, its a varient of Mark's wakeup-device idea, but moved out to
> > userland.
> > 
> > There is a userland PM daemon. Its responsible for both suspending the
> > system, *and* handing all wakeup events.
> > 
> > Normal wakeup consumers open wakeup devices with a special library which
> > passes the open request through the PM daemon. The PM daemon opens the
> > device and provides a pipe fd back to the application, and basically
> > acts as a middle-man.
> > 
> > The PM daemon then cycles, doing the following:
> > 
> > while(1) {
> > 	wakeup_count = read_int(wakeup_count_fd) /*possibly blocking*/
> > 	if (wakeup_count != last_wakeup) {
> > 		have_data = check_open_fds(fds);
> > 		if (have_data)
> > 			process_fds(fds);
> > 		last_wakeup = wakeup_count;
> > 	}
> > 	write_int(wakeup_count_fd, wakeup_count);
> > 	attempt_suspend();
> > }
> > 
> > 
> > Where check_open_fds() does a non-blocking select on all the fds that
> > the PM deamon has opened on behalf of applications, and process_fds()
> > basically writes any available data from the opened fds over to the
> > application through the earlier setup pipe. The daemon's write to the
> > pipe could be blocking, to ensure the application has read all of the
> > necessary data before the deamon continues trying to suspend.
> > 
> > Provided there is some suspend_inhibit/allow command that userspace can
> > make to the PM damon, this approach then provides a similar
> > select/wakelock/read pattern as what Android uses. The only other
> > features we might want is suggestion from Peter that
> > the /sys/power/state be only able to be opened by one application, so
> > that on systems which don't have the PM deamon running, applications
> > like the firmware update tool can try opening /sys/power/state and
> > blocking anyone from suspending under it.
> > 
> > Thoughts?
> 
> So now, instead of contacting every client on every wakeup event, your 
> daemon has to contact a client on every I/O operation!  That hardly 
> seems more efficient.

Well, I guess it depends on the common operation. If we're optimizing
for getting in and out of suspend, then doing less before suspend is
more efficient. 

If we're optimizing for all IO, then this proposal is less efficient.
But this is only for wakeup IO, which I suspect to be less frequent.

And if we're considering something like keyboard presses as wakeup IO,
the extra context switching is really no extra overhead then that
between X and X applications. 

Maybe networking wakeups would be more of a concern, but I'm not
familiar enough with the 3g modems on phones to know exactly if they
differentiate between any packet or have special wakeup packets. None
the less, this overhead would only be for wakeup devices opened through
the PM deamon, everything else would be unaffected.


> Also, this doesn't cope well with wakeup conditions that aren't 
> expressed in terms of data flowing through a pipe, such as a timer 
> expiration.

Quite true. However, its on my list to extend the timerfd to support
alarmtimers, which would provide similar fd semantics as what Android
uses.

thanks
-john


