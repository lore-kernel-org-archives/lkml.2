Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1DGNAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:00:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20317 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1DGNAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:00:17 -0400
X-SpamScore: -40
X-BigFish: VPS-40(zz9371O542M1dbaL1432N98dK179dNzz1202hzz15d4R8275dhz32i637h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJA9G8-02-H4H-02
X-M-MSG: 
Date: Thu, 7 Apr 2011 15:00:08 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Xu, Andiry" <Andiry.Xu@amd.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110407130008.GX23633@amd.com>
References: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com>
 <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
 <20110407075049.GV23633@amd.com>
 <2DEEA3AB13739D45A22ADDB5086AEA0B01308475@sshaexmb1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2DEEA3AB13739D45A22ADDB5086AEA0B01308475@sshaexmb1.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 05:01:01AM -0400, Xu, Andiry wrote:
> > -----Original Message-----
> > From: Roedel, Joerg [mailto:Joerg.Roedel@amd.com]
> > Sent: Thursday, April 07, 2011 3:51 PM
> > To: Alan Stern
> > Cc: Greg Kroah-Hartman; Sarah Sharp; Xu, Andiry; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; stable@kernel.org
> > Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
> >
> > On Wed, Apr 06, 2011 at 11:16:07AM -0400, Alan Stern wrote:
> > > On Wed, 6 Apr 2011, Joerg Roedel wrote:
> >
> > > The counter really should be a bool: Has the chipset already been
> > > probed or not?  After all, nobody cares how many times this routine was
> > > called.
> > >
> > > > + spin_unlock_irqrestore(&amd_lock, flags);
> > >
> > > This code now contains a bug: You incremented the probe_count _before_
> > > doing the probe.  If another thread calls this routine right now, it
> > > will get an incorrect result.
> > >
> > > Fixing this up should be fairly easy.
> >
> > Hmm, we can get rid of the amd_lock completly if every thread uses the
> > following call-order:
> >
> >       usb_amd_find_chipset_info();
> >       usb_amd_quirk_pll_enable();
> >       usb_amd_quirk_pll_disable();
> >       usb_amd_dev_put();
> >
> 
> The correct order is:
> 
> usb_amd_find_chipset_info();
> usb_amd_quirk_pll_disable();
> usb_amd_quirk_pll_enable();
> usb_amd_dev_put();
> 
> The pair of pll disable and enable may be called for multiple times.

So we could access the data structure without any locks if we want using
atomic_t for the probe_count and isoc_reqs members. But as I've seen
meanwhile the lock still needs to protect the access to the hardware in
the usb_amd_quirk_pll() function.
So its probably not worth the work, what do you think?

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

