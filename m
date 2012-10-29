Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab2J2JAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:00:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41225 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab2J2JAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <1351485943.7077.30.camel@vkoul-udesk3>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	<1349432276-22919-4-git-send-email-inderpal.singh@linaro.org>
	<1351052091.5263.19.camel@vkoul-udesk3>
	<CAG17yqQBep4Y3YOGVFr6s_apX9f0YeTC7dxDcTQM7ahxnr1B4w@mail.gmail.com>
	<1351226723.7077.14.camel@vkoul-udesk3>
	<CAG17yqTx6MnmpYLZCxeJ9gC_ha6i3Bp3Fc+=9L7EJEJoNwCFtQ@mail.gmail.com>
	<1351485943.7077.30.camel@vkoul-udesk3>
Date: Mon, 29 Oct 2012 14:30:17 +0530
Message-ID: <CAG17yqQPNFOYjJYdLrg4exKRbqbhPPV6zOv4oBYBuo5=gCnadw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] DMA: PL330: Balance module remove function with probe
From: Inderpal Singh <inderpal.singh@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 29 October 2012 10:15, Vinod Koul <vkoul@infradead.org> wrote:
> On Sat, 2012-10-27 at 15:50 +0530, Inderpal Singh wrote:
>> Hi Vinod,
>>
>> On 26 October 2012 10:15, Vinod Koul <vkoul@infradead.org> wrote:
>> > On Thu, 2012-10-25 at 16:53 +0530, Inderpal Singh wrote:
>> >>
>> >> This code will get executed only in case of force removal of the
>> >> module which was discussed in the first version of the patch at [1].
>> >> Now, if we do not have to think about force removal then this patch
>> >> will go back to the first version.
>> > But why are you doing force removal of driver even when client is
>> > holding a reference to you.
>> >
>> > What happens when client finally tries to free the channel?
>> Since we return EBUSY so forced removal won't succeed. Client can free
>> the channel eventually.
> And that is my concern. You have forcefully removed the dma module.
> What happens then? How will the free calll get executed, wont you hit a
> panic.

Yes, you are correct, It will hit a panic.
The return value from remove is not being checked in
__device_release_driver because of which dma module is forcefully
removed even if we return EBUSY from driver's remove. Hence returning
error from .remove is not useful at all.

>>
>> >
>> > What is the problem you are trying to solve?
>> >>
>>
>> There was a long discussion about it in the first version of the
>> patch. Allow me to explain it to you.
>>
>> The existing driver does DMA_TERMINATE_ALL and frees resources for all
>> the channels in the _remove function.
> Which for starters may not be right thing to do.


Please consider v1 patch which removes DMA_TERMINATE_ALL and freeing
of resources from .remove function because in normal scenario if
remove is reached it is sure that no client is holding any reference
to the driver hence no need to flush and free the channels.

> Shouldn't you first
> make sure client has freed all references to your driver and then only
> remove. Freeing resources in .remove without keeping client in sync
> doesn't sound to be good idea to me.
>
>>  The first version of patch
>> removed this flushing and freeing of channel resources because they
>> are not getting allocated in the probe. Jassi pointed out that manual
>> flushing is needed if a force removal happens and some client is
>> queued. Then it was agreed that flushing is not needed, instead we
>> should return EBUSY if client is queued on some channel (this will
>> happen only in force removal case). Hence this additional check in v2
>> version so that force removal does not succeeds if any client is
>> queued.
>>
>> If you think force removal is not a practical scenario and we should
>> not be bothering about it, this check can be removed and the patch
>> will go back to first version which just removes flushing and freeing
>> of channels beacues they are not getting allocated in probe.
>>
>> Let me know your view.
>>
>> Regards,
>> Inder
>>
>>
>> >> Let me know your view.
>> >>
>> >> [1] https://patchwork.kernel.org/patch/1503171/
>> >>
>> >
>> >
>> > --
>> > Vinod Koul
>> > Intel Corp.
>> >
>
>
> --
> Vinod Koul
> Intel Corp.
>
