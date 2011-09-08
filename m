Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab1IHOET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:04:19 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46010 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab1IHOEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:04:11 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.113.217]
In-Reply-To: <CAHQjnONUvBtKSMxiDf5Mk+DLqfrTr09Us11rWoaR1mVZeiAmnA@mail.gmail.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
 <1314984756-4400-8-git-send-email-ohad@wizery.com> <CAHQjnOMT3UOFMi=JbSXf4-s_BbZ+fSGbOEjxwT7t7N-zd+9-zg@mail.gmail.com>
 <CAK=WgbZPFryzCFLa5AhAYDmH1S8c3x-OsSTyxYeq0WLAe8VyTg@mail.gmail.com>
 <CAHQjnOMnOjAJ6QuuLmLa1UKvTRHfyyjiUYrfvzLx8FSsCixxng@mail.gmail.com>
 <CAK=WgbbFhmiC=PJfmyPOhbHGtiPFOcmqBx7nSpkuDX36hPYgbA@mail.gmail.com> <CAHQjnONUvBtKSMxiDf5Mk+DLqfrTr09Us11rWoaR1mVZeiAmnA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Sep 2011 17:03:50 +0300
Message-ID: <CAK=WgbZoF-F_hXHT1i=cAh8QJb+aFSjjubdy_YkHQ97acRvorA@mail.gmail.com>
Subject: Re: [RFC 7/7] iommu/core: split mapping to page sizes as supported by
 the hardware
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <Joerg.Roedel@amd.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Thu, Sep 8, 2011 at 3:51 PM, KyongHo Cho <pullip.cho@samsung.com> wrote:
> 16MB page is less practical in Linux because Linux kernel is unable
> to allocated larger physically contiguous memory than 4MB by default.
> But I also think that it is needed to support 16MB mapping for IO
> virtualization someday

Actually we need physically contiguous memory regions that are much
bigger (in the tens of megs), so we do utilize 16MB pages. Today we
reserve that memory on boot, but the plan is to move to CMA.

> Actually, I think your idea is good and does not cause performance degradation.
> But I wondered if it is really useful.

Well, the alternative is to duplicate this logic in every IOMMU driver.

Go ahead and try to rebase your driver on my recent patch set and see
if you like it; the result should significantly simplify your
map/unmap functions.

You only need to add this line:
static unsigned long s5p_iommu_pgsizes = SZ_4K | SZ_64K | SZ_1M | SZ_16M;

and then advertise it with iommu_register, and you're done. The IOMMU
core will only ask you to handle a single page from now on, and will
take care of the rest.

> The caller of iommu_map() gives gfp_order that is the size of the physical
> memory to map.

I've changed it in the patch :)

This way users are not bound to rigid mapping sizes (this allows us to
better utilize the physically-contiguous memory region we reserve on
boot).

Thanks,
Ohad.
