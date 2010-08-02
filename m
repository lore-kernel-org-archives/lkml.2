Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0HBHz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:55:27 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:35226
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab0HBHzV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:55:21 -0400
X-SpamScore: -25
X-BigFish: VS-25(zz1dbaL1432N98dNzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6ILZP-01-KNN-02
X-M-MSG: 
Date: Mon, 2 Aug 2010 09:58:02 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "stepanm@codeaurora.org" <stepanm@codeaurora.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100802075802.GN24084@amd.com>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
 <201007291026.55928.arnd@arndb.de>
 <20100729084018.GM26098@amd.com>
 <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
 <20100729090607.GN26098@amd.com>
 <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Fri, Jul 30, 2010 at 01:19:06AM -0400, stepanm@codeaurora.org wrote:
> Unlike a more traditional system with one IOMMU between the bus and
> memory, MSM has multiple IOMMUs, with each one hard-wired to a dedicated
> device. Furthermore, each IOMMU can have more than one translation
> context. One of the use cases is being able to create mappings within
> multiple instances of one context, and arbitrarily context-switch the
> IOMMU on the fly.

The IOMMU-API supports multiple IOMMUs (at least multiple AMD/Intel
IOMMUs). But the face that there are more than one IOMMU is hidden in
the backend driver implementation. The API itself only works with
domains and devices. The IOMMU driver needs to know which IOMMU it needs
to program for a given device. If I understand the concept of your
hardware correctly you also have this information.

> It sounds like the domain abstraction and attach_device/detach_device can
> encapsulate this rather nicely and I am in the process of updating my
> driver to fit this framework.
> 
> My problem, however, is with iommu_domain_alloc(). This will set up a
> domain and call the ops function to initialize it, but I want to be able
> to pass it an “IOMMU id" that will tell the underlying driver which IOMMU
> (and which "stream id") is to be associated with that domain instance.
> This can be a void* parameter that gets passed through to domain_init. I
> feel like this change will make it easy to deal with multiple
> IOMMUs/translation contexts, and implementations that have only a singular
> IOMMU/translation context are free to ignore that parameter.

In the means of the IOMMU-API the domain is the abstraction of an
address space (in other words a page table). The IOMMU(s) which this domain
is later assigned to are determined by the iommu_attach_device calls.
I think the right way to go here is to create the concept of a
device-context in the IOMMU-API and add functions like

	iommu_attach_context(struct iommu_domain *domain,
			     struct iommu_context *ctxt);
	iommu_detach_context(struct iommu_context *ctxt);

This would work if you can determine in your iommu-driver which iommu
you need to program for which device. What do you think?


	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

