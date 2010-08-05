Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab0HEAWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:22:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759387Ab0HEAV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:21:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Thu, 5 Aug 2010 02:20:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100804205654.GA4986@srcf.ucam.org> <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com>
In-Reply-To: <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008050220.51805.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 05, 2010, Arve Hjønnevåg wrote:
> On Wed, Aug 4, 2010 at 1:56 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
> >> On Wednesday, August 04, 2010, Matthew Garrett wrote:
> >> > No! And that's precisely the issue. Android's existing behaviour could
> >> > be entirely implemented in the form of binary that manually triggers
> >> > suspend when (a) the screen is off and (b) no userspace applications
> >> > have indicated that the system shouldn't sleep, except for the wakeup
> >> > event race. Imagine the following:
> >> >
> >> > 1) The policy timeout is about to expire. No applications are holding
> >> > wakelocks. The system will suspend providing nothing takes a wakelock.
> >> > 2) A network packet arrives indicating an incoming SIP call
> >> > 3) The VOIP application takes a wakelock and prevents the phone from
> >> > suspending while the call is in progress
> >> >
> >> > What stops the system going to sleep between (2) and (3)? cgroups don't,
> >> > because the voip app is an otherwise untrusted application that you've
> >> > just told the scheduler to ignore.
> >>
> >> I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
> >> avoid the race (if pm_wakeup_event() is called at 2)).
> >
> > Yes, I think that solves the problem. The only question then is whether
> 
> How? By passing a timeout to pm_wakeup_event when the network driver
> gets the packet or by passing 0. If you pass a timeout it is the same
> as using a wakelock with a timeout and should work (assuming the
> timeout you picked is long enough). If you don't pass a timeout it
> does not work, since the packet may not be visible to user-space yet.

Alternatively, pm_stay_awake() / pm_relax() can be used.

> > it's preferable to use cgroups or suspend fully, which is pretty much up
> > to the implementation. In other words, is there a reason we're still
> 
> I have seen no proposed way to use cgroups that will work. If you
> leave some processes running while other processes are frozen you run
> into problems when a frozen process holds a resource that a running
> process needs.
> 
> 
> > having this conversation? :) It'd be good to have some feedback from
> > Google as to whether this satisfies their functional requirements.
> >
> 
> That is "this"? The merged code? If so, no it does not satisfy our
> requirements. The in kernel api, while offering similar functionality
> to the wakelock interface, does not use any handles which makes it
> impossible to get reasonable stats (You don't know which pm_stay_awake
> request pm_relax is reverting).

Why is that a problem (out of curiosity)?

> The proposed in user-space interface
> of calling into every process that receives wakeup events before every
> suspend call

Well,  you don't really need to do that.

> is also not compatible with existing apps.

Thanks,
Rafael
