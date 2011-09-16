Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1IPLD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 07:03:28 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:57242 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1IPLD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 07:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4whS+_hEdyNgOKOUzRBCn=99Z4x0x_jg1qnsL+uTmjt+A@mail.gmail.com>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	<1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	<CAGsJ_4whS+_hEdyNgOKOUzRBCn=99Z4x0x_jg1qnsL+uTmjt+A@mail.gmail.com>
Date: Fri, 16 Sep 2011 16:33:25 +0530
Message-ID: <CAJe_ZhfjmCOOAsBnB+adZbRq=G5CWvk6ZHpukufe+_JHCN+_Gw@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Define generic transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: dan.j.williams@intel.com, vkoul@infradead.org,
        linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2011 12:47, Barry Song <21cnbao@gmail.com> wrote:
> 2011/9/15 Jassi Brar <jaswinder.singh@linaro.org>:
>> --- a/drivers/dma/dmaengine.c
>> +++ b/drivers/dma/dmaengine.c
>> @@ -699,6 +699,8 @@ int dma_async_device_register(struct dma_device *device)
>>                !device->device_prep_dma_cyclic);
>>        BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
>>                !device->device_control);
>> +       BUG_ON(dma_has_cap(DMA_GENXFER, device->cap_mask) &&
>> +               !device->device_prep_dma_genxfer);
>
> i don't think it is what i want here. device_prep_dma_genxfer should
> be able to cover memcpy, slave or other modes, but not parallel with
> them.

ATM this api is indeed parallel to others like memcpy, slave_sg etc.
because I have dropped the 'op' member in v2. The idea is to merge
other prepares one at a time and ultimately have this api consume
those that it can. So the 'op' would be restored when we merge
the first 'prepare' into this.


> For example, if i use genxfer, but my devices are slave. i might not
> need a device_prep_slave_sg since i have already prep_dma_genxfer, but
> anyway, i need a DMA_SLAVE_CONFIG to set burst size or others. then
> i'd like to have DMA_SLAVE flag but without device_prep_slave_sg
> callback.

As I already said, this api could be used for interleaved Mem->Mem
as well as Mem<->Dev
If your channels are Slave, please set the DMA_SLAVE flag and provide the
'device_control' callback.

I think I should have simply removed the check
    BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
                   !device->device_prep_slave_sg);
Because obviously we now have a _valid_ case of SLAVE channel but
supporting a different prepare - device_prep_dma_genxfer.  Will do that in v3.
