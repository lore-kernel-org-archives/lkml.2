Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1JQVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:20:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50359 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1JQVUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:20:19 -0400
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
From: John Stultz <john.stultz@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>
In-Reply-To: <201110172238.18027.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org>
	 <1318878529.3125.80.camel@work-vm>  <201110172238.18027.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 14:20:09 -0700
Message-ID: <1318886409.3125.106.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 22:38 +0200, Rafael J. Wysocki wrote:
> On Monday, October 17, 2011, John Stultz wrote:
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
> Well, that's kind of like I thought it might work when I introduced
> wakeup_count. :-)  So, I definitely don't think it's a bad approach.
> If it addesses all your use cases, I'd say we can go for it, but I'd
> like to explore the alternatives as far as we can to avoid going back
> to them some time in future.

Do forgive me for not seeing it earlier. But until I considered the idea
of the PM deamon handling the data as well as the wakeup_count, I didn't
really see a solution with a workable API (requiring full communication
before suspending didn't seem very usable in my mind, but I'm still
happy to entertain it if folks can get working protypes going to demo
it).

I of course am still interested in considering other approaches. But
I'll probably see how far I can get in prototyping this current userland
approach to see what issues it runs up against.

> As for single-opening /sys/power/state, I don't think it will be
> sufficient, because of the hibernate user space interface that doesn't
> work on the basis of /sys/power/state.  It would have to be something
> like /sys/power/manage that Alan has suggested (which opens one more
> possibility, but see my reply to Alan).

Right. I forgot about hibernate.

Although maybe if any of the sysfs devices are open, we could return
error on open to all of them? 

I'm just trying to think of what we can do without introducing a new
ABI.

thanks
-john

