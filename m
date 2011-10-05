Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab1JEHwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:52:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:34329 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab1JEHwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:52:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,490,1312182000"; 
   d="scan'208";a="70462434"
Message-ID: <4E8C0CA7.2020907@intel.com>
Date: Wed, 05 Oct 2011 10:52:07 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] gpio: langwell: ensure alternate function is cleared
References: <1317641767-2942-1-git-send-email-adrian.hunter@intel.com> <20111004183710.GG2870@ponder.secretlab.ca>
In-Reply-To: <20111004183710.GG2870@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/11 21:37, Grant Likely wrote:
> On Mon, Oct 03, 2011 at 02:36:07PM +0300, Adrian Hunter wrote:
>> Alternate function must be zero for the pin to act as
>> a GPIO.
>>
>> Signed-off-by: Adrian Hunter<adrian.hunter@intel.com>
>> Signed-off-by: Alan Cox<alan@linux.intel.com>
>> ---
>>   drivers/gpio/gpio-langwell.c |   27 +++++++++++++++++++++++++++
>>   1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
>> index d2eb57c..00692e8 100644
>> --- a/drivers/gpio/gpio-langwell.c
>> +++ b/drivers/gpio/gpio-langwell.c
>> @@ -59,6 +59,7 @@ enum GPIO_REG {
>>   	GRER,		/* rising edge detect */
>>   	GFER,		/* falling edge detect */
>>   	GEDR,		/* edge detect result */
>> +	GAFR,		/* alt function */
>>   };
>>
>>   struct lnw_gpio {
>> @@ -81,6 +82,31 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
>>   	return ptr;
>>   }
>>
>> +static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
>> +				   enum GPIO_REG reg_type)
>> +{
>> +	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
>> +	unsigned nreg = chip->ngpio / 32;
>> +	u8 reg = offset / 16;
>> +	void __iomem *ptr;
>> +
>> +	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
>
> This looks wrong.  It looks to me like the __iomem annotation should
> be added to ->reg_base.
>
> Otherwise, the patch looks okay.
>

Deserves a separate patch...

From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 5 Oct 2011 10:29:27 +0300
Subject: [PATCH] gpio: langwell: declare reg_base as __iomem

reg_base is __iomem so add that to the declaration
and fix up assignment casts and types.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
  drivers/gpio/gpio-langwell.c |   12 ++++++------
  1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 00692e8..b7465e5 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -64,7 +64,7 @@ enum GPIO_REG {

  struct lnw_gpio {
  	struct gpio_chip		chip;
-	void				*reg_base;
+	void __iomem			*reg_base;
  	spinlock_t			lock;
  	unsigned			irq_base;
  	struct pci_dev			*pdev;
@@ -78,7 +78,7 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, 
unsigned offset,
  	u8 reg = offset / 32;
  	void __iomem *ptr;

-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
+	ptr = lnw->reg_base + reg_type * nreg * 4 + reg * 4;
  	return ptr;
  }

@@ -90,7 +90,7 @@ static void __iomem *gpio_reg_2bit(struct gpio_chip 
*chip, unsigned offset,
  	u8 reg = offset / 16;
  	void __iomem *ptr;

-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
+	ptr = lnw->reg_base + reg_type * nreg * 4 + reg * 4;
  	return ptr;
  }

@@ -299,7 +299,7 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
  static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
  			const struct pci_device_id *id)
  {
-	void *base;
+	void __iomem *base;
  	int i;
  	resource_size_t start, len;
  	struct lnw_gpio *lnw;
@@ -324,8 +324,8 @@ static int __devinit lnw_gpio_probe(struct pci_dev 
*pdev,
  		dev_err(&pdev->dev, "error mapping bar1\n");
  		goto err3;
  	}
-	irq_base = *(u32 *)base;
-	gpio_base = *((u32 *)base + 1);
+	irq_base = *(__force u32 *)base;
+	gpio_base = *((__force u32 *)base + 1);
  	/* release the IO mapping, since we already get the info from bar1 */
  	iounmap(base);
  	/* get the register base from bar0 */
-- 
1.7.6

