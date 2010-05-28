Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0E1WKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:10:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54274 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab0E1WK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:10:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Sat, 29 May 2010 00:11:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com> <1275032623.32462.30.camel@laptop>
In-Reply-To: <1275032623.32462.30.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005290011.32543.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 17:45 -0700, Arve Hjønnevåg wrote:
> > What happens if the user presses the button right before you set QoS
> > of 'user apps' to  QS_NONE?
> > To me it looks like this solution would result in this sequence which
> > may ignore the button press:
> >         Button pushed
> >         Button driver sets QoS of app it wakes to QS_ABOVESUSPEND
> >         Set QoS of 'user apps' to QS_NONE 
> 
> I don't think we should change app QoS parameters, but change service
> provider parameters.
> 
> For instance, suppose the filesystem-IO QoS has 3 levels: 
>   High, Normal and Idle.
> 
> Then if we assign Idle to updatedb, we'll service it as long as the
> filesystem-server QoS has a higher level (High and Normal). When we
> change the filesystem-serves' QoS to idle, it finds there is nothing to
> keep it servicing stuff and it'll block pending requests, updatedb stops
> being runnable and we're good.

Yeah, that's what I was thinking.  It would be nice to have a mechanism that
would prevent tasks from being runnable in specific conditions (not necessarily
related to power management even).

Having reconsidered the suspend blockers idea I came to the conclusion that
in fact it was a workaround for three different problems.

The first one was that we couldn't power manage I/O devices at run time and
the only way to put them into low-power states was to carry out full system
suspend.  That's changed with the introduction of the runtime PM framework,
but the situation is still not ideal, because in general there's no connection
between the idle infrastructure and runtime PM.

This IMO is the second problem worked around by suspend blockers.
Namely, it generally would be nice to suspend I/O devices when CPUs are idle
for a sufficiently long time.  For this to work, there should be a way to
register a device with the idle framework so that it can tell the device's
driver to suspend the device when it makes sense.  Something like
<vague idea>idle_register_device(dev, t), where t means "suspend that
device after all CPUs have been idle for time t", so basically the idle
framework will only need to run pm_schedule_suspend(dev, t) for that device
right before idling the last CPU</vague idea>.

The third problem is exactly that on Android system there are (or at least
there may be) tasks that in specific situations should not be regarded as
runnable at all and currently there's no way to ensure they won't run other
than going to a full suspend.

If we could address these issues somehow, I think suspend blockers would not be
necessary for maximizing battery life (well, there are some technical details
like automatic going to full suspend when the CPUs and I/O have  been idle for
sufficiently long etc., but they all seem to be tractable).

[And there's a problem of periodic timers that trigger too often, but I think
that's just a general issue that need to be fixed anyway.]

Thanks,
Rafael
