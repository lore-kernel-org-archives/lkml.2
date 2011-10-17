Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1JQUf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:35:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab1JQUfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:35:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative suspend/hibernate mode
Date: Mon, 17 Oct 2011 22:38:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
References: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org> <1318878529.3125.80.camel@work-vm>
In-Reply-To: <1318878529.3125.80.camel@work-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110172238.18027.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011, John Stultz wrote:
> On Mon, 2011-10-17 at 14:19 -0400, Alan Stern wrote:
> > On Mon, 17 Oct 2011, John Stultz wrote:
> > 
> > > So, the alarmtimer code is a bit more simple then what you describe
> > > above (alarmtimers are just like regular posix timers, only enable an
> > > RTC wakeup for the soonest event when the system goes into suspend).
> > > 
> > > However, such a dual-timer style behavior seems like it could work for
> > > timer driven wakeups (and have been suggested to me by others as well).
> > > Just to reiterate my understanding so that we're sure we're on the same
> > > wavelength:
> > > 
> > > For any timer-style wakeup event, you set another non-wakeup timer for
> > > some small period of time before the wakeup timer. Then when the
> > > non-wakeup timer fires, the application inhibits suspend and waits for
> > > the wakeup timer.  
> > > 
> > > Thus if the system is supended, the system will stay asleep until the
> > > wakeup event, where we'll hold off suspend for a timeout length so the
> > > task can run. If the system is not suspended, the early timer inhibits
> > > suspend to block the possible race.
> > > 
> > > So yes, while not a very elegant solution in my mind (as its still racy
> > > like any timeout based solution), it would seem to be workable in
> > > practice, assuming wide error margins are used as the kernel does not
> > > guarantee that timers will fire at a specific time (only after the
> > > requested time). 
> > > 
> > > And this again assumes we'll see no timing issues as a result of system
> > > load or realtime task processing.
> 
> > It shouldn't have to be this complicated.  If a program wants the
> > system to be awake at a certain target time, it sets a wakeup timer for
> > that time.  Then it vetoes any suspend requests that occur too close to 
> > the target time, and continues to veto them until it has finished its 
> > job.
> 
> I agree that the dual-timer approach is not really a good solution, and
> doesn't help with similar races on non-timer based wakeups.
> 
> Though I also think proposed userland implementations that require
> communication with all wakeup consumers before suspending (which really,
> once you get aggressive about suspending when you can, means
> communicating with all wakeup consumers on every wakeup event) isn't
> really a good solution either.
> 
> 
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

Well, that's kind of like I thought it might work when I introduced
wakeup_count. :-)  So, I definitely don't think it's a bad approach.
If it addesses all your use cases, I'd say we can go for it, but I'd
like to explore the alternatives as far as we can to avoid going back
to them some time in future.

As for single-opening /sys/power/state, I don't think it will be
sufficient, because of the hibernate user space interface that doesn't
work on the basis of /sys/power/state.  It would have to be something
like /sys/power/manage that Alan has suggested (which opens one more
possibility, but see my reply to Alan).

Thanks,
Rafael
