Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1JFGh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:37:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:50334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1JFGhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,495,1312182000"; 
   d="scan'208";a="59334787"
Message-ID: <4E8D4CA1.6040203@intel.com>
Date: Thu, 06 Oct 2011 09:37:21 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] gpio: langwell: ensure alternate function is cleared
References: <1317641767-2942-1-git-send-email-adrian.hunter@intel.com> <20111004183710.GG2870@ponder.secretlab.ca> <4E8C0CA7.2020907@intel.com> <CACxGe6tJJiX55r9z_Pvn4DMsPRyBK0qfeedNikBjVN3JHSo=+A@mail.gmail.com>
In-Reply-To: <CACxGe6tJJiX55r9z_Pvn4DMsPRyBK0qfeedNikBjVN3JHSo=+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/11 19:58, Grant Likely wrote:
> On Wed, Oct 5, 2011 at 1:52 AM, Adrian Hunter<adrian.hunter@intel.com>  wrote:
>> On 04/10/11 21:37, Grant Likely wrote:
>>>
>>> On Mon, Oct 03, 2011 at 02:36:07PM +0300, Adrian Hunter wrote:
>>>> +       ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg
>>>> * 4);
>>>
>>> This looks wrong.  It looks to me like the __iomem annotation should
>>> be added to ->reg_base.
>>>
>>> Otherwise, the patch looks okay.
>>>
>>
>> Deserves a separate patch...
>
> What order do they get applied in?</grant-being-lazy>

First one first ;-)

i.e.

gpio: langwell: ensure alternate function is cleared
gpio: langwell: declare reg_base as __iomem

Since the absence of __iomem was present before the original
patch, there is no advantage to having the second one first,
but the original patch would need to be changed as well.

>
>>
>> From: Adrian Hunter<adrian.hunter@intel.com>
>> Date: Wed, 5 Oct 2011 10:29:27 +0300
>> Subject: [PATCH] gpio: langwell: declare reg_base as __iomem
>>
>> reg_base is __iomem so add that to the declaration
>> and fix up assignment casts and types.
>>
>> Signed-off-by: Adrian Hunter<adrian.hunter@intel.com>
>> ---
>>   drivers/gpio/gpio-langwell.c |   12 ++++++------
>>   1 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
>> index 00692e8..b7465e5 100644
>> --- a/drivers/gpio/gpio-langwell.c
>> +++ b/drivers/gpio/gpio-langwell.c
>> @@ -64,7 +64,7 @@ enum GPIO_REG {
>>
>>   struct lnw_gpio {
>>         struct gpio_chip                chip;
>> -       void                            *reg_base;
>> +       void __iomem                    *reg_base;
>>         spinlock_t                      lock;
>>         unsigned                        irq_base;
>>         struct pci_dev                  *pdev;
>> @@ -78,7 +78,7 @@ static void __iomem *gpio_reg(struct gpio_chip *chip,
>> unsigned offset,
>>         u8 reg = offset / 32;
>>         void __iomem *ptr;
>>
>> -       ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg *
>> 4);
>> +       ptr = lnw->reg_base + reg_type * nreg * 4 + reg * 4;
>>         return ptr;
>>   }
>>
>> @@ -90,7 +90,7 @@ static void __iomem *gpio_reg_2bit(struct gpio_chip *chip,
>> unsigned offset,
>>         u8 reg = offset / 16;
>>         void __iomem *ptr;
>>
>> -       ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg *
>> 4);
>> +       ptr = lnw->reg_base + reg_type * nreg * 4 + reg * 4;
>>         return ptr;
>>   }
>>
>> @@ -299,7 +299,7 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
>>   static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>>                         const struct pci_device_id *id)
>>   {
>> -       void *base;
>> +       void __iomem *base;
>>         int i;
>>         resource_size_t start, len;
>>         struct lnw_gpio *lnw;
>> @@ -324,8 +324,8 @@ static int __devinit lnw_gpio_probe(struct pci_dev
>> *pdev,
>>                 dev_err(&pdev->dev, "error mapping bar1\n");
>>                 goto err3;
>>         }
>> -       irq_base = *(u32 *)base;
>> -       gpio_base = *((u32 *)base + 1);
>> +       irq_base = *(__force u32 *)base;
>> +       gpio_base = *((__force u32 *)base + 1);
>>         /* release the IO mapping, since we already get the info from bar1 */
>>         iounmap(base);
>>         /* get the register base from bar0 */
>> --
>> 1.7.6
>>
>>
>
>
>

