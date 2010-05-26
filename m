Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0EZNJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:09:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50994 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541Ab0EZNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:09:17 -0400
Date: Wed, 26 May 2010 14:16:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Mickler <florian@mickler.org>
Cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
In-Reply-To: <20100526142430.327ccbc4@schatten.dmk.lab>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Really, what are you getting at? Do you deny that there are programs,
> that prevent a device from sleeping? (Just think of the bouncing
> cows app)
> 
> And if you have two kernels, one with which your device is dead after 1
> hour and one with which your device is dead after 10 hours. Which would
> you prefer? I mean really... this is ridiculous. 

The problem you have is that this is policy. If I have the device wired
to a big screen and I want cows bouncing on it I'll be most upset if
instead it suspends. What you are essentially arguing for is for the
kernel to disobey the userspace. It's as ridiculous (albeit usually less
damaging) as a file system saying "Ooh thats a rude file name, the app
can't have meant it, I'll put your document soemwhere else"

The whole API feels wrong to me. It's breaking rule #1 of technology "You
cannot solve a social problem with technology". In this case you have a
social/economic problem which is crap code. You solve it with an
economics solution - creative incentives not to produce crap code like
boxes that keep popping up saying "App XYZ is using all your battery" and
red-amber-green powermeter scores in app stores.

That said if you want technical mitigation I think it makes more sense
if you look at it from a different starting point. The starting point
being this: We have idling logic in the kernel and improving this helps
everyone. What is needed to improve the existing logic ?

- You don't know which processes should be ignored for the purpose of
  suspend (except for kernel threads) and there is no way to set this

- You don't know whether a move from a deep idle to a 'suspend' (which is
  just a really deep idle in truth anyway) might break wakeups
  requirements because a device has wake dependencies due to hardware
  design (eg a port that has no electronics to kick the box out of
  suspend into running). This is a problem we have already. [1]

That maps onto two existing ideas

Sandboxing/Resource Limits: handling apps that can't be trusted. So the
phone runs the appstore code via something like

		setpidle(getpid(), something);
		exec()

where 'something' is a value with meaning to both user space and to the
existing idling logic in the kernel that basically says to what extent it
is permitted to block idling/suspend. That also seems to tie into some of
the realtime + idle problems. This I think deals with Kevin Hillman's
thoughts on dealing with untrustworthy app code more cleanly and avoids
the need for userspace hackery like the blocker API.

And an entirely in kernel API where device drivers can indicate that in
their current situation they require that the power level doesn't drop
below some limit unless user requested. This is really important because
the platform vendor of the phone/pda/tablet whatever effectively owns the
kernel - so it's *their* problem, *their* control, *their* hardware and
they can make it work as best for the device. Best of all it means its
all free software stuff so if the vendor screws up you can still fix your
phone. 

Implementation-wise it probably ties into setpidle, its simply that a task
has a pair of idle values, a dynamic one and a base one, the dynamic one
being the base one but updatable temporarily by drivers.

Alan
--

[1] Note I disagree with Kevin here on static/dynamic power management.
There are IMHO two types of PM but they are 'user invoked' and
'automatic'. "Static" simply means it's not been made fast enough yet but
its just a policy divide dependant on the users 'acceptable' resume time
(which for hard RT may just as well rule out some more usual power states)


