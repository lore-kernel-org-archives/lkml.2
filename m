Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab0EVSk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:40:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:58308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0EVSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:40:54 -0400
Subject: Re: DMAR:[fault reason 02] Present bit in context entry is clear
 (firewire-ohci)
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-pci@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20100522121212.GQ10452@parisc-linux.org>
References: <4BF7B147.9020502@s5r6.in-berlin.de>
	 <20100522121212.GQ10452@parisc-linux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 May 2010 19:40:43 +0100
Message-ID: <1274553643.11551.17300.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 06:12 -0600, Matthew Wilcox wrote:
> On Sat, May 22, 2010 at 12:26:15PM +0200, Stefan Richter wrote:
> > Hi,
> > 
> > I came across a report of the subject message.  What does it mean; what
> > type of bug should be look for?
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=587178
> > >>>
> > firewire_ohci 0000:04:00.4: PCI INT C -> GSI 16 (level, low) -> IRQ 16
> > firewire_ohci 0000:04:00.4: setting latency timer to 64
> > firewire_ohci: Added fw-ohci device 0000:04:00.4, OHCI version 1.0
> > DRHD: handling fault status reg 2
> > DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> > DMAR:[fault reason 02] Present bit in context entry is clear
> > DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> > DMAR:[fault reason 02] Present bit in context entry is clear
> > DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> > DMAR:[fault reason 02] Present bit in context entry is clear
> > <<<
> > 
> > The log sounds as if this happens during from-device DMA of 04:00.4 into
> > a consistent buffer, yet the fault is logged for device 04:00.0.  The
> > log is from a Dell M4500.  The devices are, according to a web search,
> > 04:00.0 CardBus bridge [0607]: Ricoh Co Ltd Device [1180:e476] (rev 02)
> > 04:00.4 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd Device [1180:e832]
> > (rev 03) (prog-if 10)
> 
> I would guess that the DMAR can't distinguish between the different
> devices behind the Cardbus bridge.  Adding Dave Woodhouse.

Yeah, the DMAR looks at the source-id in the PCIe transactions, and it
sounds like those are all 04:00.0. But we've probably set up the DMAR to
allow the transactions from 04:00.4, and then it naturally faults when a
"different" device actually ends up doing the transaction.

If you make the pci_find_upstream_pcie_bridge() function do the
appropriate thing for this device, does it then work as expected?

Whether that's a _sane_ thing to do or not is possibly more of a Jesse
question...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

