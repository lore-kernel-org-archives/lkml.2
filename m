Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1I1N5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab1I1N5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:57:41 -0400
Date: Wed, 28 Sep 2011 09:57:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Message-ID: <20110928135727.GQ5795@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
 <20110927175919.GK5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 12:02:38PM -0700, Luck, Tony wrote:
> > Ok.  Do we care?  I assumed the panic data would be more
> > relevant/interesting than whatever pstore was doing before (like loading
> > previous log files).
> 
> Yes we care - saving panic data is most likely the single most important
> thing that pstore does.  I just have severe doubts that it will actually
> save anything useful if we just blindly continue if we can't get the lock.

Well, I was trying to imply that any pre-panic info is uninteresting.  It
is the panic/NMI stuff that should be top priority, worthy of busting the
spin lock.

> 
> What actually happens next will be dependent on the back-end. For
> the state machine in ERST, one possible outcome is a hang. For many
> people a hang is considered worse than a panic.

That should be up to the backend, no?  ERST has two modes, only one which
has a state machine.  The other is NVRAM which can probably handle
simultaneous writes.  And I believe the EFI back-end can handle that as
well.  That is why I was suggesting that the back-end return a failure.

> 
> > I assumed we are just overwriting the buffer with the current data, so
> > unless the other cpu is chugging along while this cpu is in panic, the new
> > data shouldn't get corrupted, no?
> 
> I really have no idea what *will* happen.  Lots of things are possible, only
> some of them are desirable.

My concern here is that if someone is just toying with pstore,
writing/reading data or even just poking at it to see what is going on
with the system, they may accidentally block real system errors or panics
from properly logging.  That doesn't seem right.

Cheers,
Don
