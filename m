Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0HBU3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:29:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23560 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0HBU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:29:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6062"; a="49632857"
Date: Mon, 2 Aug 2010 13:29:38 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100802202935.GA26214@codeaurora.org>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <20100729084018.GM26098@amd.com>
 <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
 <20100729090607.GN26098@amd.com>
 <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
 <20100802075802.GN24084@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802075802.GN24084@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 09:58:02AM +0200, Roedel, Joerg wrote:
> Hi Stephan,
> 
> On Fri, Jul 30, 2010 at 01:19:06AM -0400, stepanm@codeaurora.org wrote:
> > Unlike a more traditional system with one IOMMU between the bus and
> > memory, MSM has multiple IOMMUs, with each one hard-wired to a dedicated
> > device. Furthermore, each IOMMU can have more than one translation
> > context. One of the use cases is being able to create mappings within
> > multiple instances of one context, and arbitrarily context-switch the
> > IOMMU on the fly.
> 
> The IOMMU-API supports multiple IOMMUs (at least multiple AMD/Intel
> IOMMUs). But the face that there are more than one IOMMU is hidden in
> the backend driver implementation. The API itself only works with
> domains and devices. The IOMMU driver needs to know which IOMMU it needs
> to program for a given device. If I understand the concept of your
> hardware correctly you also have this information.
> 
> > It sounds like the domain abstraction and attach_device/detach_device can
> > encapsulate this rather nicely and I am in the process of updating my
> > driver to fit this framework.
> > 
> > My problem, however, is with iommu_domain_alloc(). This will set up a
> > domain and call the ops function to initialize it, but I want to be able
> > to pass it an ???IOMMU id" that will tell the underlying driver which IOMMU
> > (and which "stream id") is to be associated with that domain instance.
> > This can be a void* parameter that gets passed through to domain_init. I
> > feel like this change will make it easy to deal with multiple
> > IOMMUs/translation contexts, and implementations that have only a singular
> > IOMMU/translation context are free to ignore that parameter.
> 
> In the means of the IOMMU-API the domain is the abstraction of an
> address space (in other words a page table). The IOMMU(s) which this domain
> is later assigned to are determined by the iommu_attach_device calls.
> I think the right way to go here is to create the concept of a
> device-context in the IOMMU-API and add functions like
> 
> 	iommu_attach_context(struct iommu_domain *domain,
> 			     struct iommu_context *ctxt);
> 	iommu_detach_context(struct iommu_context *ctxt);
> 
> This would work if you can determine in your iommu-driver which iommu
> you need to program for which device. What do you think?
> 

Joerg, I'd like to make sure I understand this. A domain is an address
space separate from the actual page-tables that may be part of an
iommu_context, correct? After I iommu_attach_context the ctxt will
reflect the address space of the domain, correct?

> 
> 	Joerg
> 
> -- 
> Joerg Roedel - AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
