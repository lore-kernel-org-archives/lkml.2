Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0KCVEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:04:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51053 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932139Ab0KCVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:04:45 -0400
Date: Wed, 3 Nov 2010 17:04:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: pali.rohar@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit
 3df7169e7
In-Reply-To: <4CD1A7F6.2020504@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1011031647140.15616-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010, Larry Finger wrote:

> Following commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b, my logs are spammed
> with messages of the form "hub 2-0:1.0: unable to enumerate USB device on
> port 5".
> 
> Experimentation has shown that if the functional state bits of the control
> register are preserved in the fixup, then the messages no longer appear.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Pali,
> 
> Is it possible for you to test this patch to ensure that it does not interfere
> with the fix for the shutdown problem.
> 
> Thanks,
> 
> Larry
> ---
> 
> Index: linux-realtek/drivers/usb/host/pci-quirks.c
> ===================================================================
> --- linux-realtek.orig/drivers/usb/host/pci-quirks.c
> +++ linux-realtek/drivers/usb/host/pci-quirks.c
> @@ -35,6 +35,7 @@
>  #define OHCI_INTRENABLE		0x10
>  #define OHCI_INTRDISABLE	0x14
>  #define OHCI_OCR		(1 << 3)	/* ownership change request */
> +#define OHCI_CTRL_HCFS		(3 << 6)	/* functional state */
>  #define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
>  #define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
>  #define OHCI_INTR_OC		(1 << 30)	/* ownership change */
> @@ -184,7 +185,7 @@ static void __devinit quirk_usb_handoff_
>  #ifdef __hppa__
>  #define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_IR)
>  #else
> -#define	OHCI_CTRL_MASK		OHCI_CTRL_RWC
> +#define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_HCFS)
> 
>  	if (control & OHCI_CTRL_IR) {
>  		int wait_time = 500; /* arbitrary; 5 seconds */

This patch is definitely wrong -- it defeats the entire purpose of 
rewriting the control register!  That write was added _specifically_ to 
put the controller into reset, i.e., to change the functional state.

Furthermore, the write does the same thing as ohci_hcd.c does in its
ohci_usb_reset() routine.  Regardless, ohci_run() does a complete host
controller reset, which should override anything done in pci-quirks.c.  
Perhaps _that_ routine needs some attention.

Alan Stern

