Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0FVKwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:52:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab0FVKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:52:41 -0400
Date: Tue, 22 Jun 2010 12:52:33 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>
Subject: should struct device.dma_mask still be a pointer?
Message-ID: <20100622105233.GA4755@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

IMHO it's strange that struct device.dma_mask is a pointer instead of a
plain u64.  The reason this was done back then is described in
8ab1bc19e974fdebe76c065fe444979c84ba2f74[1]:

	Attached is a patch which moves dma_mask into struct device and cleans up the
	scsi mid-layer to use it (instead of using struct pci_dev).  The advantage to
	doing this is probably most apparent on non-pci bus architectures where
	currently you have to construct a fake pci_dev just so you can get the bounce
	buffers to work correctly.

	The patch tries to perturb the minimum amount of code, so dma_mask in struct
	device is simply a pointer to the one in pci_dev.  However, it will make it
	easy for me now to add generic device to MCA without having to go the fake pci
	route.

As I work on such a non-pci bus architecture it's still ugly that this
is a pointer because I have to allocate extra memory for that.

Is there a reason not to get rid of struct pci_dev.dma_mask and use
struct pci_dev.dev.dma_mask instead?  (Well apart from the needed
effort of course.)

If not, the following would be needed:

	- remove struct pci.dma_mask
	- make struct device.dma_mask an u64 (instead of u64*)
	- substitue var.dma_mask by var.dev.dma_mask for all
	  struct pci_dev var
	- substitue var.dma_mask by &(var.dma_mask) for all
	  struct device var

and note that there are statically initialized struct device (and maybe
struct pci_dev?) that need fixing, too.  (e.g.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/arm/mach-mx2/devices.c;h=a0aeb8a4adc19ef419a0a045ad3b882131597106;hb=HEAD#l265
)

Additionally this could be done for struct device.dma_parms.

Julia: help!

Best regards
Uwe

[1] as this is pre-2.6.12 it's only available in tglx' histroy tree,
e.g.  http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=8ab1bc19e974fdebe76c065fe444979c84ba2f74

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
