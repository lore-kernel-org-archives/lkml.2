Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab1J1UB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:01:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab1J1UBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:01:25 -0400
Date: Fri, 28 Oct 2011 16:00:50 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Message-ID: <20111028200050.GF3452@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
 <20111028183347.GE3452@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301F2030C4F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301F2030C4F@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 12:02:15PM -0700, Luck, Tony wrote:
> > It ain't pretty but it moves things towards a more reliable message dump.
> > The odds of us needing to bust the spinlocks are really small.  Most of
> > the time no one reads the pstore filesystem.
> 
> Does it really change the odds much?  As you say, the common case is that
> pstore front-end doesn't have the lock held - so that case is unchanged.
> We can get the lock anyway, we don't need to bust it.

Agreed.

> 
> Looking at the uncommon case where the lock is held - that means that
> pstore was in the middle of some back-end operation. Busting the lock
> means that the back-end will be surprised by being called again when the
> first operation had not yet completed. In the case of a state machine
> driven back end like ERST, I don't think this has a high probability of
> working out well.

Remember ERST has two modes, state machine and NVRAM.  The state machine
will have issues, but the NVRAM part (which isn't implemented yet) might
not.  Not sure about EFI. But shouldn't the backend determine that, not pstore?

> 
> So you might be moving the needle from 99.999% chance of saving to pstore
> with 0.001% chance of hanging on the spin lock. to 99.9991% chance of
> saving, and 0.0009% chance of something highly weird happening in the
> back-end driver because you busted the lock and called it anyway.

Sure.  But at the same time, APEI is one of those 'value add' by OEMs.  If
you are paying $20K for this feature, wouldn't you expect this feature to
work 100% of the time?  At least with kdump/netdump, you can say, hey it
was free so you get what you pay for.

I guess it would help if we had more machines with working firmware to
test this.

> 
> > I would love to figure out a prettier solution for this locking mess, but
> > I can't think of anything.  We have customers who want to utilize this
> > technology, so I am trying to make sure it is stable and robust for now.
> > A little selfish I suppose.  But we are open to ideas?
> 
> If a prettier solution is needed - it will have to involve the back-end.
> Perhaps a whole separate write/panic path (with separate buffer). Then
> a sufficiently smart back end could do the right thing. I have little
> confidence that ERST could be made smart in this way, because almost all
> of the heavy lifting is done by the BIOS - so Linux has no way to influence
> the flow of execution.

Sadly I agree.

Perhaps I have been hanging around mjg too much, but I little confidence
in anything ACPI related being smart.

I don't have that much motivation to push this patch very hard.  I just
saw some a theoretical issue and thought I could help Seiji solve it.  I
am more interested in getting the first patch of this series in than this one.

If you find this patch adds more complexity for very little gain, so be
it.  We tried. :-)

Cheers,
Don
