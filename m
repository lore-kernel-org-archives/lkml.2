Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0G3FSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:18:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42383 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0G3FSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:18:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6058"; a="49163858"
Message-ID: <d493494df33aaf65e526181b1dbafce3.squirrel@www.codeaurora.org>
In-Reply-To: <20100729090607.GN26098@amd.com>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
    <201007291026.55928.arnd@arndb.de> <20100729084018.GM26098@amd.com>
    <20100729174621W.fujita.tomonori@lab.ntt.co.jp>
    <20100729090607.GN26098@amd.com>
Date: Thu, 29 Jul 2010 22:19:06 -0700 (PDT)
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: stepanm@codeaurora.org
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "stepanm@codeaurora.org" <stepanm@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

Thanks for the information. I have been trying to adapt the MSM IOMMU
driver to use your IOMMU interface, and it looks like it might work, with
one minor modification.

Unlike a more traditional system with one IOMMU between the bus and
memory, MSM has multiple IOMMUs, with each one hard-wired to a dedicated
device. Furthermore, each IOMMU can have more than one translation
context. One of the use cases is being able to create mappings within
multiple instances of one context, and arbitrarily context-switch the
IOMMU on the fly.

It sounds like the domain abstraction and attach_device/detach_device can
encapsulate this rather nicely and I am in the process of updating my
driver to fit this framework.

My problem, however, is with iommu_domain_alloc(). This will set up a
domain and call the ops function to initialize it, but I want to be able
to pass it an “IOMMU id" that will tell the underlying driver which IOMMU
(and which "stream id") is to be associated with that domain instance.
This can be a void* parameter that gets passed through to domain_init. I
feel like this change will make it easy to deal with multiple
IOMMUs/translation contexts, and implementations that have only a singular
IOMMU/translation context are free to ignore that parameter.

The alternative for me is to have a separate msm_iommu_domain_alloc(void
*context_id) function, to which I can specify which IOMMU I want to use,
but I would like to fully use your API if possible.

What are your thoughts? I can prepare a patch if you like - the
domain_alloc change looks like it will be very innocuous.

Thanks
Steve


> On Thu, Jul 29, 2010 at 04:46:59AM -0400, FUJITA Tomonori wrote:
>> On Thu, 29 Jul 2010 10:40:19 +0200
>> "Roedel, Joerg" <Joerg.Roedel@amd.com> wrote:
>>
>> > The IOMMU-API is not about SR-IOV.
>>
>> That's true. However, the point is that include/iommu.h is far from
>> the IOMMU-API.
>>
>> You could still insist that include/iommu.h is designed for the
>> generic IOMMU-API. But the fact is that it's designed for very
>> specific purposes. No intention to make it for generic purposes.
>
> I have no clue about the ARM iommus on the omap-platform. From a quick
> look into the header file I see some similarities to the IOMMU-API. I am
> also very open for discussions about how the IOMMU-API could be extended
> to fit the needs of other platforms. Only because nobody has tried to
> discuss about such an effort is no reason to push the IOMMU-API back.
>
>>
>> Since you added it two years ago, nobody has tried to extend
>> it. Instead, we have something like
>> arch/arm/plat-omap/include/plat/iommu.h.
>
> And I think we should try to merge this platform-specific functionality
> into the IOMMU-API.
>
> 	Joerg
>
> --
> Joerg Roedel - AMD Operating System Research Center
>
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr.
> 43632
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



