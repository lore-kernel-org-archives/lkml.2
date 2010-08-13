Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874Ab0HMRLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 13:11:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab0HMRLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 13:11:44 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
From: James Bottomley <James.Bottomley@suse.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, david@lang.hm, Theodore Tso <tytso@mit.edu>,
        peterz@infradead.org, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org, galibert@pobox.com, florian@mickler.org,
        menage@google.com, linux-pm@lists.linux-foundation.org,
        swmike@swm.pp.se, tglx@linutronix.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
In-Reply-To: <AANLkTikN2zKcLtFJ6EdBU=iqT78bZKt_rKQoPNBRXJHj@mail.gmail.com>
References: <20100812010612.GL2516@linux.vnet.ibm.com>
	 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	 <20100812034435.GA7403@linux.vnet.ibm.com>
	 <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	 <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	 <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	 <20100812174303.GD2524@linux.vnet.ibm.com>
	 <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	 <20100813152254.GD2511@linux.vnet.ibm.com>
	 <AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com>
	 <20100813155738.GA11507@isilmar-3.linta.de>
	 <AANLkTikN2zKcLtFJ6EdBU=iqT78bZKt_rKQoPNBRXJHj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 13:11:29 -0400
Message-ID: <1281719489.8407.17.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 19:19 +0300, Felipe Contreras wrote: 
> On Fri, Aug 13, 2010 at 6:57 PM, Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> >> >> Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
> >> >> user-space seems to be having this problem. I can argue to you that
> >> >> this problem can be solved in easier ways, but instead I will argue
> >> >> that perhaps we should wait for somebody besides Android to complain
> >> >> about it before providing a "solution". Because after all, what good
> >> >> is a "solution" provided by the kernel, if the user-space is not going
> >> >> to use it, ever.
> >> >
> >> > At this point in the discussion, I am quite prepared to believe that you
> >> > will avoid using suspend blockers, and that you will further do everything
> >> > in your power to prevent anyone else from using suspend blockers.  ;-)
> >>
> >> I'm not tying anybody's hands.
> >>
> >> How are people using real-time linux if it's not on mainline? Well,
> >> duuh, you apply the patches. If say Fedora was interested on it, they
> >> could apply the patches, and see for themselves. People do that all
> >> the time, with the mm tree, with Con Koliva's patches, etc. Once
> >> people are happy with the results, things get merged. Why should this
> >> be any different?
> >
> > Because millions of users are happy -- with Android, including suspend
> > blockers.
> 
> I explicitly said somebody besides Android, specifically, somebody
> with a typical linux ecosystem. You are not addressing the argument at
> hand, that nobody else wants to tackle the issue this way, thus only
> making the discussion more difficult.

Can we stop arguing about the pointless?

The facts are that suspend blockers identifies a race within our suspend
to ram system that permeates from top to bottom (that's from server to
mobile).  The problem is that resume events are racy with respect to
suspend and vice versa.  This manifests itself most annoyingly on my
laptop in the "double suspend" case: where I suspend with a pending
suspend event, my laptop will resume and then immediately re-suspend
(leading me to kick myself and remind myself to check it stayed up
before pushing unsuspend and walking away).  The other annoying case is
that if I accidentally close the lid before presenting, I have to wait
until the system is fully down before pressing resume.

In a Data Centre controlling power, if you sent a suspend then a wake on
lan, there's a window where the machine will still be down (because the
wol got ignored).

There are easy fixes to all the above ... I should wait to verify
suspend and resume in my laptop and I have to accept the wait time
between the two.  In the data centre, you just repeat your power control
commands a few times with about 5s between them and so on.

The simple hacky work arounds mean that a user space invasive solution
like suspend blockers is a bit of a non starter as a solution to the
general case.  However, it has shown that we do have a problem and
furthermore it's a problem encountered by more than android.

The technical problem with suspend blockers is that they're a solution
to a general problem that only works for a specific case.  What we're
searching for is a general solution that can also be used in the android
specific case.

So far, we have three possibilities:

     1. Stubs with deprecation - this has been rejected by android, so
        looks like a non starter.
     2. update pm_qos so that the suspend blocks become qos constraints.
        This may or may not be coupled with a user space suspend
        manager, but in the latter case it's essentially full suspend
        blockers (with the additional opportunistic suspend kernel code)
        but with information systems outside of android can use.
     3. Rafael's patch that makes it possible to avoid the races between
        wakeup and suspend.  This requires a user space suspend manager

(There's a whole other load of implementation details like stats and the
like, but the above is the concept view).

Unless anyone has something substantive to add to either the problem
space or the solution space, the android discussion piece of this thread
has degenerated to pure noise.

James


