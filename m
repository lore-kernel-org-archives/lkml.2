Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0DWPgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:36:24 -0400
Received: from 1wt.eu ([62.212.114.60]:63511 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab0DWPgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:36:22 -0400
Date: Fri, 23 Apr 2010 17:35:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       tglx@linutronix.de, davej@redhat.com, cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Message-ID: <20100423153503.GA14832@1wt.eu>
References: <20100418115949.7b743898@infradead.org> <20100418120346.1b478410@infradead.org> <20100423052439.GB4829@ucw.cz> <20100423053858.GE7798@1wt.eu> <20100423071050.715b3b33@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423071050.715b3b33@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 07:10:50AM -0700, Arjan van de Ven wrote:
> On Fri, 23 Apr 2010 07:38:58 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > On Fri, Apr 23, 2010 at 07:24:39AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > The ondemand cpufreq governor uses CPU busy time (e.g. not-idle
> > > > time) as a measure for scaling the CPU frequency up or down.
> > > > If the CPU is busy, the CPU frequency scales up, if it's idle,
> > > > the CPU frequency scales down. Effectively, it uses the CPU busy
> > > > time as proxy variable for the more nebulous "how critical is
> > > > performance right now" question.
> > > > 
> > > > This algorithm falls flat on its face in the light of workloads
> > > > where you're alternatingly disk and CPU bound, such as the ever
> > > > popular "git grep", but also things like startup of programs and
> > > > maildir using email clients... much to the chagarin of Andrew
> > > > Morton.
> > > > 
> > > > This patch changes the ondemand algorithm to count iowait time as
> > > > busy, not idle, time. As shown in the breakdown cases above,
> > > > iowait is performance critical often, and by counting iowait, the
> > > > proxy variable becomes a more accurate representation of the "how
> > > > critical is performance" question.
> > > 
> > > Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
> > > /dev/null, you'll keep cpu on max frequency. Not a problem for new
> > > core i7, but probably big deal for athlon 64.
> > 
> > So that also means that my notebook's CPU fan will spin like mad as
> > soon as I access a USB key ? 
> 
> unlikely. your notebook CPU will stop its clocks, if not drop its
> voltage, during idle. So during that time the frequency is 0; the only
> difference is in how much leakage you get from a higher voltage
> for those CPUs that do not powergate or drop their cpu in idle.
> Most CPUs that I know of do either or both of that.

OK, I will have to give that a run on my Atom and Pentium-M, both of
which provide me with a very long run on battery precisely because
they almost always run at the lowest possible frequency and voltage.

On the pentium-M, I already know there is a difference between full
voltage and low voltage even when idle. Its lowest frequency is 600
MHz, and my kernel still has the old phc patch to lower clock and
voltage. When idle on this kernel, the fan is completely stopped
and never wakes up. When idle on a 2.6.32 (which does not have the
patch), its voltage doesn't drop though the frequency does, and the
fan runs at 1/4. It also lasts shorter (about 30 min less). So that
means that even when idle there's a noticeable difference.

As was suggested, if the difference appears to be significant, maybe
a /sys tunable would allow all users to select their preferred mode.
Alternatively, we could have two distinct ondemand settings, one for
pure CPU and another one for CPU+I/O.

Regards,
Willy

