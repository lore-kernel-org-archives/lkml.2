Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3ABPTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:19:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39114 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3ABPTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:19:18 -0500
Message-ID: <50E44FEC.3080009@ti.com>
Date: Wed, 2 Jan 2013 10:19:08 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <spi-devel-general@lists.sourceforge.net>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Thomas Gleixner <tglx@linuronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: davinci: use request_threaded_irq() to fix deadlock
References: <1356120806-27964-1-git-send-email-m-karicheri2@ti.com> <20121222100803.88FCE3E0AD0@localhost>
In-Reply-To: <20121222100803.88FCE3E0AD0@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 05:08 AM, Grant Likely wrote:
> On Fri, 21 Dec 2012 15:13:26 -0500, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>> With RT pre-empt patch applied to Linux kernel, the irq handler will be
>> force converted to an irq thread. spi driver can get back to back messages
>> from the slave device. In such cases, IRQ thread doesn't get a chance to
>> run to read the slave data. Hence the irq handler must be run in hard irq
>> context to read/write data from slave device. Otherwise, the kernel goes
>> into a deadlock. This patch fixes this issue when PREEMPT_RT_FULL is
>> enabled in the kernel. A dummy thread function is provided to satisfy the
>> request_threaded_irq() API. Passing a NULL for function also causes the
>> irq handler to be executed in the thread context.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
> Thomas, would you mind taking a look at this for me. My gut feel is that
> this is the wrong way to solve the problem that Murali is having and
> that it really just hacks something that works.
Grant,

Thanks for reviewing this. As per the RT patch, all of the IRQ handlers 
will be converted to thread by brute force. This breaks the SPI driver 
since the data is overwritten with back to back irq as thread is not 
getting a chance to read the word before next irq happens.  What my 
patch does is to keep the functionality as before by using a new irq 
API. So though this is not the best solution, this solves the problem 
and give an opportunity for improvement by splitting this into two part 
to handle the irq. But I am not convinced if this is really needed.

As you might know, there are 3 ways to process the SPI data transfer. 
Polling, IRQ and DMA. As part of the IRQ handling, basically, driver 
needs to write a register in the SPI controller chip to send a word of 
data, if available to send or receive a word. That means the amount of 
processing at irq handling is time taken for two register accesses and 
checks to see if we have completed the transaction. But if we are 
reading data from a NOR flash connected to the SPI bus, then mostly so 
many interrupts happens right after a write of a command to the SPI 
slave device and causes several interrupts and CPU usage for IRQ 
handling and may results in latency for other interrupts. We might be 
able to read the word and add it to a list as part of IRQ and handle it 
in a thread. Similarly if a write is required, handle it as part of the 
thread. But even then one SPI register read has to happen in the IRQ 
handler for the incoming word .
So in terms of CPU usage, we would save one register write, but will 
have to add additional code to add the word to a list. Does this warrant 
change in the code? If CPU usage is an issue, driver could be configured 
to do DMA. May be I am missing something that you or Thomas know.

I will wait for a response from Thomas.

Thanks.

Murali
> It seems to me that what the driver should do is disable the irq
> in the handler, and then perform the regular work in the thread. After
> all the pending data is processed, then it should reenable the interrupts.
>
> Passing in a dummy thread function just looks wrong.
>
> g.

>> ---
>>   drivers/spi/spi-davinci.c |   17 +++++++++++++++--
>>   1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
>> index 50bd2cd..8234d22 100644
>> --- a/drivers/spi/spi-davinci.c
>> +++ b/drivers/spi/spi-davinci.c
>> @@ -702,6 +702,19 @@ err_alloc_dummy_buf:
>>   }
>>
>>   /**
>> + * dummy_thread_fn - dummy thread function
>> + * @irq: IRQ number for this SPI Master
>> + * @context_data: structure for SPI Master controller davinci_spi
>> + *
>> + * This is to satisfy the request_threaded_irq() API so that the irq
>> + * handler is called in interrupt context.
>> + */
>> +static irqreturn_t dummy_thread_fn(s32 irq, void *data)
>> +{
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +/**
>>    * davinci_spi_irq - Interrupt handler for SPI Master Controller
>>    * @irq: IRQ number for this SPI Master
>>    * @context_data: structure for SPI Master controller davinci_spi
>> @@ -899,8 +912,8 @@ static int davinci_spi_probe(struct platform_device *pdev)
>>   		goto unmap_io;
>>   	}
>>
>> -	ret = request_irq(dspi->irq, davinci_spi_irq, 0, dev_name(&pdev->dev),
>> -									dspi);
>> +	ret = request_threaded_irq(dspi->irq, davinci_spi_irq, dummy_thread_fn,
>> +				 0, dev_name(&pdev->dev), dspi);
>>   	if (ret)
>>   		goto unmap_io;
>>
>> -- 
>> 1.7.9.5
>>

