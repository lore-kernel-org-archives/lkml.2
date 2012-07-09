Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2GIMck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:32:40 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:33614
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab2GIMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:32:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VPS-14(zz98dI1be0I1dbaI1432Izz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M6W863-02-87D-02
X-M-MSG: 
Date: Mon, 9 Jul 2012 14:32:30 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 03/28] x86/irq: Use irq_remap specific print_IO_APIC
 paths only on Intel
Message-ID: <20120709123230.GA25282@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
 <1341491808-23083-4-git-send-email-joerg.roedel@amd.com>
 <20120706085036.GB24449@gmail.com>
 <20120706130530.GC2639@amd.com>
 <20120706140037.GA22845@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120706140037.GA22845@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 04:00:37PM +0200, Ingo Molnar wrote:
> ( A proper abstraction would stick it all into some sort PCI 
>   driver alike structure, including enumeration, initialization, 
>   debugging and other non-core details. )

This is certainly a multi-cycle process to make sure we do not break
everything from one release to another. But cleaning that 4000+ lines
monster up is a good thing, I agree with that. 

> So the way this could work in a cleaner fashion is to 
> encapsulate the logic even more. Today we have a per irq_desc 
> irq_cfg data descriptor, but there's still global knowledge in 
> actual vector allocation such as create_irq() or 
> msi_compose_msg(). Patterns like:
> 
>         if (irq_remapped(cfg)) {
>                 compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
>                 return err;
>         }
> 
>         if (x2apic_enabled())
>                 msg->address_hi = MSI_ADDR_BASE_HI |
>                                   MSI_ADDR_EXT_DEST_ID(dest);
>         else
>                 msg->address_hi = MSI_ADDR_BASE_HI;
> 
> all all signs of insufficient abstraction.

Why was this code merged when you are unhappy with it?

About the irq_remapped() thing: to abstract this properly it has to be a
per-irq abstraction, because in the MSI case some interrupts may be
remapped and others may be not. In the AMD IOMMU case for example, the
MSI interrupt of the IOMMU device itself is not remapped but all others
are. So function pointers in 'struct irq_cfg' come into mind for that.
What do you think about that?

> More importantly, all the silly open-coded if (irq_remapping_enabled)
> checks should be eliminated from core x86 code. IRQ remapping
> should be either be an irq_chip detail or should live in a
> separate layer.

I'll start with factoring out these irq_remapping_enabled and post the
results so that we can agree on the right direction. I gained some
experience with this code while factoring out all the VT-d internals
from it in one of the last cycles.

> So before extending all this please get this into shape.

What about Patches 1 and 2? Any comments on these or are they fine?


Kind Regards,

     Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

