Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1K1SOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:14:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:20665 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1K1SON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:14:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80754505"
Date: Mon, 28 Nov 2011 10:14:13 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andiry Xu <andiry.xu@amd.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
Message-ID: <20111128181413.GA6462@xanatos>
References: <4EAC3C5C.5000209@lwfinger.net>
 <20111030050443.GC4535@xanatos>
 <4EB01904.10605@lwfinger.net>
 <4EC0DCD5.2010509@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC0DCD5.2010509@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.  Larry, have you been able to test Andiry's patch?  We'd like to
figure out what's wrong with the control endpoint ring in your xHCI host.

Sarah Sharp

On Mon, Nov 14, 2011 at 05:18:13PM +0800, Andiry Xu wrote:
> On 11/02/2011 12:06 AM, Larry Finger wrote:
> > On 10/30/2011 12:04 AM, Sarah Sharp wrote:
> > 
> >> The xHCI driver allocates a fixed-size endpoint ring, and only so much
> >> data can fit on it.  If the driver is allocating many URBs or many URBs
> >> with a lot of data, then you will see these messages and the URBs will
> >> fail to be submitted.  Now if neither of those conditions are true, then
> >> it's possible we just have a bug in the xHCI driver.
> >>
> >> There is a patchset in the works to dynamically expand the endpoint
> >> rings, but it's still going through revisions:
> >>
> >> http://marc.info/?l=linux-usb&m=131918645424329&w=2
> > 
> > I have a bit more to report. Applying the above patch set did not help.
> > 
> > I modified the xHCI driver from 3.1-rc10 to provide a stack dump
> > whenever the messages appeared. The "short transfer on control ep"
> > occurs before the rtl8192cu device has been plugged and has the
> > following dump, which is probably not informative:
> > 
> > [    3.988197] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
> > [    3.988208] Pid: 0, comm: kworker/0:0 Not tainted
> > 3.1.0-0301rc9-generic #201110050905
> > [    3.988213] Call Trace:
> > [    3.988225]  [<c135788d>] ? dev_warn+0x2d/0x30
> > [    3.988238]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
> > [    3.988249]  [<c1079827>] ? tick_program_event+0x27/0x40
> > [    3.988261]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
> > [    3.988270]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
> > [    3.988279]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
> > [    3.988286]  [<c10ac73f>] handle_irq_event+0x3f/0x60
> > [    3.988294]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
> > [    3.988301]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
> > [    3.988305]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
> > [    3.988320]  [<c1542950>] ? notifier_call_chain+0x30/0x60
> > [    3.988328]  [<c1546970>] ? common_interrupt+0x30/0x38
> > [    3.988337]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
> > [    3.988345]  [<c12e5524>] ? intel_idle+0xa4/0x100
> > [    3.988355]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
> > [    3.988364]  [<c1001c27>] ? cpu_idle+0x97/0xd0
> > [    3.988368]  [<c1537e16>] ? start_secondary+0xf6/0x110
> > 
> > Just in case it is needed, the full dmesg output is attached.
> > 
> > Due to wrapping of the dmesg buffer, the first few of stack dumps for
> > the "ERROR no room on ep ring" messages were lost, but the one I got
> > came from the following code fragment in
> > drivers/net/wireless/rtlwifi/usb.c at line 87:
> > 
> >         usb_fill_control_urb(urb, udev, pipe,
> >                              (unsigned char *)dr, buf, len,
> >                              usbctrl_async_callback, buf);
> >         rc = usb_submit_urb(urb, GFP_ATOMIC);
> > 
> > The value of len for this call is 4. The driver only uses 1, 2, or 4 as
> > the lengths of writes, at least those that go through usb_submit_urb().
> > Even the firmware download is done one dword at a time.
> > 
> > We also tested with the xHCI code from the current mainline kernel, i.e.
> > 3.1-git, but I don't have the dmesg output for that version. If you have
> > any patches in the pipeline, or anything to test, please send those to me.
> > 
> 
> A control transfer ring should not be full. Only isoc and bulk transfer
> will cause ring full with a lot of TDs submitted simultaneously. I
> suspect the ring is mangled.
> 
> Please apply the patch attached, enable CONFIG_USB_DEBUG and
> CONFIG_USB_XHCI_HCD_DEBUGGING and post the dmesg with the "no room on ep
> ring" error.
> 
> Thanks,
> Andiry

> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index e4b7f00..d949871 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -2443,6 +2443,10 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
>  	if (!room_on_ring(xhci, ep_ring, num_trbs)) {
>  		/* FIXME allocate more room */
>  		xhci_err(xhci, "ERROR no room on ep ring\n");
> +		xhci_err(xhci, "Event ring:\n");
> +		xhci_debug_ring(xhci, xhci->event_ring);
> +		xhci_err(xhci, "Endpoint ring:\n");
> +		xhci_debug_ring(xhci, ep_ring);
>  		return -ENOMEM;
>  	}
>  

