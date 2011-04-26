Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1DZSvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:51:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36899 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751504Ab1DZSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:51:02 -0400
Date: Tue, 26 Apr 2011 14:51:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rabin Vincent <rabin@rab.in>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        <linux-kernel@vger.kernel.org>, <gcc@gcc.gnu.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
In-Reply-To: <BANLkTi=-DFfdiBKZzRBxF-yMJFtWnzuk1g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104261447481.2035-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Rabin Vincent wrote:

> On Wed, Feb 2, 2011 at 21:30, Arnd Bergmann <arnd@arndb.de> wrote:
> > As noticed by Peter Maydell, the EHCI device driver in Linux gets
> > miscompiled by some versions of arm-gcc (still need to find out which)
> > due to a combination of problems:
> >
> > 1. In include/linux/usb/ehci_def.h, struct ehci_caps is defined
> > with __attribute__((packed)), for no good reason. This is clearly
> > a bug and needs to get fixed, but other drivers have the same bug
> 
> Was a patch submitted for this?  I couldn't find it in the archives.
> U-Boot seems to be fixing this by adding an "aligned(4)" instead
> of removing the packed:
> 
> http://www.mail-archive.com/u-boot@lists.denx.de/msg51418.html

ISTR a patch was submitted,  but apparently it never got picked up.

> > and it used to work. The attribute forces byte access on all members
> > accessed through pointer dereference, which is not allowed on
> > MMIO accesses in general. The specific code triggering the problem
> > in Peter's case is in ehci-omap.c:
> >        omap->ehci->regs = hcd->regs
> >                + HC_LENGTH(readl(&omap->ehci->caps->hc_capbase));
> 
> In my case it's this writel() in ehci-hub.c that gets chopped into
> strbs:
> 
> 	/* force reset to complete */
> 	ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
> 				status_reg);

Why would that get messed up?  The status_reg variable doesn't have any 
__atribute__((packed)) associated with it.

Alan Stern

