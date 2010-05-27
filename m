Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab0E0Pdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:33:44 -0400
Received: from www.tglx.de ([62.245.132.106]:58660 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0E0Pdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:33:43 -0400
Date: Thu, 27 May 2010 17:32:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527140655.GA28048@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
References: <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com> <1274867106.5882.5090.camel@twins> <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab>
 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
 <20100527140655.GA28048@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 12:39:43AM +0100, Alan Cox wrote:
> 
> > - Supporting Android needs well good
> > - Opportunistic suspend good
> > - Manner in which interface is expressed to userspace bad
> > - Latency constraint interface would be better
> > - Your existing behaviour can be implemented by a simplistic use of a
> >   latency constraint interface
> > - We can fix a pile of other directly connected things at the same time
> > - Implementation internals I care far less about because we can fix those
> >   later
> > - Suspend is just a power state
> > 
> > How does that fit your model and vision ?
> 
> I don't entirely see how this works. In order to deal with poorly 
> written applications, it's necessary to (optionally, based on some 
> policy) ignore them when it comes to the scheduler. The problem is how 
> to implement the optional nature of this in a race-free manner. This is 
> obviously a pathological case, but imagine an application that does 
> something along the following lines:
> 
> int input = open ("/dev/input", O_RDONLY|O_NONBLOCK);
> char foo;
> 
> while (1) {
> 	suspend_block();
> 	if (read(input, &foo, 1) > 0) {
> 		(do something)
> 		suspend_unblock();
> 	} else {
> 		suspend_unblock();
> 		(draw bouncing cows and clouds and tractor beams briefly)
> 	}
> }
> 
> Now, if the user is playing this game, you want it to be scheduled. If 
> the user has put down their phone and the screen lock has kicked in, you 
> don't want it to be scheduled. So we could imagine some sort of cgroup 
> that contains untrusted tasks - when the session is active we set a flag 
> one way which indicates to the scheduler that tasks in TASK_RUNNING 
> should be scheduled, and when the session is idle we set the flag the 
> other way and all processes in that cgroup get shifted to 
> TASK_INTERRUPTIBLE or something.
> 
> Except that doesn't work. If the session goes idle in the middle of the 
> app drawing a frame, we'll stop the process and the task will never call 
> read(). So the user hits a key, we wake up, nothing shifts from 
> TASK_INTERRUPTIBLE into TASK_RUNNING, the key never gets read, we go 
> back to sleep. The event never gets delivered.
> 
> Now let's try this in the Android world. The user hits a key and the 
> system wakes up. The input layer takes a suspend block. The application 
> now draws all the cows it wants to, takes its own suspend block and 
> reads the input device. This empties the queue and the kernel-level 
> suspend block is released. The application then processes the event 
> before releasing the suspend block. The event has been delivered and 
> handled.

Thanks for providing this example:

  1) It proves that suspend blockers are solely designed to encourage
     people to code crap.

  2) It exposes the main conceptual problem of the approach:

     The input layer in the kernel magically takes a suspend blocker
     and releases it in an equally magic way just to allow the crappy
     application to reach the point where it takes it's own suspend
     blocker and can react on the user input.
     
     And you need to do that, because the user applications suspend
     blocker magic is racy as hell. To work around that you sprinkle
     your suspend blocker magic all over the kernel instead of telling
     people how to solve the problem correctly.

     And what are you achieving with this versus power saving ?

     	 Exaclty _NOTHING_ ! 

     Simply because you move the cow drawing CPU time from the point
     where the device wants to go into suspend to the point where the
     user hits a key again. You even delay the reaction of your app to
     the user input by the time it needs to finish drawing cows.
 
     So you need to come up with a way better example why you need
     your blockers than with this prove of misconception.

> You can't express that with resource limits or QoS constraints. If you 
> want to deal with this kind of situation then, as far as I can tell, you 
> need either suspend blockers or something so close to them that it makes 
> no difference.

Wrong. If your application is interactive then you set the QoS
requirement once to interactive and be done.

So the correct point to make a power state decision is when the app
waits for a key press. At this point the kernel can take several
pathes:

      1) Keep the system alive because the input device is in active
       	 state and a key press is expected

      2) Go into supsend because the input device is deactivated after
      	 the screen lock kicked in.

This behaves exactly the same way in terms of power consumption as
your blocker example just without all the mess you are trying to
create.

And it allows the kernel to use intermediate power saving methods
(between idle and suspend) which might be available on some hardware.

Thanks,

	tglx
