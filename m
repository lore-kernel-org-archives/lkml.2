Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0C3SCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:02:07 -0400
Received: from lucidpixels.com ([75.144.35.66]:39860 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab0C3SCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:02:05 -0400
Date: Tue, 30 Mar 2010 14:02:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <Pine.LNX.4.44L0.1003301329160.1634-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1003301356150.5415@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003301329160.1634-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Mar 2010, Alan Stern wrote:

> On Tue, 30 Mar 2010, Justin Piszcz wrote:
>
> Also, I'd like to see the contents of your /proc/interrupts.  It looks
> like the OHCI controller shares an IRQ line with some other device.

Hi, you are correct:

$ cat /proc/interrupts
            CPU0       CPU1
   0:        127         32   IO-APIC-edge      timer
   1:          0          2   IO-APIC-edge      i8042
   7:          1          0   IO-APIC-edge
   9:          0          0   IO-APIC-fasteoi   acpi
  20:          0          3   IO-APIC-fasteoi   ehci_hcd:usb1
  22:          0          0   IO-APIC-fasteoi   sata_nv
  23:        216     134543   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
  27:          0         68   PCI-MSI-edge      hda_intel
  28:       4722    1583395   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:    5414110    5415173   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
PND:          0          0   Performance pending work
RES:     766744     123073   Rescheduling interrupts
CAL:        113         25   Function call interrupts
TLB:       1014       1029   TLB shootdowns
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:         19         19   Machine check polls
ERR:          1
MIS:          0
$
>
> Well, I'm making progress.  Below is a new debugging patch to try in
> place of the first one.  This time the dmesg log alone will be
> sufficient, no need for a usbmon trace.  And the output should be a lot
> smaller, since the new patch doesn't print something every time an
> interrupt occurs, but rather only when you unplug the mouse.
>
> In fact, you might try unplugging the mouse while it still works and
> then plugging it back in.  The difference between the debugging
> messages while everything is working and the same thing after the mouse
> fails should be informative.
Ok, I can try this as well.

>
> (By the way, these tests are meant to find out why your Xorg and khubd
> processes hang when the mouse fails, not for finding the original cause
> behind the mouse failure.  That can be addressed later.)
This appears to occur only AFTER the mouse locks up, I do ctrl-alt-f1
and then X freezes up after that.

> Some of those reports indicate that a BIOS update could fix the
> problem.  Have you checked your BIOS version?
The BIOS is outdated, I will create a Windows Boot CD and flash the BIOS
to the latest version.  The hardware in question is an Optiplex 740.  It is
running an older firmware version..  The latest firmware is from late 2009 
(2.2.4): O740-224.EXE, but you cannot flash it in Linux so will test this
tomorrow, flash the latest bios, apply your latest patch, see if it recurs.
I did check the DIFF's for the Dell BIOS updates, none mention a USB problem
like the one in the kernel bug post (earlier Dell system).

Justin.


>
> Alan Stern
>
>
>
> Index: usb-2.6/drivers/usb/host/ohci-hcd.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ohci-hcd.c
> +++ usb-2.6/drivers/usb/host/ohci-hcd.c
> @@ -292,6 +292,8 @@ static int ohci_urb_dequeue(struct usb_h
> 		if (urb_priv) {
> 			if (urb_priv->ed->state == ED_OPER)
> 				start_ed_unlink (ohci, urb_priv->ed);
> +			ohci_info(ohci, "start unlink urb %p, ed %p tick %u\n",
> +					urb, urb_priv->ed, urb_priv->ed->tick);
> 		}
> 	} else {
> 		/*
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
> Index: usb-2.6/drivers/usb/host/ohci-q.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ohci-q.c
> +++ usb-2.6/drivers/usb/host/ohci-q.c
> @@ -912,6 +912,9 @@ rescan_all:
> 		 * frame counter wraps and EDs with partially retired TDs
> 		 */
> 		if (likely (HC_IS_RUNNING(ohci_to_hcd(ohci)->state))) {
> +			ohci_info(ohci, "finish_unlinks: tick %u, ed %p %u, %d\n",
> +					tick, ed, ed->tick,
> +					tick_before(tick, ed->tick));
> 			if (tick_before (tick, ed->tick)) {
> skip_ed:
> 				last = &ed->ed_next;
> @@ -928,6 +931,8 @@ skip_ed:
> 								TD_MASK;
>
> 				/* INTR_WDH may need to clean up first */
> +				ohci_info(ohci, "dma %llx head %x\n",
> +					(unsigned long long) td->td_dma, head);
> 				if (td->td_dma != head) {
> 					if (ed == ohci->ed_to_check)
> 						ohci->ed_to_check = NULL;
> @@ -990,6 +995,8 @@ rescan_this:
> 			/* HC may have partly processed this TD */
> 			td_done (ohci, urb, td);
> 			urb_priv->td_cnt++;
> +			ohci_info(ohci, "td_cnt %d length %d\n",
> +					urb_priv->td_cnt, urb_priv->length);
>
> 			/* if URB is done, clean up */
> 			if (urb_priv->td_cnt == urb_priv->length) {
>
