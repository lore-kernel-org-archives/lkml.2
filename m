Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0C2Q0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:26:41 -0400
Received: from lucidpixels.com ([75.144.35.66]:59967 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab0C2Q0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:26:39 -0400
Date: Mon, 29 Mar 2010 12:26:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <Pine.LNX.4.44L0.1003291116240.1680-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1003291224170.27175@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003291116240.1680-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Mar 2010, Alan Stern wrote:

> On Mon, 29 Mar 2010, Justin Piszcz wrote:
>
> What about the "registers" file?
Here it is (after I plugged it back in)

bus pci, device 0000:00:0b.0
OHCI Host Controller
ohci_hcd
OHCI 1.0, NO legacy support registers
control 0x68f RWE RWC HCFS=operational IE PLE CBSR=3
cmdstatus 0x00000 SOC=0
intrstatus 0x00000020 FNO
intrenable 0x8000004e MIE RHSC RD SF WDH
ed_controlhead 7bef1b90
hcca frame 0x4657
fmintvl 0xa7782edf FIT FSMPS=0xa778 FI=0x2edf
fmremaining 0x80002b76 FRT FR=0x2b76
periodicstart 0x2a2f
lsthresh 0x0628
hub poll timer off
roothub.a 01000208 POTPGT=1 NPS NDP=8(8)
roothub.b 00000000 PPCM=0000 DR=0000
roothub.status 00008000 DRWE
roothub.portstatus [0] 0x00000100 PPS
roothub.portstatus [1] 0x00000100 PPS
roothub.portstatus [2] 0x00000100 PPS
roothub.portstatus [3] 0x00000100 PPS
roothub.portstatus [4] 0x00000303 LSDA PPS PES CCS
roothub.portstatus [5] 0x00000303 LSDA PPS PES CCS
roothub.portstatus [6] 0x00000100 PPS
roothub.portstatus [7] 0x00000100 PPS

> This all looks normal.  It's possible that we've been looking for the
> bug in the wrong place; maybe there's nothing wrong with the OHCI
> controller.
>
> So next you should get a usbmon trace showing what happens on bus 2
> when one of these mouse failures occurs.  Instructions for usbmon are
> in Documentation/usb/usbmon.txt.
>
> At the same time, just to be increase my level of certainty, you should
> apply the following debugging patch for ohci-hcd.  Let's see both the
> usbmon trace and the dmesg log for the same event.  The trace and the
> debugging patch will generate plenty of output during normal operation,
> but don't worry about that.  Only the part starting from shortly before
> the mouse quits really matters.
Yes, I've done this before for a bug in the Intel USB controller (P55) on
another motherboard.. Should be doable, always funny though how it does not
happen when you are trying to make it happen.

For your patch, what does this patch against? It does not apply cleanly
for 2.6.33.

>
> Alan Stern
>
>
> Index: usb-2.6/drivers/usb/host/ohci-hcd.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ohci-hcd.c
> +++ usb-2.6/drivers/usb/host/ohci-hcd.c
> @@ -290,6 +290,8 @@ static int ohci_urb_dequeue(struct usb_h
> 		 */
> 		urb_priv = urb->hcpriv;
> 		if (urb_priv) {
> +			ohci_info(ohci, "start unlink urb %p, ed %p\n",
> +					urb, urb_priv->ed);
> 			if (urb_priv->ed->state == ED_OPER)
> 				start_ed_unlink (ohci, urb_priv->ed);
> 		}
> @@ -324,6 +326,9 @@ ohci_endpoint_disable (struct usb_hcd *h
>
> 	if (!ed)
> 		return;
> +	ohci_info(ohci, "disable ed %p (#%02x) state %d%s\n",
> +			ed, ep->desc.bEndpointAddress, ed->state,
> +			list_empty(&ed->td_list) ? "" : " (has tds)");
>
> rescan:
> 	spin_lock_irqsave (&ohci->lock, flags);
> @@ -770,6 +775,10 @@ static irqreturn_t ohci_irq (struct usb_
> 		return IRQ_HANDLED;
> 	}
>
> +	ohci_info(ohci, "int %x enable %x rm_list %p\n", ints,
> +			ohci_readl(ohci, &regs->intrenable),
> +			ohci->ed_rm_list);
> +
> 	/* We only care about interrupts that are enabled */
> 	ints &= ohci_readl(ohci, &regs->intrenable);
>
>
