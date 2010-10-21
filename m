Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0JUPpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:45:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0JUPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:45:53 -0400
Date: Thu, 21 Oct 2010 17:45:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101021154543.GD21695@basil.fritz.box>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101011212006.GB23882@redhat.com>
 <1287555157.3026.21.camel@yhuang-dev>
 <20101020141558.GB19090@redhat.com>
 <1287623643.19320.40.camel@yhuang-dev>
 <20101021023135.GA12086@redhat.com>
 <1287638251.19320.190.camel@yhuang-dev>
 <20101021141002.GI19090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021141002.GI19090@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:10:02AM -0400, Don Zickus wrote:
> On Thu, Oct 21, 2010 at 01:17:31PM +0800, Huang Ying wrote:
> > > > But there is some general rules for unknown NMI. We think unknown NMI is
> > > > hardware error notification on all systems except systems with broken
> > > > hardware or software bugs, stone age machines. Do you agree with that?
> > > 
> > > Nope.  In my experiences, most of our customers are still running
> > > pre-Nehalem boxes, therefore most unknown NMIs are from broken hardware or
> > > bad firmware (at least in the bugzillas I deal with).
> > 
> > It seems that we have different point of view for reason of unknown NMI.
> > Should broken hardware be seen as hardware error?
> 
> Well, do you have an alternative way to handle broken hardware?  Broken
> hardware has generated NMIs, sometimes if I am lucky SERRs.  The ones that
> generate SERRs can be filtered through a different path, but what about
> the ones that don't?
> 

Don, AFAIK you're saying the same thing as Ying: an unknown NMI is 
a hardware error.

The reason the hardware does that is that it wants to tell us:

"I lost track of an error. There is corrupted data somewhere in the system.
Please stop, don't do anything that could consume that data. S.O.S."

The correct answer for that is panic.

The only problem we're trying to solve here is to distingush
other cases, like when software uses NMIs for something else
or there may be other cases

> > 
> > As far as I know, Windows treat unknown NMI as hardware errors. Although
> > we are programming for Linux not Windows. Many hardware are built for
> > Windows.
> 
> I was told Windows treats _any_ NMI as hardware errors, not just unknown
> ones. :-)

I don't know details about Windows' code here, but I assume that 
they have a way to hook into the NMI too, otherwise drivers like the HP
watchdog wouldn't work on Windows. But yes we know they shut down.

Essentially the hardware (and the BIOS) is designed 
under the assumption that the OS behaves like Windows for this.

In my long experience in making Linux work on all kinds
of hardware I learned very firmly that trying to drive PC hardware 
in a different way than Windows does is usually a bad idea.

The approach of Ying's patch kit was really to make
the behaviour more like Windows.


> Probably.  I guess I don't fully understand your definition of hardware
> error notification so I can't tell if we are arguing or agreeing (but
> using different words).
> 
> How do you envision the code looking like with hardware error
> notification?
> 
> I just wanted to keep the code in traps.c simple and clean and not
> constantly add new #ifdefs every time Intel came up with an interesting
> way to determine a hardware error condition.
> 
> For example, I am not the biggest fan of seeing stuff like edac or mce
> inside the code and would prefer them to use notifiers.  But that is just
> my opinion.

mce is only for testing anyways, "real" mce doesn't need vector 0.
So basically it's just a fancy "smp_call_nmi()" thingy.

EDAC shouldn't need it either, if it's does it's some probably
broken legacy behaviour.

> If you have a framework that you wanted to propose that could encapsulate
> an ever growing class of hardware error notifications, I would be
> interested

The trend in error reporting is away from NMIs and towards machine checks.
My bunch is that NMI reporting is more or less a legacy problem, so we have
to deal with what is there today.

I don't think you need to worry about a lot more hardware NMI sources.

The only thing that we need to worry about is more software NMI sources,
these unfortunately like to multiply.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
