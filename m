Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0EKDfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:35:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:36416 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab0EKDfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:35:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,204,1272870000"; 
   d="scan'208";a="797244309"
Date: Tue, 11 May 2010 11:31:20 +0800
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Message-ID: <20100511113120.02787f96@dxy2>
In-Reply-To: <Pine.LNX.4.44L0.1005101616540.1626-100000@iolanthe.rowland.org>
References: <20100510102557.0c30f15d@dxy2>
	<Pine.LNX.4.44L0.1005101616540.1626-100000@iolanthe.rowland.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 05:05:34 +0800
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 10 May 2010, Du, Alek wrote:
> 
> > Alan,
> > 
> > The following patch (based on your previous two patches) works for me, could you
> > help to review and test on your machine? Basically, this will only affect those
> > "has_hostpc" HCDs.
> 
> Based on your suggestion, I completely redid both of my patches.  They 
> are now combined into a single patch, which is meant to go on top of 
> the patch you submitted this morning.  It adds the stuff we talked 
> about, and it cleans up some of the changes you made.
> 
> Does it look good to you?
> 
> Alan Stern
> 

Alan,

It looks good and works for my hardware. Thanks a lot!
Will you submit it soon?

Alek

> 
> 
> Index: usb-2.6/drivers/usb/host/ehci-hub.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-hub.c
> +++ usb-2.6/drivers/usb/host/ehci-hub.c
> @@ -106,12 +106,72 @@ static void ehci_handover_companion_port
>  	ehci->owned_ports = 0;
>  }
>  
> +static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci, bool resuming)
> +{
> +	int		port;
> +	u32		temp;
> +
> +	/* If remote wakeup is enabled for the root hub but disabled
> +	 * for the controller, we must adjust all the port wakeup flags.
> +	 */
> +	if (!ehci_to_hcd(ehci)->self.root_hub->do_remote_wakeup ||
> +			device_may_wakeup(ehci_to_hcd(ehci)->self.controller))
> +		return;
> +
> +	/* clear phy low-power mode before changing wakeup flags */
> +	if (ehci->has_hostpc) {
> +		port = HCS_N_PORTS(ehci->hcs_params);
> +		while (port--) {
> +			u32 __iomem	*hostpc_reg;
> +
> +			hostpc_reg = (u32 __iomem *)((u8 *) ehci->regs
> +					+ HOSTPC0 + 4 * port);
> +			temp = ehci_readl(ehci, hostpc_reg);
> +			ehci_writel(ehci, temp & ~HOSTPC_PHCD, hostpc_reg);
> +		}
> +		msleep(5);
> +	}
> +
> +	port = HCS_N_PORTS(ehci->hcs_params);
> +	while (port--) {
> +		u32 __iomem	*reg = &ehci->regs->port_status[port];
> +		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
> +		u32		t2 = t1 & ~PORT_WAKE_BITS;
> +
> +		/* If we are suspending the controller, clear the flags.
> +		 * If we are resuming the controller, set the wakeup flags.
> +		 */
> +		if (resuming) {
> +			if (t1 & PORT_CONNECT)
> +				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
> +			else
> +				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
> +		}
> +		ehci_vdbg(ehci, "port %d, %08x -> %08x\n",
> +				port + 1, t1, t2);
> +		ehci_writel(ehci, t2, reg);
> +	}
> +
> +	/* enter phy low-power mode again */
> +	if (ehci->has_hostpc) {
> +		port = HCS_N_PORTS(ehci->hcs_params);
> +		while (port--) {
> +			u32 __iomem	*hostpc_reg;
> +
> +			hostpc_reg = (u32 __iomem *)((u8 *) ehci->regs
> +					+ HOSTPC0 + 4 * port);
> +			temp = ehci_readl(ehci, hostpc_reg);
> +			ehci_writel(ehci, temp | HOSTPC_PHCD, hostpc_reg);
> +		}
> +	}
> +}
> +
>  static int ehci_bus_suspend (struct usb_hcd *hcd)
>  {
>  	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
>  	int			port;
>  	int			mask;
> -	u32 __iomem		*hostpc_reg = NULL;
> +	int			changed;
>  
>  	ehci_dbg(ehci, "suspend root hub\n");
>  
> @@ -155,15 +215,13 @@ static int ehci_bus_suspend (struct usb_
>  	 */
>  	ehci->bus_suspended = 0;
>  	ehci->owned_ports = 0;
> +	changed = 0;
>  	port = HCS_N_PORTS(ehci->hcs_params);
>  	while (port--) {
>  		u32 __iomem	*reg = &ehci->regs->port_status [port];
>  		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
> -		u32		t2 = t1;
> +		u32		t2 = t1 & ~PORT_WAKE_BITS;
>  
> -		if (ehci->has_hostpc)
> -			hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
> -				+ HOSTPC0 + 4 * (port & 0xff));
>  		/* keep track of which ports we suspend */
>  		if (t1 & PORT_OWNER)
>  			set_bit(port, &ehci->owned_ports);
> @@ -172,40 +230,45 @@ static int ehci_bus_suspend (struct usb_
>  			set_bit(port, &ehci->bus_suspended);
>  		}
>  
> -		/* enable remote wakeup on all ports */
> +		/* enable remote wakeup on all ports, if told to do so */
>  		if (hcd->self.root_hub->do_remote_wakeup) {
>  			/* only enable appropriate wake bits, otherwise the
>  			 * hardware can not go phy low power mode. If a race
>  			 * condition happens here(connection change during bits
>  			 * set), the port change detection will finally fix it.
>  			 */
> -			if (t1 & PORT_CONNECT) {
> +			if (t1 & PORT_CONNECT)
>  				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
> -				t2 &= ~PORT_WKCONN_E;
> -			} else {
> +			else
>  				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
> -				t2 &= ~PORT_WKDISC_E;
> -			}
> -		} else
> -			t2 &= ~PORT_WAKE_BITS;
> +		}
>  
>  		if (t1 != t2) {
>  			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",
>  				port + 1, t1, t2);
>  			ehci_writel(ehci, t2, reg);
> -			if (hostpc_reg) {
> -				u32	t3;
> +			changed = 1;
> +		}
> +	}
>  
> -				spin_unlock_irq(&ehci->lock);
> -				msleep(5);/* 5ms for HCD enter low pwr mode */
> -				spin_lock_irq(&ehci->lock);
> -				t3 = ehci_readl(ehci, hostpc_reg);
> -				ehci_writel(ehci, t3 | HOSTPC_PHCD, hostpc_reg);
> -				t3 = ehci_readl(ehci, hostpc_reg);
> -				ehci_dbg(ehci, "Port%d phy low pwr mode %s\n",
> +	if (changed && ehci->has_hostpc) {
> +		spin_unlock_irq(&ehci->lock);
> +		msleep(5);	/* 5 ms for HCD to enter low-power mode */
> +		spin_lock_irq(&ehci->lock);
> +
> +		port = HCS_N_PORTS(ehci->hcs_params);
> +		while (port--) {
> +			u32 __iomem	*hostpc_reg;
> +			u32		t3;
> +
> +			hostpc_reg = (u32 __iomem *)((u8 *) ehci->regs
> +					+ HOSTPC0 + 4 * port);
> +			t3 = ehci_readl(ehci, hostpc_reg);
> +			ehci_writel(ehci, t3 | HOSTPC_PHCD, hostpc_reg);
> +			t3 = ehci_readl(ehci, hostpc_reg);
> +			ehci_dbg(ehci, "Port %d phy low-power mode %s\n",
>  					port, (t3 & HOSTPC_PHCD) ?
>  					"succeeded" : "failed");
> -			}
>  		}
>  	}
>  
> @@ -291,19 +354,28 @@ static int ehci_bus_resume (struct usb_h
>  	msleep(8);
>  	spin_lock_irq(&ehci->lock);
>  
> +	/* clear phy low-power mode before resume */
> +	if (ehci->bus_suspended && ehci->has_hostpc) {
> +		i = HCS_N_PORTS (ehci->hcs_params);
> +		while (i--) {
> +			if (test_bit(i, &ehci->bus_suspended)) {
> +				u32 __iomem	*hostpc_reg;
> +
> +				hostpc_reg = (u32 __iomem *)((u8 *) ehci->regs
> +						+ HOSTPC0 + 4 * i);
> +				temp = ehci_readl(ehci, hostpc_reg);
> +				ehci_writel(ehci, temp & ~HOSTPC_PHCD,
> +						hostpc_reg);
> +			}
> +		}
> +		spin_unlock_irq(&ehci->lock);
> +		msleep(5);
> +		spin_lock_irq(&ehci->lock);
> +	}
> +
>  	/* manually resume the ports we suspended during bus_suspend() */
>  	i = HCS_N_PORTS (ehci->hcs_params);
>  	while (i--) {
> -		/* clear phy low power mode before resume */
> -		if (ehci->has_hostpc) {
> -			u32 __iomem	*hostpc_reg =
> -				(u32 __iomem *)((u8 *)ehci->regs
> -				+ HOSTPC0 + 4 * (i & 0xff));
> -			temp = ehci_readl(ehci, hostpc_reg);
> -			ehci_writel(ehci, temp & ~HOSTPC_PHCD,
> -				hostpc_reg);
> -			mdelay(5);
> -		}
>  		temp = ehci_readl(ehci, &ehci->regs->port_status [i]);
>  		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
>  		if (test_bit(i, &ehci->bus_suspended) &&
> @@ -685,23 +757,25 @@ static int ehci_hub_control (
>  				goto error;
>  			if (ehci->no_selective_suspend)
>  				break;
> -			if (temp & PORT_SUSPEND) {
> -				if ((temp & PORT_PE) == 0)
> -					goto error;
> -				/* clear phy low power mode before resume */
> -				if (hostpc_reg) {
> -					temp1 = ehci_readl(ehci, hostpc_reg);
> -					ehci_writel(ehci, temp1 & ~HOSTPC_PHCD,
> -						hostpc_reg);
> -					mdelay(5);
> -				}
> -				/* resume signaling for 20 msec */
> -				temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
> -				ehci_writel(ehci, temp | PORT_RESUME,
> -						status_reg);
> -				ehci->reset_done [wIndex] = jiffies
> -						+ msecs_to_jiffies (20);
> +			if (!(temp & PORT_SUSPEND))
> +				break;
> +			if ((temp & PORT_PE) == 0)
> +				goto error;
> +
> +			/* clear phy low-power mode before resume */
> +			if (hostpc_reg) {
> +				temp1 = ehci_readl(ehci, hostpc_reg);
> +				ehci_writel(ehci, temp1 & ~HOSTPC_PHCD,
> +					hostpc_reg);
> +				spin_unlock_irqrestore(&ehci->lock, flags);
> +				msleep(5);/* wait to leave low-power mode */
> +				spin_lock_irqsave(&ehci->lock, flags);
>  			}
> +			/* resume signaling for 20 msec */
> +			temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
> +			ehci_writel(ehci, temp | PORT_RESUME, status_reg);
> +			ehci->reset_done[wIndex] = jiffies
> +					+ msecs_to_jiffies(20);
>  			break;
>  		case USB_PORT_FEAT_C_SUSPEND:
>  			clear_bit(wIndex, &ehci->port_c_suspend);
> Index: usb-2.6/drivers/usb/host/ehci-pci.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-pci.c
> +++ usb-2.6/drivers/usb/host/ehci-pci.c
> @@ -287,23 +287,15 @@ static int ehci_pci_suspend(struct usb_h
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
> +	ehci_adjust_port_wakeup_flags(ehci, false);
>  	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
>  	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
>  
>  	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> - bail:
>  	spin_unlock_irqrestore (&ehci->lock, flags);
>  
>  	// could save FLADJ in case of Vaux power loss
> @@ -333,6 +325,7 @@ static int ehci_pci_resume(struct usb_hc
>  				!hibernated) {
>  		int	mask = INTR_MASK;
>  
> +		ehci_adjust_port_wakeup_flags(ehci, true);
>  		if (!hcd->self.root_hub->do_remote_wakeup)
>  			mask &= ~STS_PCD;
>  		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
> Index: usb-2.6/drivers/usb/host/ehci-au1xxx.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ehci-au1xxx.c
> +++ usb-2.6/drivers/usb/host/ehci-au1xxx.c
> @@ -224,26 +224,17 @@ static int ehci_hcd_au1xxx_drv_suspend(s
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
> +	ehci_adjust_port_wakeup_flags(ehci, false);
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
> @@ -273,6 +264,7 @@ static int ehci_hcd_au1xxx_drv_resume(st
>  	if (ehci_readl(ehci, &ehci->regs->configured_flag) == FLAG_CF) {
>  		int	mask = INTR_MASK;
>  
> +		ehci_adjust_port_wakeup_flags(ehci, true);
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
> +	ehci_adjust_port_wakeup_flags(ehci, false);
>  	if (!fsl_deep_sleep())
>  		return 0;
>  
> @@ -327,6 +328,7 @@ static int ehci_fsl_drv_resume(struct de
>  	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
>  	void __iomem *non_ehci = hcd->regs;
>  
> +	ehci_adjust_port_wakeup_flags(ehci, true);
>  	if (!fsl_deep_sleep())
>  		return 0;
>  
> 

