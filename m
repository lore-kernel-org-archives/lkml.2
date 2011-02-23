Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1BWM7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:59:07 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42533 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1BWM7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p2iMQDMXfhhx/6AzV/pXViV1envzkYmRTOjaLwYFB5bGRrBt69oP9W9rFCCBD9a2xE
         sqqCf91KVBCtTFUakej9uThF+8wp2gT0O2qvKruve2Zc6Z46kHZ8HepxQipvWGzofQ0K
         Ah4366PWff9oDOkFWGuOdDYSKY9QEwN/mjz78=
Subject: Re: [PATCH v5] EHCI bus glue for on-chip PMC MSP USB controller
From: Anoop P A <anoop.pa@gmail.com>
To: Dan Carpenter <error27@gmail.com>
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
In-Reply-To: <20110222200427.GB1966@bicker>
References: <4D5ABB65.3090101@parrot.com>
	 <1298388933-13707-1-git-send-email-anoop.pa@gmail.com>
	 <20110222200427.GB1966@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 18:52:23 +0530
Message-ID: <1298467343.9950.119.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 23:04 +0300, Dan Carpenter wrote:
> On Tue, Feb 22, 2011 at 09:05:33PM +0530, Anoop P.A wrote:
> > From: Anoop <paanoop1@paanoop1-desktop.(none)>
> > 
> > This patch add bus glue for USB controller commonly found in PMC-Sierra MSP71xx family of SoC's.
> > 
> > 
> > Signed-off-by: Anoop P A <anoop.pa@gmail.com>
> > ---
> > Changes.
> > ehci-pmcmsp.c is based on latest ehci-pci.c.Addressed some stylistic issue pointed by Greg.
> > Addressed comments from Matthieu CASTET.
> 
> Could you spell that out more completely next time? 

OK 

> 
> > +config USB_EHCI_HCD_PMC_MSP
> > +	tristate "EHCI support for on-chip PMC MSP USB controller"
> 
> Better to say "EHCI support for on-chip PMC-Sierra MSP71xx USB controllers"
Ok will change that

> 
> > +	depends on USB_EHCI_HCD && MSP_HAS_USB
> > +	default y
> 
> New features always default to No.
O.k

> 
> > +#include <msp_usb.h>
> 
> Cannot find the msp_usb.h in linux-next.  Doesn't compile.
msp_usb.h has made it's way to linux-mips queue tree along with the
platform code

> 
> > +static void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci)
> > +{
> > +	u8 *base;
> > +	u8 *statreg;
> > +	u8 *fiforeg;
> > +	u32 val;
> > +	struct ehci_regs *reg_base = ehci->regs;
> > +
> > +	/* get register base */
> > +	base = (u8 *)reg_base + USB_EHCI_REG_USB_MODE;
> > +	statreg = (u8 *)reg_base + USB_EHCI_REG_USB_STATUS;
> > +	fiforeg = (u8 *)reg_base + USB_EHCI_REG_USB_FIFO;
> > +
> > +	/* Disable controller mode stream */
> > +	val = ehci_readl(ehci, (u32 *)base);
> 
> It doesn't compile so I can't test this, but I think that this will
> cause a sparse warning.  "base" should have an __iomem tag.  Please
> run sparse on this driver.
Looks like mips platform build has been broken on linux-next ( unable to
configure) . However I have tested code with linux-queue tree ( mips)
and didn't see any such warnings

> 
> > +/* called after powerup, by probe or system-pm "wakeup" */
> > +static int ehci_msp_reinit(struct ehci_hcd *ehci)
> > +{
> > +	ehci_port_power(ehci, 0);
> > +
> > +	return 0;
> 
> Better to make this function void.
O.K
> 
> > +}
> > +
> > +/* called during probe() after chip reset completes */
> > +static int ehci_msp_setup(struct usb_hcd *hcd)
> > +{
> > +	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
> > +	u32			temp;
> > +	int			retval;
> 
> Needs a blank line here to separate declarations from code.
O.K
> 
> > +	ehci->big_endian_mmio = 1;
> > +	ehci->big_endian_desc = 1;
> > +
> > +	ehci->caps = hcd->regs;
> > +	ehci->regs = hcd->regs +
> > +			HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
> 
> [snip]
> 
> > +	/* data structure init */
> > +	retval = ehci_init(hcd);
> > +	if (retval)
> > +		return retval;
> > +
> > +	temp = HCS_N_CC(ehci->hcs_params) * HCS_N_PCC(ehci->hcs_params);
> > +	temp &= 0x0f;
> 
> companion HCs * ports per CC & 0xf?
> 
> What's the &= 0x0f for?  It's left out of the printk.
Code got carried forward from ehci-pci.c . Is that says ehci-pci.c is
uptodate? .  
> 
> > +	if (temp && HCS_N_PORTS(ehci->hcs_params) > temp) {
> > +		ehci_dbg(ehci, "bogus port configuration: "
> > +			"cc=%d x pcc=%d < ports=%d\n",
> > +			HCS_N_CC(ehci->hcs_params),
> > +			HCS_N_PCC(ehci->hcs_params),
> > +			HCS_N_PORTS(ehci->hcs_params));
> > +	}
> 
> [snip]
> 
> > +/*-------------------------------------------------------------------------*/
> 
> No need for these blank comments.
O.K
> 
> > +
> > +static void msp_start_hc(struct platform_device *dev)
> > +{
> > +}
> > +
> > +static void msp_stop_hc(struct platform_device *dev)
> > +{
> > +}
> > +
> 
> I don't understand the point of these empty functions.
Will  remove it.
> 
> > +static int ehci_msp_suspend(struct device *dev)
> > +{
> > +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> > +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > +	unsigned long flags;
> > +	int rc;
> > +
> > +	return 0;
> > +	rc = 0;
> > +
> > +	if (time_before(jiffies, ehci->next_statechange))
> > +		usleep(10000);
> 
> Is there still a usleep() function?  Either way, can you send us
> something that compiles on linux-next?
Again code got carried from ehci-pci.c .(changed msleep to usleep as
checkpatch complained about it). I am unable to compile mips targets in
linux-next tree . However this patch is tested with both linux-stable
and linux-queue tree of l-m-o

> 
> regards,
> dan carpenter
> 
> 


