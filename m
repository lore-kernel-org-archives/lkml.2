Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0K3JmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:42:10 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:51201 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613Ab0K3JmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:42:07 -0500
Message-ID: <4CF4C6E3.1040305@stericsson.com>
Date: Tue, 30 Nov 2010 10:41:55 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500 chip version 2
References: <1290773043-8985-1-git-send-email-mattias.wallin@stericsson.com> <20101126152518.GB27663@sortiz-mobl>
In-Reply-To: <20101126152518.GB27663@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,
As you point out I fixed a lot of small things in our internal tree but I have not done
my mainlining homework for a while and I am now trying to catch up.

I will divide this patch into several small ones.

/Wallin


On 11/26/2010 04:25 PM, Samuel Ortiz wrote:
> Hi Mattias,
> 
> On Fri, Nov 26, 2010 at 01:04:03PM +0100, Mattias Wallin wrote:
>> This patch adds support for chip version 2.0.
>> One new event latch register is added to v2 - Latch12.
>> Due to hardware problems reading this address on earlier
>> versions it is treated seperately.
> Fine.
> 
> 
>> This patch also adds platform IORESOURCE irq to various
>> subdrivers to make way for their mainlining.
> That deserves a separate patch.
> 
> 
>> Removing nested interrupts to allow them to be shared
>> is also added.
> Why ? I don't see how that's related to v2 support. If that's the case, please
> prepare an addtional patch as well.
> 
> Some more comments:
> 
>>  #include <linux/kernel.h>
>>  #include <linux/slab.h>
>>  #include <linux/init.h>
>>  #include <linux/irq.h>
>> -#include <linux/delay.h>
> This is unrelated as well.
> 
> 
>> @@ -103,7 +94,10 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
>>  
>>  static int ab8500_get_chip_id(struct device *dev)
>>  {
>> -	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
>> +	struct ab8500 *ab8500;
>> +	if (!dev)
>> +		return -EINVAL;
>> +	ab8500 = dev_get_drvdata(dev->parent);
> This is a potential bug fix, that should be separated aas well.
> 
> 
> 
>> @@ -303,13 +308,33 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
>>  			continue;
>>  
>>  		do {
>> -			int bit = __ffs(status);
>> +			int bit = __ffs(value);
> Another bug fix squeezed into that patch, it seems.
> 
>> diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
>> index d63b605..fc92391 100644
>> --- a/include/linux/mfd/ab8500.h
>> +++ b/include/linux/mfd/ab8500.h
>> @@ -91,23 +91,29 @@
>>  #define AB8500_INT_ID_DET_R4F		93
>>  #define AB8500_INT_USB_CHG_DET_DONE	94
>>  #define AB8500_INT_USB_CH_TH_PROT_F	96
>> -#define AB8500_INT_USB_CH_TH_PROP_R	97
>> -#define AB8500_INT_MAIN_CH_TH_PROP_F	98
>> +#define AB8500_INT_USB_CH_TH_PROT_R    97
>> +#define AB8500_INT_MAIN_CH_TH_PROT_F   98
> This is cleanup, not relevant to this patch.
> 
> 
>>  #define AB8500_INT_MAIN_CH_TH_PROT_R	99
>>  #define AB8500_INT_USB_CHARGER_NOT_OKF	103
>> +#define AB8500_INT_ADP_SOURCE_ERROR	104
>> +#define AB8500_INT_ADP_SINK_ERROR	105
>> +#define AB8500_INT_ADP_PROBE_PLUG	106
>> +#define AB8500_INT_ADP_PROBE_UNPLUG	107
>> +#define AB8500_INT_ADP_SENSE_OFF	108
>> +#define AB8500_INT_USB_LINK_STATUS	111
>>  
>> -#define AB8500_NR_IRQS			104
>> +#define AB8500_NR_IRQS			112
>>  #define AB8500_NUM_IRQ_REGS		13
>>  
>> -#define AB8500_NUM_REGULATORS   15
>> +#define AB8500_NUM_REGULATORS		15
> Ditto.
> 
> 
>>  /**
>>   * struct ab8500 - ab8500 internal structure
>>   * @dev: parent device
>>   * @lock: read/write operations lock
>>   * @irq_lock: genirq bus lock
>> - * @revision: chip revision
>>   * @irq: irq line
>> + * @chip_id: chip revision id
>>   * @write: register write
>>   * @read: register read
>>   * @rx_buf: rx buf for SPI
>> @@ -119,7 +125,6 @@ struct ab8500 {
>>  	struct device	*dev;
>>  	struct mutex	lock;
>>  	struct mutex	irq_lock;
>> -	int		revision;
>>  	int		irq_base;
>>  	int		irq;
>>  	u8		chip_id;
> This also is irrelevant to this patch.
> 
> Bottom line: Please send properly separated patches. It helps me review them,
> and it will help you debug your code when bisecting your git trees.
> 
> Cheers,
> Samuel.
> 
