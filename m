Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1AKDkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:40:25 -0500
Received: from kroah.org ([198.145.64.141]:41665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1AKDjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:39:54 -0500
Date: Mon, 10 Jan 2011 19:37:17 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/4] pci, usb:  Make usb handoff func all take base
 remapping
Message-ID: <20110111033717.GD9709@kroah.com>
References: <4D2A1382.7010407@kernel.org>
 <4D2AC6BF.3010907@kernel.org>
 <4D2BA8FE.9090204@kernel.org>
 <4D2BAA75.60001@kernel.org>
 <20110111010714.GB32585@kroah.com>
 <4D2BB048.2050509@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2BB048.2050509@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 05:20:08PM -0800, Yinghai Lu wrote:
> On 01/10/2011 05:07 PM, Greg KH wrote:
> > On Mon, Jan 10, 2011 at 04:55:17PM -0800, Yinghai Lu wrote:
> >>
> >> So later could reuse them to do usb handoff much early for x86.
> >>
> >> will make arch early code get MMIO BAR and do remapping itself.
> >>
> >> -v2: still keep pci_device *pdev as parameter according to BenH.
> >> -v3: expose three functions that take *base instead of including .c file.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  drivers/usb/host/pci-quirks.c |  195 ++++++++++++++++++++++++------------------
> >>  drivers/usb/host/pci-quirks.h |    6 +
> >>  2 files changed, 120 insertions(+), 81 deletions(-)
> >>
> >> Index: linux-2.6/drivers/usb/host/pci-quirks.c
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/usb/host/pci-quirks.c
> >> +++ linux-2.6/drivers/usb/host/pci-quirks.c
> >> @@ -17,6 +17,19 @@
> >>  #include "pci-quirks.h"
> >>  #include "xhci-ext-caps.h"
> >>  
> >> +static void default_usb_handoff_udelay(unsigned long usecs)
> >> +{
> >> +	udelay(usecs);
> >> +}
> >> +
> >> +static void __devinit default_usb_handoff_msleep(unsigned long msecs)
> >> +{
> >> +	msleep(msecs);
> >> +}
> > 
> > What?
> > 
> > Why in the world would you not just call the real functions here?
> > That's not acceptable, sorry.
> 
> for early access, can not use udelay yet, it will take some one.

Then don't use it.

> Also msleep will cause crash, because it needs scheduler there.

Also, don't use it.

> >> +
> >> +void (*usb_handoff_udelay)(unsigned long) = default_usb_handoff_udelay;
> >> +void (*usb_handoff_msleep)(unsigned long) __devinitdata =
> >> +			default_usb_handoff_msleep;
> 
> or do you mean use ..
> +void (*usb_handoff_udelay)(unsigned long) = udelay;
> +void (*usb_handoff_msleep)(unsigned long) __devinitdata =
> +			msleep;

Yes, only if I could understand _why_ you are doing such a thing, when
you do have access to these function pointers anyway, right?

confused,

greg k-h
