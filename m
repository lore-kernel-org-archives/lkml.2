Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2LQInt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:43:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:53246 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2LQIns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:43:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hideki EIRAKU <hdk@igel.co.jp>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, iommu@lists.linux-foundation.org
Subject: Re: [PATCH/WIP/RFC 02/14] shmobile-iommu: Move IPMMU driver to drivers/iommu
Date: Mon, 17 Dec 2012 09:45:03 +0100
Message-ID: <1626129.3KmpqDAOtk@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50CE8D24.3010604@igel.co.jp>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp> <1355678760-27357-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <50CE8D24.3010604@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Damian,

(CC'ing iommu@lists.linux-foundation.org)

On Monday 17 December 2012 12:10:28 Damian Hobson-Garcia wrote:
> On 2012/12/17 2:25, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  arch/arm/mach-shmobile/Kconfig                     |    6 ------
> >  arch/arm/mach-shmobile/Makefile                    |    3 ---
> >  drivers/iommu/Kconfig                              |    6 ++++++
> >  drivers/iommu/Makefile                             |    1 +
> >  .../ipmmu.c => drivers/iommu/shmobile-ipmmu.c      |    0
> >  5 files changed, 7 insertions(+), 9 deletions(-)
> >  rename arch/arm/mach-shmobile/ipmmu.c => drivers/iommu/shmobile-ipmmu.c
> >  (100%)
>
> I agree that arch/arm is not a good place, but I'm not completely sure that
> ipmmu.c belongs in drivers/iommu.  The reason is because of the PMB
> functionality provided by the IPMMU.  The PMB provides a fixed address
> remapping capability that is completely unrelated to the IOMMU
> functionality.  Since this remapping is done by writing the IPMMU registers
> directly, instead of via a page table it doesn't really fit in well with the
> IOMMU API (it also supports things like tiled/linear address translation,
> which require some other method to set up).  Since the PMB and the IOMMU
> functions of the IPPMU share the same register address space, we would like
> to have one driver to handle the register accesses of both of these
> functions.  That driver is ipmmu.c.  So if ipmmu.c is in drivers/iommu, the
> entire IOMMU subsystem must be enabled in order to use the PMB
> functionality. So maybe it might be better to treat the IPMMU like a
> multifuction device, with a core driver (ipmmu.c) in one location and the
> function implementations in their own respective directories. Does
> drivers/mfd sound like a good place for it?

I've thought about this as well. The IPMMU indeed provides two different 
functions, so drivers/mfd/ could be a candidate. This being said, both the 
IOMMU function and the PMB function are related to virtual memory space 
management, so they're not totally unrelated. I agree that the PMB function 
isn't really an IOMMU in the sense that it will likely not be exposed through 
the existing IOMMU API.

However, drivers/iommu/ seems to me like a more natural place to store the 
IPMMU driver compared to drivers/mfd/. Enabling IOMMU support 
(CONFIG_IOMMU_SUPPORT) doesn't mean the IOMMU core (CONFIG_IOMMU_API) will be 
compiled in. There would thus be no extra code compiled in if the IOMMU 
function of the IPMMU is disabled.

-- 
Regards,

Laurent Pinchart

