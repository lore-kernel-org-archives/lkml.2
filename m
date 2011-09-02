Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab1IBA5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:57:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10889 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab1IBA5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:57:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6456"; a="114817703"
Message-ID: <915a03e22a061c147bb94b92a876af06.squirrel@www.codeaurora.org>
In-Reply-To: <20110831130304.GP12940@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
    <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
    <20110829101550.GT1923@amd.com>
    <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
    <20110829122516.GB9730@amd.com>
    <CAK=WgbbqCL60uf9gWhLYbkJo44Sva3BwQuZk2R--ER4M+yDV2w@mail.gmail.com>
    <20110829130552.GA10422@amd.com>
    <CAK=WgbagTUqZhPkg8OnVEvF2EB=AnpgfV5Fs0g95+o1mVU47YQ@mail.gmail.com>
    <20110831130304.GP12940@amd.com>
Date: Thu, 1 Sep 2011 17:57:06 -0700 (PDT)
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
From: "Laura Abbott" <lauraa@codeaurora.org>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Stepan Moskovchenko" <stepanm@codeaurora.org>,
        "David Brown" <davidb@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, August 31, 2011 6:03 am, Roedel, Joerg wrote:
> On Mon, Aug 29, 2011 at 09:21:54AM -0400, Ohad Ben-Cohen wrote:
>> On Mon, Aug 29, 2011 at 4:05 PM, Roedel, Joerg <Joerg.Roedel@amd.com>
>> wrote:
>> > So in this case you can skip this whole part when CONFIG_IOMMU_API is
>> > disabled
>>
>> Sure, we can do something like this in the driver:
>>
>> #ifdef CONFIG_IOMMU_API
>>
>> int do_the_iommu_thing(..)
>> {
>>    ... call the IOMMU API as needed...
>> }
>>
>> #else
>>
>> int do_the_iommu_thing(..)
>> {
>>     return 0;
>> }
>>
>> #endif
>>
>> Essentially, this means implementing the !CONFIG_IOMMU_API stubs in the
>> driver.
>
> I expect only very few drivers need that. Most drivers (like KVM and the
> upcoming VFIO) rely on the iommu-api and I expect most other drivers
> using the directly will also rely on an iommu. So this change makes
> still sense to me.
>

At least with MSM code, the iommu calls are abstracted through an API so
drivers don't need to know if the platform has an iommu or not.
Essentially:

if (iommu_found())
    iommu_map(...)
else
    do something else reasonable.

With this change, all code that might potentially call any iommu_map
function must exist in a separate file or face linker errors.

This idiom of having stubbed out functions is all over the kernel. I'm not
really sure what is gained by not having stubbed out versions of the
functions. There are better ways to catch users not selecting
CONFIG_IOMMU.

>> Possible of course, but I think it's a bit neater to have that in one
>> place, where all drivers can use. Similar to !CONFIG_HWSPINLOCK,
>> !CONFIG_DEBUG_FS, ...
>>
>> > This saves you even more .text size, no?
>>
>> Not sure; I expect the code to be compiled out today when the IOMMU
>> API is called and CONFIG_IOMMU_API is not set.
>
> But you even save all code that would use the iommu-api in your driver.
> This change forces you to compile out this code too leading to smaller
> .text-size.
>
> 	Joerg
>
The .text size reduction doesn't seem like it would be that great compared
to the annoyance of not having stubbed out functions.

Laura

> --
> AMD Operating System Research Center
>
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr.
> 43632
>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
>


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


