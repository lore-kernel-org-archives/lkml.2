Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab1DGJBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:01:12 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:11924
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab1DGJBI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:01:08 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz9371O542M1432N98dK4015L179dNzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ9YDR-01-B3D-02
X-M-MSG: 
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Date: Thu, 7 Apr 2011 17:01:01 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0B01308475@sshaexmb1.amd.com>
In-Reply-To: <20110407075049.GV23633@amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Thread-Index: Acv0+IXrV8JzEf++QemrmdDL30QaFwAB83PA
References: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com> <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org> <20110407075049.GV23633@amd.com>
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
X-OriginalArrivalTime: 07 Apr 2011 09:00:59.0967 (UTC) FILETIME=[5082A4F0:01CBF502]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Roedel, Joerg [mailto:Joerg.Roedel@amd.com]
> Sent: Thursday, April 07, 2011 3:51 PM
> To: Alan Stern
> Cc: Greg Kroah-Hartman; Sarah Sharp; Xu, Andiry;
linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; stable@kernel.org
> Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
> 
> On Wed, Apr 06, 2011 at 11:16:07AM -0400, Alan Stern wrote:
> > On Wed, 6 Apr 2011, Joerg Roedel wrote:
> 
> > The counter really should be a bool: Has the chipset already been
> > probed or not?  After all, nobody cares how many times this routine
was
> > called.
> >
> > > +	spin_unlock_irqrestore(&amd_lock, flags);
> >
> > This code now contains a bug: You incremented the probe_count
_before_
> > doing the probe.  If another thread calls this routine right now, it
> > will get an incorrect result.
> >
> > Fixing this up should be fairly easy.
> 
> Hmm, we can get rid of the amd_lock completly if every thread uses the
> following call-order:
> 
> 	usb_amd_find_chipset_info();
> 	usb_amd_quirk_pll_enable();
> 	usb_amd_quirk_pll_disable();
> 	usb_amd_dev_put();
> 

The correct order is:

usb_amd_find_chipset_info();
usb_amd_quirk_pll_disable();
usb_amd_quirk_pll_enable();
usb_amd_dev_put();

The pair of pll disable and enable may be called for multiple times.

Thanks,
Andiry

