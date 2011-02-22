Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1BVUEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:04:55 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64042 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1BVUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=seewF4FLdSwS84LCnu/EuBxcoIIGGzs+D5vKor1D07C9KC0GFS5/bDPj8VzbsPXVVE
         Bi2yybcQ1lJFGYH9YXHFdX/vaCdvchjOJS+PUyrlkmWdKf8k3hMUDTtiRUkOup5+8gVW
         J6VN7EzaB8CdnY00egCHCmnicN82IlECB9gcs=
Date: Tue, 22 Feb 2011 23:04:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Anoop P.A" <anoop.pa@gmail.com>
Cc: "gregkh @ suse . de" <gregkh@suse.de>,
        "dbrownell @ users . sourceforge . net" 
	<dbrownell@users.sourceforge.net>,
        "stern @ rowland . harvard . edu" <stern@rowland.harvard.edu>,
        "pkondeti @ codeaurora . org" <pkondeti@codeaurora.org>,
        "jacob . jun . pan @ intel . com" <jacob.jun.pan@intel.com>,
        "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
        "alek . du @ intel . com" <alek.du@intel.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "gadiyar @ ti . com" <gadiyar@ti.com>,
        "ralf @ linux-mips . org" <ralf@linux-mips.org>,
        "linux-mips @ linux-mips . org" <linux-mips@linux-mips.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v5] EHCI bus glue for on-chip PMC MSP USB controller
Message-ID: <20110222200427.GB1966@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Anoop P.A" <anoop.pa@gmail.com>,
	"gregkh @ suse . de" <gregkh@suse.de>,
	"dbrownell @ users . sourceforge . net" <dbrownell@users.sourceforge.net>,
	"stern @ rowland . harvard . edu" <stern@rowland.harvard.edu>,
	"pkondeti @ codeaurora . org" <pkondeti@codeaurora.org>,
	"jacob . jun . pan @ intel . com" <jacob.jun.pan@intel.com>,
	"linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
	"alek . du @ intel . com" <alek.du@intel.com>,
	"linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
	"gadiyar @ ti . com" <gadiyar@ti.com>,
	"ralf @ linux-mips . org" <ralf@linux-mips.org>,
	"linux-mips @ linux-mips . org" <linux-mips@linux-mips.org>,
	Greg KH <greg@kroah.com>
References: <4D5ABB65.3090101@parrot.com>
 <1298388933-13707-1-git-send-email-anoop.pa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298388933-13707-1-git-send-email-anoop.pa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:05:33PM +0530, Anoop P.A wrote:
> From: Anoop <paanoop1@paanoop1-desktop.(none)>
> 
> This patch add bus glue for USB controller commonly found in PMC-Sierra MSP71xx family of SoC's.
> 
> 
> Signed-off-by: Anoop P A <anoop.pa@gmail.com>
> ---
> Changes.
> ehci-pmcmsp.c is based on latest ehci-pci.c.Addressed some stylistic issue pointed by Greg.
> Addressed comments from Matthieu CASTET.

Could you spell that out more completely next time?

> +config USB_EHCI_HCD_PMC_MSP
> +	tristate "EHCI support for on-chip PMC MSP USB controller"

Better to say "EHCI support for on-chip PMC-Sierra MSP71xx USB controllers"

> +	depends on USB_EHCI_HCD && MSP_HAS_USB
> +	default y

New features always default to No.

> +#include <msp_usb.h>

Cannot find the msp_usb.h in linux-next.  Doesn't compile.

> +static void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci)
> +{
> +	u8 *base;
> +	u8 *statreg;
> +	u8 *fiforeg;
> +	u32 val;
> +	struct ehci_regs *reg_base = ehci->regs;
> +
> +	/* get register base */
> +	base = (u8 *)reg_base + USB_EHCI_REG_USB_MODE;
> +	statreg = (u8 *)reg_base + USB_EHCI_REG_USB_STATUS;
> +	fiforeg = (u8 *)reg_base + USB_EHCI_REG_USB_FIFO;
> +
> +	/* Disable controller mode stream */
> +	val = ehci_readl(ehci, (u32 *)base);

It doesn't compile so I can't test this, but I think that this will
cause a sparse warning.  "base" should have an __iomem tag.  Please
run sparse on this driver.

> +/* called after powerup, by probe or system-pm "wakeup" */
> +static int ehci_msp_reinit(struct ehci_hcd *ehci)
> +{
> +	ehci_port_power(ehci, 0);
> +
> +	return 0;

Better to make this function void.

> +}
> +
> +/* called during probe() after chip reset completes */
> +static int ehci_msp_setup(struct usb_hcd *hcd)
> +{
> +	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
> +	u32			temp;
> +	int			retval;

Needs a blank line here to separate declarations from code.

> +	ehci->big_endian_mmio = 1;
> +	ehci->big_endian_desc = 1;
> +
> +	ehci->caps = hcd->regs;
> +	ehci->regs = hcd->regs +
> +			HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));

[snip]

> +	/* data structure init */
> +	retval = ehci_init(hcd);
> +	if (retval)
> +		return retval;
> +
> +	temp = HCS_N_CC(ehci->hcs_params) * HCS_N_PCC(ehci->hcs_params);
> +	temp &= 0x0f;

companion HCs * ports per CC & 0xf?

What's the &= 0x0f for?  It's left out of the printk.

> +	if (temp && HCS_N_PORTS(ehci->hcs_params) > temp) {
> +		ehci_dbg(ehci, "bogus port configuration: "
> +			"cc=%d x pcc=%d < ports=%d\n",
> +			HCS_N_CC(ehci->hcs_params),
> +			HCS_N_PCC(ehci->hcs_params),
> +			HCS_N_PORTS(ehci->hcs_params));
> +	}

[snip]

> +/*-------------------------------------------------------------------------*/

No need for these blank comments.

> +
> +static void msp_start_hc(struct platform_device *dev)
> +{
> +}
> +
> +static void msp_stop_hc(struct platform_device *dev)
> +{
> +}
> +

I don't understand the point of these empty functions.

> +static int ehci_msp_suspend(struct device *dev)
> +{
> +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> +	unsigned long flags;
> +	int rc;
> +
> +	return 0;
> +	rc = 0;
> +
> +	if (time_before(jiffies, ehci->next_statechange))
> +		usleep(10000);

Is there still a usleep() function?  Either way, can you send us
something that compiles on linux-next?

regards,
dan carpenter


