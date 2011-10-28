Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1J1TCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:02:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:19221 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab1J1TCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="68670885"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
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
Date: Fri, 28 Oct 2011 12:02:15 -0700
Subject: RE: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Thread-Topic: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Thread-Index: AcyVoCuHRgFmkSl8Sm6cAdjDp6569gAAji9w
Message-ID: <987664A83D2D224EAE907B061CE93D5301F2030C4F@orsmsx505.amr.corp.intel.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
 <20111028183347.GE3452@redhat.com>
In-Reply-To: <20111028183347.GE3452@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It ain't pretty but it moves things towards a more reliable message dump.
> The odds of us needing to bust the spinlocks are really small.  Most of
> the time no one reads the pstore filesystem.

Does it really change the odds much?  As you say, the common case is that
pstore front-end doesn't have the lock held - so that case is unchanged.
We can get the lock anyway, we don't need to bust it.

Looking at the uncommon case where the lock is held - that means that
pstore was in the middle of some back-end operation. Busting the lock
means that the back-end will be surprised by being called again when the
first operation had not yet completed. In the case of a state machine
driven back end like ERST, I don't think this has a high probability of
working out well.

So you might be moving the needle from 99.999% chance of saving to pstore
with 0.001% chance of hanging on the spin lock. to 99.9991% chance of
saving, and 0.0009% chance of something highly weird happening in the
back-end driver because you busted the lock and called it anyway.

> I would love to figure out a prettier solution for this locking mess, but
> I can't think of anything.  We have customers who want to utilize this
> technology, so I am trying to make sure it is stable and robust for now.
> A little selfish I suppose.  But we are open to ideas?

If a prettier solution is needed - it will have to involve the back-end.
Perhaps a whole separate write/panic path (with separate buffer). Then
a sufficiently smart back end could do the right thing. I have little
confidence that ERST could be made smart in this way, because almost all
of the heavy lifting is done by the BIOS - so Linux has no way to influence
the flow of execution.

-Tony
