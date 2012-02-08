Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750706Ab2BHFCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:02:50 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37217 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab2BHFCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:02:49 -0500
Date: Wed, 8 Feb 2012 13:01:19 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] PCI: Fix cardbus bridge resources as optional size
 handling
Message-ID: <20120208050119.GE8930@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
 <1328424908-6385-5-git-send-email-yinghai@kernel.org>
 <20120208043517.GD8930@ram-ThinkPad-T61>
 <CAE9FiQUdRLmc-_hHWtaz=8QZiu4Ma6ZY7zavByJnwMDTBQLtzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUdRLmc-_hHWtaz=8QZiu4Ma6ZY7zavByJnwMDTBQLtzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020805-1780-0000-0000-000002F6499B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000246; HX=3.00000182; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00111890; UDB=6.00027688; UTC=2012-02-08
 05:02:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 08:48:36PM -0800, Yinghai Lu wrote:
> On Tue, Feb 7, 2012 at 8:35 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> > On Sat, Feb 04, 2012 at 10:55:03PM -0800, Yinghai Lu wrote:
> >> We should not set the requested size to -2.
> >>
> >> that will confuse the resource list sorting with align when SIZEALIGN is used.
> >>
> >> Change to STARTALIGN and pass align from start.
> >>
> >> We are safe to do that just as we do that regular pci bridge.
> >>
> >> In the long run, we should just treat cardbus like regular pci bridge.
> >>
> >> Also fix when realloc is not passed, should keep the requested size.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >>  drivers/pci/setup-bus.c |   63 ++++++++++++++++++++++++++--------------------
> >>  1 files changed, 36 insertions(+), 27 deletions(-)
> >>
> >> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> >> index d5897c3..3b3932a 100644
> >> --- a/drivers/pci/setup-bus.c
> >> +++ b/drivers/pci/setup-bus.c
> >> @@ -898,21 +898,30 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,

..snip

> >> -             b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
> >> -             if (realloc_head)
> >> -                     add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size, 0 /* dont care */);
> >
> > The b_res_3_size has to be reduced to half here.
> > Otherwise it will try allocate 2*pci_cardbus_mem_size to the BAR3..
> >
> >                b_res_3_size = pci_cardbus_mem_size;
> >
> >
> >> -     } else {
> >> -             b_res[3].start = 0;
> >> -             b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
> >> -             if (realloc_head)
> >> -                     add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size * 2, 0 /* dont care */);
> >> +             /* reduce that to half */
> >> +             b_res_3_size = pci_cardbus_mem_size;
> >
> > b_res3_3_size should not be updated here, since BAR3 has to be allocated 2*pci_cardbus_mem_size
> > resource.
> >
> 
> looks like you did not read the patch correctly
> 
> that else {} get removed already in this patch
> 
> please check segment after patch...
> 	/*

..snip..
> 	 * If we have prefetchable memory support, allocate
> 	 * two regions.  Otherwise, allocate one region of
> 	 * twice the size.
> 	 */
> 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
> 		b_res[2].start = pci_cardbus_mem_size;
> 		b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
> 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH |
> 				  IORESOURCE_STARTALIGN;
> 		if (realloc_head) {
> 			b_res[2].end -= pci_cardbus_mem_size;
> 			add_to_list(realloc_head, bridge, b_res+2,
> 				 pci_cardbus_mem_size, pci_cardbus_mem_size);
> 		}
> 
> 		/* reduce that to half */
> 		b_res_3_size = pci_cardbus_mem_size;
> 	}

ACK. Ok. got it. This looks correct.
RP

