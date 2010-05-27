Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0E0QKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:10:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49119 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753402Ab0E0QKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:10:00 -0400
Date: Thu, 27 May 2010 17:16:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527155201.GA31937@srcf.ucam.org>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No. Suspend blockers are designed to ensure that suspend isn't racy with 
> respect to wakeup events. The bit that mitigates badly written 
> applications is the bit where the scheduler doesn't run any more.

How does having applications taking blockers fix that - it makes it
worse. They are now blocking the kernel doing the right job.

> If you're happy with a single badly written application being able to 
> cripple your power management story, you don't need opportunistic

And taking a suspend blocker isn't "crippling your power management" ???
 
> What /is/ the correct way to solve this problem when entering explicit 
> suspend states? How do you guarantee that an event has been delivered to 
> userspace before transitioning into suspend? Now, this is a less 
> interesting problem if you're not using opportunistic suspend, but it's 
> still a problem.

The same way as we deal with low power states on other non PC devices ?

> That's no good. If the input device has been deactivated, how does the 
> wakeup event get delivered to the application?

If the input device is letting itself get de-activated in a way that can
lose events the input device driver is buggy. It's nobody elses business
how it does the its job, and certainly *not* the applications.

That's a kernel internal issue.

You know the resource constraint exists because the driver knows it is
open
Your QoS guarantees tell you what you desired latency of response at the
point you can become ready is.

That's all your need to do it right.

In kernel yes your device driver probably does need to say things like
'Don't go below C6 for a moment' just as a high speed serial port might
want to say 'Nothing over 10mS please'

I can't speak for Thomas, but I'm certainly not arguing that you don't
need something that looks more like the blocker side of the logic *in
kernel*, because there is stuff that you want to express which isn't tied
to the task.

So you need

	Userspace -> QoS guarantee expression, implied resource
			expression via device use. *NO* knowledge of
			device or platform in the application

	Kernel space 

		Drivers -> Explicit guarantee expression not bound to
			tasks. Driver encapsulates the variety in the
			device hardware and expresses it in a uniform
			manner to the idling/suspend logic

		CPU Freq -> Encapsulates the variety in the CPU and core
			power functionality of devices, makes policy
			based upon the uniform express from the drivers
			and tasks

All the autonomy is now in the right places, and we have requisite variety
to actually manage the situation.

Alan
