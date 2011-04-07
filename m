Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1DGHvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:51:00 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:18623
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab1DGHu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:50:58 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432N98dK179dNzz1202hzz15d4Rz32i637h668h839h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ9V4Q-02-80P-02
X-M-MSG: 
Date: Thu, 7 Apr 2011 09:50:49 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110407075049.GV23633@amd.com>
References: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com>
 <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104061110251.1907-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:16:07AM -0400, Alan Stern wrote:
> On Wed, 6 Apr 2011, Joerg Roedel wrote:

> The counter really should be a bool: Has the chipset already been
> probed or not?  After all, nobody cares how many times this routine was 
> called.
> 
> > +	spin_unlock_irqrestore(&amd_lock, flags);
> 
> This code now contains a bug: You incremented the probe_count _before_
> doing the probe.  If another thread calls this routine right now, it
> will get an incorrect result.
> 
> Fixing this up should be fairly easy.

Hmm, we can get rid of the amd_lock completly if every thread uses the
following call-order:

	usb_amd_find_chipset_info();
	usb_amd_quirk_pll_enable();
	usb_amd_quirk_pll_disable();
	usb_amd_dev_put();

In that case we can just change the probe_count and isoc_reqs into
atomic_t with some care and should be fine, no?
Problem is that I don't know if the above call-order is guaranteed.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

