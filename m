Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1JQO2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:28:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51712 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab1JQO2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:28:48 -0400
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Date: Mon, 17 Oct 2011 16:28:27 +0200
In-Reply-To: <20111017141147.GA14581@srcf.ucam.org>
References: <20111014154348.ae6267aa.akpm@linux-foundation.org>
	 <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
	 <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com>
	 <1318837019.6594.29.camel@twins> <alpine.LFD.2.02.1110171119580.3240@ionos>
	 <20111017124647.GA12838@srcf.ucam.org> <1318856786.4172.22.camel@twins>
	 <20111017141147.GA14581@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318861707.4172.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 15:11 +0100, Matthew Garrett wrote:
> On Mon, Oct 17, 2011 at 03:06:26PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-10-17 at 13:46 +0100, Matthew Garrett wrote:
> > > They're orthogonal. Sometimes you want timer-driven behaviour (how else 
> > > are you going to draw animations?) and that's obviously going to 
> > > generate wakeups. This is for the idle case, where the user is no longer 
> > > sitting in front of the machine but you don't want to trigger a full 
> > > system suspend. We either need every application that ever uses 
> > > timer-driven behaviour to support setting its own timer slack on some 
> > > sort of external policy decision, or we need a way to let the kernel 
> > > force them to.
> > 
> > No!! you want that application to stop drawing stuff that is invisible.
> > Setting your own timerslack for something you know is pointless is worse
> > than doing something pointless, its down right stupid.
> 
> Whether or not you want the animation to carry on animating is policy, 
> and you need something to be the policy agent. Let's say firefox is 
> invisible. I now grab a copy of its window contents. What do I get?

An XDamage and repaint from the X client, after which your copy will
complete and you get what you asked for?

> > Please, work with the X folks and make it an error to draw to invisible
> > surfaces. And yes, I know that composition makes that a non-trivial
> > problem. But at least the blank screen case should be trivial, and I
> > suspect there's more tractable cases as well. Mostly the desktop is
> > still a very static place and a few extra timer ticks for when you're
> > spinning your desktop cube around isn't going to be a problem.
> 
> So, just to be clear on this, you want to change the semantics of X and 
> modify every piece of userspace that currently uses X (because it'll now 
> otherwise crash when the screen blanks)

Or even when I minimize firefox. That said, ff will probably crash as
soon as I open a second tab because the retarded thing will very likely
continue animating everything on the invisible tab anyway.

You could start by making the X lib of the day, is that XCB these days?,
issue an error print (you get plenty of those anyway) and progress to
full on crashing later.

This gives developers a migration window and incentive to fix up their
apps.

>  in preference to merging a piece 
> of code that's functionally consistent with the rest of the cgroups 
> infrastructure?

Yep.. because as of yet there isn't a sane use-case to warrant adding
the maintenance burden. Any cgroup controller is functionally
consistent, per definition, that doesn't make it useful or even sane.
