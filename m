Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0E0TNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:13:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41527 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0E0TNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:13:18 -0400
Date: Thu, 27 May 2010 20:13:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527191302.GC5703@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <1274982779.27810.5708.camel@twins> <20100527175719.GD3543@srcf.ucam.org> <1274983333.27810.5744.camel@twins> <20100527181433.GG3543@srcf.ucam.org> <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:03:13PM +0100, Alan Cox wrote:
> > No, it's not. Forced suspend may be in response to hitting a key, but it 
> 
> You are the only person here talking about 'forced' suspends. The rest of
> us are talking about idling down and ensuring we are always in a state we
> un-idle correctly.

Sigh. No. Forced suspend is a fact of life, and suspend blockers improve 
the ability to support it. It's orthogonal to more general runtime PM.

> > may also be in response to a 30 minute timeout expiring. If I get a WoL 
> > packet in the 0.5 of a second between userspace deciding to suspend and 
> > actually doing so, the system shouldn't suspend.
> 
> I don't think that argument holds water in the form you have it
> 
> What about 5 nanoseconds before you suspend. Now you can't do that (laws
> of physics and stuff).

Drivers should enable wakeups before they disable interrupts. So either 
the packet hits the IRQ handler and the driver takes a suspend block 
(aborting suspend in the process) or it doesn't, the GPE goes high and 
the system resumes immediately after entering S3.

> 	Set wake flags
> 	Check if idle
> 	If idle
> 		Suspend
> 	else
> 		Clear wake flags
> 		Unwind
> 
> and the wake flags guarantee that an event at any point after the wake
> flags are set until they are cleared will cause a suspend to be resumed,
> possibly immediately after the suspend.

Exactly. So the 5 nanosecond case is already handled. The interesting 
case is where userspace makes the decision to go to sleep and starts 
performing various housekeeping tasks before triggering the suspend. You 
need some way to abort that suspend. The hardware may be long idle by 
then, so you can't just look at the hardware state.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
