Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0EZPiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:38:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56096 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752795Ab0EZPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:38:23 -0400
Date: Wed, 26 May 2010 16:45:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Mickler <florian@mickler.org>
Cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526164514.5f90c677@lxorguk.ukuu.org.uk>
In-Reply-To: <20100526171106.0e44a736@schatten.dmk.lab>
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
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<20100526171106.0e44a736@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not saying that your argument is not valid. But why don't you look
> at suspend blockers as a contract between userspace and kernelspace? An
> Opt-In to the current guarantees the kernel provides in the non-suspend
> case.

It is a contract - but not the right one. You are removing autonomy from
the kernel when only the kernel can measure the full picture and when the
kernel is actually supposed to be responsible for resource management.

> On the other hand, applications can say, they don't need that much
> power and userspace guaranties and not take a suspend blocker.

Even the the model is wrong.

> I don't think opportunistic suspend is a policy decision by the kernel.
> it is something new. Something which currently only the android

Disagree. It's an arbitary and misleading divide that happens to reflect
a specific vendors current phones. Worse yet it may not reflect their own
future products. It assumes for example that their is some power level
that is 'suspend' that is singular, application understood and can be
effectively user space managed. Big assumptions and not ones that seem to
be sensible.

It also breaks another rule - when the hardware changes your application
blocker policies will be wrong. Do you want multiple hand optimised
copies of each app ? Take a look at what happened to CPU designs where
the assumption was you'd recompile the app for each CPU version to get
any useful performance.

If you are instead expressing it as "must be able to respond in time X"
and "must be able to wake up from an event on an active device" then your
interface is generic and hardware independant.

If "bouncing cows" says 'need to wake up every 0.3 seconds" you want the
kernel to decide how best to do that. It will vary by hardware. On todays
desktop PC thats probably a low power state limit. On some current
embedded hardware it might be a special deep sleep mode. On one or two
devices it might be 'suspend'. It might also be that the properties have
been set to 2 seconds already so it gets told it can't have 0.3.

The app cannot be allowed to know platform specific stuff or your
portability comes apart and you end up with a disaster area where each
app only comes on a subset of devices. Express the requirement right and
you get a simple clean interface that continues to work.

Express it wrong and you get a mess.

> userspace implements / supports. If you don't want to suspend while
> looking at the bouncing-cow, you have to take a suspend blocker and
> make yourself a user-visible power-eater, or don't do 

Thats a very big hammer and it doesn't express what I actually want,
which is to allow the cows to run as efficiently as possible.
> 
> echo "opportunistic" > /sys/power/policy 
> 
> in the first place.

But you can do this properly by having a per process idle requirement,
and that can encompass things like hard real time as well (or even
gaming). The suspend blockers break all the global policy, don't solve
real time and don't allow for sensible expansion models. They don't solve
our existing wakeup versus device problems either.

> How does this address the loss of wakeup events while using suspend? 
> (For example the 2 issues formulated by Alan Stern in [1])

In this environment the problem cannot occur in the first place unless
there are kernel code bugs, if there are then they are in GPL code and can
be fixed. But you are mixing up interfaces and implementations which I
find is usually a bad idea. Doing the right thing badly gives you an
interface to an implementation you can later fix. Doing the wrong thing
well leaves you stuck down a hole.

> p.s.: 
> dmk@schatten /usr/src/linux $ grep -r "setpidle" .

Yes I know - no point having a new function which has an in use name is
there ? It's trivial to add per process idling or wakeup requirements.

Alan
