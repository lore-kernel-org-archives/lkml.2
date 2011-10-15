Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1JOOWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 10:22:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1JOOWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 10:22:39 -0400
MIME-Version: 1.0
In-Reply-To: <20111015124645.GG21802@flint.arm.linux.org.uk>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318570705-17595-2-git-send-email-vinod.koul@intel.com> <20111015124645.GG21802@flint.arm.linux.org.uk>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 15 Oct 2011 22:22:16 +0800
Message-ID: <CAGsJ_4xXWy_L4am6XxgjfqVUbgXDsm=P5-FJZn50u-=FcON0CA@mail.gmail.com>
Subject: Re: [PATCH 01/10] dmaengine: add new enum dma_transfer_direction
To: Russell King <rmk@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        Vinod Koul <vinod.koul@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/15 Russell King <rmk@arm.linux.org.uk>:
> On Fri, Oct 14, 2011 at 11:08:16AM +0530, Vinod Koul wrote:
>> This new enum removes usage of dma_data_direction for dma direction. The new
>> enum cleans tells the DMA direction and mode
>> This further paves way for merging the dmaengine _prep operations and also for
>> interleaved dma
>>
>> Suggested-by: Jassi Brar <jaswinder.singh@linaro.org>
>> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
>> ---
>>  include/linux/dmaengine.h |   22 +++++++++++++++++-----
>>  1 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index ace51af..24942ad 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -23,7 +23,6 @@
>>
>>  #include <linux/device.h>
>>  #include <linux/uio.h>
>> -#include <linux/dma-direction.h>
>>  #include <linux/scatterlist.h>
>>
>>  /**
>> @@ -75,6 +74,19 @@ enum dma_transaction_type {
>>  /* last transaction type for creation of the capabilities mask */
>>  #define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
>>
>> +/**
>> + * enum dma_transfer_direction - dma transfer mode and direction indicator
>> + * @MEM_TO_MEM: Async/Memcpy mode
>> + * @MEM_TO_DEV: Slave mode & From Memory to Device
>> + * @DEV_TO_MEM: Slave mode & From Device to Memory
>> + * @DEV_TO_DEV: Slave mode & From Device to Device
>> + */
>> +enum dma_transfer_direction {
>> +     MEM_TO_MEM,
>> +     MEM_TO_DEV,
>> +     DEV_TO_MEM,
>> +     DEV_TO_DEV,
>> +};
>>
>>  /**
>>   * enum dma_ctrl_flags - DMA flags to augment operation preparation,
>> @@ -267,7 +279,7 @@ enum dma_slave_buswidth {
>>   * struct, if applicable.
>>   */
>>  struct dma_slave_config {
>> -     enum dma_data_direction direction;
>> +     enum dma_transfer_direction direction;
>
> I thought we were killing this off - surely now is a good time, rather
> than allowing it to persist with this ambiguous change of functionality.
>
>>       dma_addr_t src_addr;
>>       dma_addr_t dst_addr;
>>       enum dma_slave_buswidth src_addr_width;
>> @@ -490,11 +502,11 @@ struct dma_device {
>>
>>       struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>>               struct dma_chan *chan, struct scatterlist *sgl,
>> -             unsigned int sg_len, enum dma_data_direction direction,
>> +             unsigned int sg_len, enum dma_transfer_direction direction,
>
> Does this make any sense?  The API takes a single scatterlist of memory
> locations - so MEM_TO_MEM and DEV_TO_DEV are meaningless for this API.

so people don't give MEM_TO_MEM and DEV_TO_DEV to this function.  This
function only accept a subset of the data_transfer_direction.

if we use dma_data_direction,  this function doesn't accept
DMA_BIDIRECTIONAL and DMA_NONE as well:
  enum dma_data_direction {
          DMA_BIDIRECTIONAL = 0,
          DMA_TO_DEVICE = 1,
          DMA_FROM_DEVICE = 2,
          DMA_NONE = 3,
  };
DMA_BIDIRECTIONAL and DMA_NONE are also meaningless for this API.

i think this patch makes sense if we consider dma_data_direction is
actually mapping direction. dma_transfer_direction is a new structure
describling the real dma source and dest. and the new interleaved api
will accept all 4 directions.

>
> If it took two scatterlists and two device addresses, then maybe it would -
> but I don't see the point of this change (and all the users of this API
> also needing to change) when the API is specifically for memory scatterlist
> to/from a device.
>
> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>
-barry
