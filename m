Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0JVKPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:15:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55911 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab0JVKPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:15:16 -0400
From: "Kamoolkar, Mugdha" <mugdha@ti.com>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "Kamat, Nishant" <nskamat@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Anna, Suman" <s-anna@ti.com>, Simon Que <sque@ti.com>
Date: Fri, 22 Oct 2010 15:44:55 +0530
Subject: RE: [PATCH 3/3] omap: add hwspinlock device
Thread-Topic: [PATCH 3/3] omap: add hwspinlock device
Thread-Index: ActwjBYZ42+jyHUzT/m0HqnV96vz7gAbk0dwAAfwZmAALW7XoA==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593023458C2DC@dbde02.ent.ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com>
 <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com>
 <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com>
 <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <B85A65D85D7EB246BE421B3FB0FBB5930233F94602@dbde02.ent.ti.com>
 <8F7AF80515AF0D4D93307E594F3CB40E6E0DD10A@dlee03.ent.ti.com>
In-Reply-To: <8F7AF80515AF0D4D93307E594F3CB40E6E0DD10A@dlee03.ent.ti.com>
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

Hari,

> -----Original Message-----
> From: Kanigeri, Hari
> Sent: Thursday, October 21, 2010 5:56 PM
> To: Kamoolkar, Mugdha; 'Ohad Ben-Cohen'; Kevin Hilman; Krishnamoorthy,
> Balaji T; Kamat, Nishant
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; akpm@linux-foundation.org; Greg KH;
> Tony Lindgren; Cousson, Benoit; Grant Likely; Anna, Suman; Simon Que
> Subject: RE: [PATCH 3/3] omap: add hwspinlock device
> 
> Mugdha,
> 
> > > >>
> > > >> This does not require any smart IPC and it will allow us to get
> > > rid of
> > > >> the omap_hwspinlock_request_specific() API and its early-
> callers
> > > >> requirement.
> > > >
> > > > Yes, that would indeed simplify things.
> > >
> > > Balaji, Nishant, are you OK with this ?
> > >
> > The problem with this approach is that the i2c driver would have to
> > sync up on the shared memory location that it uses to share the
> > information of the spinlock ID. What location would this be? How
> would
> > the i2c driver on the m3 know about this location? Does this mean
> > hard-coding of the shared memory address? If yes, then there would
> be
> > an impact to users if they wanted to change their memory map. Any
> kind
> > of hard-coding of this sort can be painful in such cases, especially
> > if it happens in multiple drivers. On the other hand, hard-coding
> > (reserving) spinlock IDs is a much safer option and does not impact
> > anything else.
> >
> 
> We can avoid the hard-coding of shared memory location if I2C Driver
> maps using iommu some dynamic memory for shared memory location to M3
> virtual address and shares this information to I2c driver counter-part
> on M3 using the IPC call. But this might not be trivial and this would
> be against what Ohad mentioned about not requiring any smart IPC :).
> I prefer hard-coding of spinlock id to keep things simple.
> 
I also considered this, and had the same issue with it as what you 
mentioned above, that the virtual address for the i2c driver on m3 needs 
to be known to the Linux driver. This could potentially be taken in 
through kconfig, because there's no harm in fixing virtual maps for the 
slaves. The problem is in fixing physical memory regions. Note that this 
assumes presence of a slave MMU. In case slave MMU is not present, the 
physical address needs to be taken in through kconfig, which makes 
rearranging the memory map a virtual nightmare if multiple drivers start 
doing such things.

We do need to consider the possibility that in future there might be 
even more multi-core drivers which not only need hw spinlocks, but also 
need notifications and some shared memory to do their work effectively. As shared peripherals increase, this is a very likely possibility.
So I do believe that any effort we put on fixing this the right way 
needs to take into account all three (hw spinlocks, ipc interrupts and 
shared memory). That's of course, out of the scope of this hw spinlock 
patch, but more in the scope of syslink discussions at LPC.

> Thank you,
> Best regards,
> Hari
