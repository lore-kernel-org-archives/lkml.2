Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1ELHco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:32:44 -0400
Received: from mail4.comsite.net ([205.238.176.238]:12032 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1ELHcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:32:43 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Message-id: <geert-ps3-iommu@mdm.bga.com>
In-Reply-To: <BANLkTi=eL9uwvNSdEnY4S=k1kjSgH4Q5xg@mail.gmail.com>
References: <BANLkTi=eL9uwvNSdEnY4S=k1kjSgH4Q5xg@mail.gmail.com>
	<1305152704-4864-8-git-send-email-nacc@us.ibm.com> 
Subject: Re: [PATCH 7/8] powerpc: use the newly added get_required_mask
 dma_map_ops hook
From: Milton Miller <miltonm@bga.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org
Date: Thu, 12 May 2011 02:32:37 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 12, 2011 at 00:25, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> > diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
> > index 23083c3..688141c 100644
> > --- a/arch/powerpc/platforms/ps3/system-bus.c
> > +++ b/arch/powerpc/platforms/ps3/system-bus.c
> > @@ -695,12 +695,18 @@ static int ps3_dma_supported(struct device *_dev, u64 mask)
> > 				return mask >= DMA_BIT_MASK(32);
> > 	}
> >
> > +static u64 ps3_dma_get_required_mask(struct device *_dev)
> > +{
> > + 			return DMA_BIT_MASK(32);
> 
> Why 32 and not 64?

I based it on the return of ps3_dma_supported, which you can see just
above says anything at or above a 32 bit mask is ok.

I don't really know the platform, but digging a bit deeper, it looks
like this goes to ps3_map_dma in ps3/mm.c.  It looks like that translates
the virt to phys to lpar (similar to absolute in iseries), and the
maps it to a bus address by a linear mapping.  But no where do I see
mention of a device dma mask (neither in mm.c or system-dev.c (except
for the ps3_dma_supported local), so I assume that 32 bits is sufficient
for any device.  It appears to me the code establishs a 1:1 mapping
of all possible memory with no provision for allocating blocks or
checking that a bus address belongs to another memory segment.

Feel free to point out any errors in the above analysis, otherwise
I assume the required mask matches the dma_supported op.

Does the lv1 hypervisor offer more than 4G of memory to the lpar?

milton

