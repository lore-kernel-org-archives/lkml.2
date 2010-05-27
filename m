Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0E0OHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:07:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60193 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0E0OHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:07:13 -0400
Date: Thu, 27 May 2010 15:06:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527140655.GA28048@srcf.ucam.org>
References: <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com> <1274867106.5882.5090.camel@twins> <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:39:43AM +0100, Alan Cox wrote:

> - Supporting Android needs well good
> - Opportunistic suspend good
> - Manner in which interface is expressed to userspace bad
> - Latency constraint interface would be better
> - Your existing behaviour can be implemented by a simplistic use of a
>   latency constraint interface
> - We can fix a pile of other directly connected things at the same time
> - Implementation internals I care far less about because we can fix those
>   later
> - Suspend is just a power state
> 
> How does that fit your model and vision ?

I don't entirely see how this works. In order to deal with poorly 
written applications, it's necessary to (optionally, based on some 
policy) ignore them when it comes to the scheduler. The problem is how 
to implement the optional nature of this in a race-free manner. This is 
obviously a pathological case, but imagine an application that does 
something along the following lines:

int input = open ("/dev/input", O_RDONLY|O_NONBLOCK);
char foo;

while (1) {
	suspend_block();
	if (read(input, &foo, 1) > 0) {
		(do something)
		suspend_unblock();
	} else {
		suspend_unblock();
		(draw bouncing cows and clouds and tractor beams briefly)
	}
}

Now, if the user is playing this game, you want it to be scheduled. If 
the user has put down their phone and the screen lock has kicked in, you 
don't want it to be scheduled. So we could imagine some sort of cgroup 
that contains untrusted tasks - when the session is active we set a flag 
one way which indicates to the scheduler that tasks in TASK_RUNNING 
should be scheduled, and when the session is idle we set the flag the 
other way and all processes in that cgroup get shifted to 
TASK_INTERRUPTIBLE or something.

Except that doesn't work. If the session goes idle in the middle of the 
app drawing a frame, we'll stop the process and the task will never call 
read(). So the user hits a key, we wake up, nothing shifts from 
TASK_INTERRUPTIBLE into TASK_RUNNING, the key never gets read, we go 
back to sleep. The event never gets delivered.

Now let's try this in the Android world. The user hits a key and the 
system wakes up. The input layer takes a suspend block. The application 
now draws all the cows it wants to, takes its own suspend block and 
reads the input device. This empties the queue and the kernel-level 
suspend block is released. The application then processes the event 
before releasing the suspend block. The event has been delivered and 
handled.

You can't express that with resource limits or QoS constraints. If you 
want to deal with this kind of situation then, as far as I can tell, you 
need either suspend blockers or something so close to them that it makes 
no difference.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
