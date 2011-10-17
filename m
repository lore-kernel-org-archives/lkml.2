Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1JQVne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:43:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36824 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1JQVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:43:31 -0400
Subject: Re: [RFC][PATCH 2/2] PM / Sleep: Introduce cooperative
 suspend/hibernate mode
From: John Stultz <john.stultz@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111018081948.7f354fc6@notabene.brown>
References: <Pine.LNX.4.44L0.1110171417070.1749-100000@iolanthe.rowland.org>
	 <1318878529.3125.80.camel@work-vm> <20111018081948.7f354fc6@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 14:43:21 -0700
Message-ID: <1318887801.3125.122.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11101721-7282-0000-0000-00000290F24D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 08:19 +1100, NeilBrown wrote:
> On Mon, 17 Oct 2011 12:08:49 -0700 John Stultz <john.stultz@linaro.org> wrote:
> 
> > On Mon, 2011-10-17 at 14:19 -0400, Alan Stern wrote:
> > > On Mon, 17 Oct 2011, John Stultz wrote:
> > > 
> > > > So, the alarmtimer code is a bit more simple then what you describe
> > > > above (alarmtimers are just like regular posix timers, only enable an
> > > > RTC wakeup for the soonest event when the system goes into suspend).
> > > > 
> > > > However, such a dual-timer style behavior seems like it could work for
> > > > timer driven wakeups (and have been suggested to me by others as well).
> > > > Just to reiterate my understanding so that we're sure we're on the same
> > > > wavelength:
> > > > 
> > > > For any timer-style wakeup event, you set another non-wakeup timer for
> > > > some small period of time before the wakeup timer. Then when the
> > > > non-wakeup timer fires, the application inhibits suspend and waits for
> > > > the wakeup timer.  
> > > > 
> > > > Thus if the system is supended, the system will stay asleep until the
> > > > wakeup event, where we'll hold off suspend for a timeout length so the
> > > > task can run. If the system is not suspended, the early timer inhibits
> > > > suspend to block the possible race.
> > > > 
> > > > So yes, while not a very elegant solution in my mind (as its still racy
> > > > like any timeout based solution), it would seem to be workable in
> > > > practice, assuming wide error margins are used as the kernel does not
> > > > guarantee that timers will fire at a specific time (only after the
> > > > requested time). 
> > > > 
> > > > And this again assumes we'll see no timing issues as a result of system
> > > > load or realtime task processing.
> > 
> > > It shouldn't have to be this complicated.  If a program wants the
> > > system to be awake at a certain target time, it sets a wakeup timer for
> > > that time.  Then it vetoes any suspend requests that occur too close to 
> > > the target time, and continues to veto them until it has finished its 
> > > job.
> > 
> > I agree that the dual-timer approach is not really a good solution, and
> > doesn't help with similar races on non-timer based wakeups.
> > 
> > Though I also think proposed userland implementations that require
> > communication with all wakeup consumers before suspending (which really,
> > once you get aggressive about suspending when you can, means
> > communicating with all wakeup consumers on every wakeup event) isn't
> > really a good solution either.
> 
> I would help me a lot if you could be more specific than "good".  Do you mean
> "efficient" or "simple" or "secure" or ...

Sorry. Efficient is what I mean. Having every task that consumes wakeup
events to have to be scheduled seems like it would unnecessarily slow
the suspend process.

Although I also don't see how the "its ok to suspend" handshake would
look like from the application's point of view. If the application is
blocking in the kernel on something, I don't think it could respond. So
this would require either signals from the PM demaon or the app to be
sure not to block. It just seems messy. I could just be not getting
something that makes it more elegant, so forgive me if that's the case.


> > Though as I've been thinking about it, there may be a way to do a
> > userland solution that uses the wakeup_count that isn't so inefficient.
> > Basically, its a varient of Mark's wakeup-device idea, but moved out to
> > userland.
> 
> Here I see you probably meant "efficient".  Can that be quantified?  Do you
> have a target latency for getting into suspend, and measurements that show
> you regularly missing this target?
> I am reminded of what Donald Knuth reportedly said about premature
> optimisation.

That is a fair point. I think the Android guys have better sense of the
specifics for suspend latency that they use. But just to get a sense of
it, on one Android board I've used, the system resumes and suspends for
each keystroke over the serial line.

>> There is a userland PM daemon. Its responsible for both suspending the
> > system, *and* handing all wakeup events.
> > 
> > Normal wakeup consumers open wakeup devices with a special library which
> > passes the open request through the PM daemon. The PM daemon opens the
> > device and provides a pipe fd back to the application, and basically
> > acts as a middle-man.
> 
> There is certainly merit in the idea but I think the pipes just get in the
> way.
> 
> How about having both the PM daemon and the application listening on the same
> FD.  The app sends the FD to the PM daemon on the same Unix domain socket
> which is used to request suspend/resume handshaking.
> 
> The PM daemon never reads from the FD.  It only passes it to
> poll/select/whatever.
> 
> When poll says  the FD is ready, the daemon initiated the handshake with the
> app to make sure that it has consumed the event.  If none of the FDs are
> ready for read and no process is blocking suspend, then the daemon is free to
> enter suspend.

So this is starting to sound pretty interesting!

I think you can drop the handshaking on suspend as well, because you can
consider the read() on the application side to mark that the event is
consumed. The application can flag to the pm daemon to inhibit suspend
after a select, but prior to reading.

Does that make sense to you?

This would both avoid the extra context switching to pass the event
over, and avoids the need to schedule everyone before suspending. 

thanks
-john


