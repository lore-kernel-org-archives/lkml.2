Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0CaMLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:11:04 -0400
Received: from darkstar.wilibox.com ([195.14.175.138]:50874 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab0CaMK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:10:59 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 08:10:59 EDT
Message-ID: <4BB33988.9070608@gmail.com>
Date: Wed, 31 Mar 2010 15:01:12 +0300
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: Nicolas Pitre <nico@fluxnic.net>, akpm@linux-foundation.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, jamie@shareable.org
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
References: <20100325152505.17612.40158.stgit@pauliusz> <alpine.LFD.2.00.1003251225500.694@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1003251225500.694@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 06:26 PM, Nicolas Pitre wrote:
> On Thu, 25 Mar 2010, Paulius Zaleckas wrote:
>
>> We must tell GCC to use even register for variable passed
>> to ldrd instruction. Without this patch GCC 4.2.1 puts this
>> variable to r2/r3 on EABI and r3/r4 on OABI, so force it to
>> r2/r3. This does not change anything when EABI and OABI
>> compilation works OK.
>>
>> Without this patch and with OABI I get:
>>    CC      drivers/mtd/nand/orion_nand.o
>> /tmp/ccMkwOCs.s: Assembler messages:
>> /tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
>> make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1
>>
>> Signed-off-by: Paulius Zaleckas<paulius.zaleckas@gmail.com>
>
> Acked-by: Nicolas Pitre<nico@fluxnic.net>

David,

Will you take this patch?
Or you are waiting till I will add all Cc as Jamie suggested?

>
>> ---
>>
>>   drivers/mtd/nand/orion_nand.c |    8 +++++++-
>>   1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
>> index f59c074..d60fc57 100644
>> --- a/drivers/mtd/nand/orion_nand.c
>> +++ b/drivers/mtd/nand/orion_nand.c
>> @@ -60,7 +60,13 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
>>   	}
>>   	buf64 = (uint64_t *)buf;
>>   	while (i<  len/8) {
>> -		uint64_t x;
>> +		/*
>> +		 * Since GCC has no proper constraint (PR 43518)
>> +		 * force x variable to r2/r3 registers as ldrd instruction
>> +		 * requires first register to be even.
>> +		 */
>> +		register uint64_t x asm ("r2");
>> +
>>   		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
>>   		buf64[i++] = x;
>>   	}
>>

