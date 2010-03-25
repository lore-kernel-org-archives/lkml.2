Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0CYWAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:00:07 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:40743 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0CYWAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qEDuDViGUBDNV4iP9bvWgbDtPVBaPvT+YaP/1t4kFYiSp9/rHPTIOsMMv8eVjQu+jK
         v117tmZ2Ux8WuB+FWu0vaJFe0sccUlFkWlQVBc31V2W4cWVxzy47GpN/YE9wmzwWwnmc
         yZH0kr1VKHukVCgv564Vo5C1wdmVCT8DHNXLQ=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
References: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
	 <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
Date: Thu, 25 Mar 2010 15:00:04 -0700
X-Google-Sender-Auth: 5813a3837f5afb9d
Message-ID: <e9c3a7c21003251500r27077cci67b1f06727be97f1@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 1:58 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 25 Mar 2010, Linus Walleij wrote:
>
>> Convert the device_is_tx_complete() operation on the
>> DMA engine to a generic device_tx_status()operation which
>> can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
>> DMA_TX_PAUSED.
>>
[..]
> General: you converted all drivers to the new .device_tx_status() API, but
> since they don't implement "residue," you left it uninitialised
> everywhere. Wouldn't it be better to set it to 0 or total length,
> depending on the complete / not complete status?

Agree that it should not be uninitialized.  At the same time I do not
want to require drivers that don't need it to go through the hassle of
looking up a byte count, so perhaps all but the drivers that want this
support can return a 'max byte count'??

>
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index 0731802..c9f2c67 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -40,11 +40,13 @@ typedef s32 dma_cookie_t;
>>   * enum dma_status - DMA transaction status
>>   * @DMA_SUCCESS: transaction completed successfully
>>   * @DMA_IN_PROGRESS: transaction not yet processed
>> + * @DMA_PAUSED: transaction is paused
>>   * @DMA_ERROR: transaction failed
>>   */
>>  enum dma_status {
>>       DMA_SUCCESS,
>>       DMA_IN_PROGRESS,
>> +     DMA_PAUSED,
>>       DMA_ERROR,
>>  };
>>
>> @@ -249,6 +251,21 @@ struct dma_async_tx_descriptor {
>>  };
>>
>>  /**
>> + * struct dma_tx_state - filled in to report the status of
>> + * a transfer.
>> + * @last: last completed DMA cookie
>> + * @used: last issued DMA cookie (i.e. the one in progress)
>> + * @residue: the remaining number of bytes left to transmit
>> + *   on the selected transfer for states DMA_IN_PROGRESS and
>> + *   DMA_PAUSED if this is implemented in the driver, else 0
>> + */
>> +struct dma_tx_state {
>> +     dma_cookie_t last;
>> +     dma_cookie_t used;
>> +     u32 residue;
>
> In the original proposal by Dan Williams the last member was "unsigned
> long pos." I don't think, even on 64-bit systems anyone would kick off a >
> 4GB transfer, but who knows... And - I don't particularly like the name
> "pos," but I do like the idea of returning bytes transfered better, than
> bytes left. Can we change this?

Things like copy_from_user() and the scsi subsystem return residue, so
only for consistency with other areas would I side with the "bytes
left" camp.

Ack to all your other comments.

--
Dan
