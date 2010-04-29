Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab0D3TBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:01:30 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:49224 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759397Ab0D3TBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:01:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E) and disconnect (WKDISC_E)
Date: Thu, 29 Apr 2010 23:14:26 +0200
User-Agent: KMail/1.9.10
Cc: Alek Du <alek.du@intel.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1004291338090.1339-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004291338090.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004292314.29072.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010 19:45:33 Alan Stern wrote:
> On Thu, 29 Apr 2010, Alan Stern wrote:
> > > > > > You said earlier that the host controller was disabled for remote
> > > > > > wakeup ("/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup is
> > > > > > disabled by default").  So even though the root hub might issue a
> > > > > > wakeup request, the controller hardware should not forward that
> > > > > > request to the PCI bus and it should not cause the system to wake
> > > > > > up.
> > > > >
> > > > > Maybe it should not - but it wakes up this board and probably also
> > > > > P4P800, P4P800-E and P4C800-E at least:
> > > > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/75497
> > > >
> > > > Okay, evidently the hardware or firmware on these boards is buggy.
> > > > Other systems do not have the same problem, as far as I know.
> >
> > I take this back.  The same thing happens on my machine (Intel ICH5
> > chipset).  I'd guess there is a bug in the PCI or ACPI subsystem, but
> > more testing is needed before I can be sure.  Somehow the PCI or
> > platform wakeup mechanism gets activated even when it is supposed to be
> > disabled.
>
> This patch fixes the problem on my system.  Does it work for you?
> I still think that disabling wakeup at the PCI or platform level should
> override the port wakeup flags, but apparently it doesn't.

Thanks for the patch. When applied to 2.6.33 kernel, the ehci-fsl.c part fails 
but that does not matter. Asus P4P800-VM now suspends correctly even when the 
jumpers are set to 5V, both with and without USB device. Also device (un)plug 
does not wake up the system anymore. So the patch works fine.

Yes, this wakeup seems to work differently on different systems. For example, 
Asus A7V8X-X [VIA] (which has these 5V/5VSB jumpers too) is not affected by 
this (it wakes up dead but that's another problem). Also Asus Eee PC 701 
(ICH6) and ASRock 939Dual-VSTA (ULi) are not affected. So maybe it affects 
only ICH4/5/6 chips (only some revisions?). Or it's also board-dependent.

> Alek, can you confirm that the changes in this patch are okay for the
> Moorestown EHCI controller?  I had to guess at how to handle the
> HOSTPCx register settings.
>
> Alan Stern
>
>
>
> Index: usb-2.6/drivers/usb/host/ehci-hub.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-hub.c
> +++ usb-2.6/drivers/usb/host/ehci-hub.c
> @@ -106,6 +106,47 @@ static void ehci_handover_companion_port
>  	ehci->owned_ports = 0;
>  }
>
> +static void ehci_set_wakeup_flags(struct ehci_hcd *ehci)
> +{
> +	int	port;
> +
> +	/* enable remote wakeup on all ports, if allowed */
> +	port = HCS_N_PORTS(ehci->hcs_params);
> +	while (port--) {
> +		u32 __iomem	*reg = &ehci->regs->port_status[port];
> +		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
> +		u32		t2 = t1 & ~PORT_WAKE_BITS;
> +
> +		/* only enable appropriate wake bits, otherwise the
> +		 * hardware can not go phy low power mode. If a race
> +		 * condition happens here(connection change during bits
> +		 * set), the port change detection will finally fix it.
> +		 */
> +		if (device_may_wakeup(ehci_to_hcd(ehci)->self.controller)) {
> +			if (t1 & PORT_CONNECT)
> +				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
> +			else
> +				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
> +			ehci_vdbg(ehci, "port %d, %08x -> %08x\n",
> +					port + 1, t1, t2);
> +		}
> +		ehci_writel(ehci, t2, reg);
> +	}
> +}
> +
> +static void ehci_clear_wakeup_flags(struct ehci_hcd *ehci)
> +{
> +	int	port;
> +
> +	port = HCS_N_PORTS(ehci->hcs_params);
> +	while (port--) {
> +		u32 __iomem	*reg = &ehci->regs->port_status[port];
> +		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
> +
> +		ehci_writel(ehci, t1 & ~PORT_WAKE_BITS, reg);
> +	}
> +}
> +
>  static int ehci_bus_suspend (struct usb_hcd *hcd)
>  {
>  	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
> @@ -170,26 +211,6 @@ static int ehci_bus_suspend (struct usb_
>  		else if ((t1 & PORT_PE) && !(t1 & PORT_SUSPEND)) {
>  			t2 |= PORT_SUSPEND;
>  			set_bit(port, &ehci->bus_suspended);
> -		}
> -
> -		/* enable remote wakeup on all ports */
> -		if (hcd->self.root_hub->do_remote_wakeup) {
> -			/* only enable appropriate wake bits, otherwise the
> -			 * hardware can not go phy low power mode. If a race
> -			 * condition happens here(connection change during bits
> -			 * set), the port change detection will finally fix it.
> -			 */
> -			if (t1 & PORT_CONNECT) {
> -				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
> -				t2 &= ~PORT_WKCONN_E;
> -			} else {
> -				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
> -				t2 &= ~PORT_WKDISC_E;
> -			}
> -		} else
> -			t2 &= ~PORT_WAKE_BITS;
> -
> -		if (t1 != t2) {
>  			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
>  				port + 1, t1, t2);
>  			ehci_writel(ehci, t2, reg);
> @@ -907,12 +928,7 @@ static int ehci_hub_control (
>
>  					|| (temp & PORT_RESET) != 0)
>
>  				goto error;
>
> -			/* After above check the port must be connected.
> -			 * Set appropriate bit thus could put phy into low power
> -			 * mode if we have hostpc feature
> -			 */
> -			temp &= ~PORT_WKCONN_E;
> -			temp |= PORT_WKDISC_E | PORT_WKOC_E;
> +			temp &= ~PORT_WAKE_BITS;
>  			ehci_writel(ehci, temp | PORT_SUSPEND, status_reg);
>  			if (hostpc_reg) {
>  				spin_unlock_irqrestore(&ehci->lock, flags);
> Index: usb-2.6/drivers/usb/host/ehci-pci.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-pci.c
> +++ usb-2.6/drivers/usb/host/ehci-pci.c
> @@ -284,23 +284,15 @@ static int ehci_pci_suspend(struct usb_h
>  		msleep(10);
>
>  	/* Root hub was already suspended. Disable irq emission and
> -	 * mark HW unaccessible, bail out if RH has been resumed. Use
> -	 * the spinlock to properly synchronize with possible pending
> -	 * RH suspend or resume activity.
> -	 *
> -	 * This is still racy as hcd->state is manipulated outside of
> -	 * any locks =P But that will be a different fix.
> +	 * mark HW unaccessible.  The PM and USB cores make sure that
> +	 * the root hub is either suspended or stopped.
>  	 */
>  	spin_lock_irqsave (&ehci->lock, flags);
> -	if (hcd->state != HC_STATE_SUSPENDED) {
> -		rc = -EINVAL;
> -		goto bail;
> -	}
> +	ehci_set_wakeup_flags(ehci);
>  	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
>  	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
>
>  	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> - bail:
>  	spin_unlock_irqrestore (&ehci->lock, flags);
>
>  	// could save FLADJ in case of Vaux power loss
> @@ -330,6 +322,7 @@ static int ehci_pci_resume(struct usb_hc
>  				!hibernated) {
>  		int	mask = INTR_MASK;
>
> +		ehci_clear_wakeup_flags(ehci);
>  		if (!hcd->self.root_hub->do_remote_wakeup)
>  			mask &= ~STS_PCD;
>  		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
> Index: usb-2.6/drivers/usb/host/ehci-au1xxx.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-au1xxx.c
> +++ usb-2.6/drivers/usb/host/ehci-au1xxx.c
> @@ -215,26 +215,17 @@ static int ehci_hcd_au1xxx_drv_suspend(s
>  		msleep(10);
>
>  	/* Root hub was already suspended. Disable irq emission and
> -	 * mark HW unaccessible, bail out if RH has been resumed. Use
> -	 * the spinlock to properly synchronize with possible pending
> -	 * RH suspend or resume activity.
> -	 *
> -	 * This is still racy as hcd->state is manipulated outside of
> -	 * any locks =P But that will be a different fix.
> +	 * mark HW unaccessible.  The PM and USB cores make sure that
> +	 * the root hub is either suspended or stopped.
>  	 */
>  	spin_lock_irqsave(&ehci->lock, flags);
> -	if (hcd->state != HC_STATE_SUSPENDED) {
> -		rc = -EINVAL;
> -		goto bail;
> -	}
> +	ehci_set_wakeup_flags(ehci);
>  	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
>  	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
>
>  	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
>
>  	au1xxx_stop_ehc();
> -
> -bail:
>  	spin_unlock_irqrestore(&ehci->lock, flags);
>
>  	// could save FLADJ in case of Vaux power loss
> @@ -264,6 +255,7 @@ static int ehci_hcd_au1xxx_drv_resume(st
>  	if (ehci_readl(ehci, &ehci->regs->configured_flag) == FLAG_CF) {
>  		int	mask = INTR_MASK;
>
> +		ehci_clear_wakeup_flags(ehci);
>  		if (!hcd->self.root_hub->do_remote_wakeup)
>  			mask &= ~STS_PCD;
>  		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
> Index: usb-2.6/drivers/usb/host/ehci-fsl.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-fsl.c
> +++ usb-2.6/drivers/usb/host/ehci-fsl.c
> @@ -313,6 +313,7 @@ static int ehci_fsl_drv_suspend(struct d
>  	struct ehci_fsl *ehci_fsl = hcd_to_ehci_fsl(hcd);
>  	void __iomem *non_ehci = hcd->regs;
>
> +	ehci_set_wakeup_flags(ehci);
>  	if (!fsl_deep_sleep())
>  		return 0;
>
> @@ -327,6 +328,7 @@ static int ehci_fsl_drv_resume(struct de
>  	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
>  	void __iomem *non_ehci = hcd->regs;
>
> +	ehci_clear_wakeup_flags(ehci);
>  	if (!fsl_deep_sleep())
>  		return 0;



-- 
Ondrej Zary
