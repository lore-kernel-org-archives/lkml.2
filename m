Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2DYMrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:47:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab2DYMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:47:15 -0400
Date: Wed, 25 Apr 2012 14:47:09 +0200
From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add support for TCA6424
References: <1335275311-29305-1-git-send-email-Andreas.Schallenberg@3alitytechnica.com> <0MRjfF-1SpZmY071F-00SzLk@mrelayeu.kundenserver.de> <CACRpkda8koBp1xmLaRHDpOEAMLWZ-jr_4xmYWaD4NLzsWsXikw@mail.gmail.com>
In-Reply-To: <CACRpkda8koBp1xmLaRHDpOEAMLWZ-jr_4xmYWaD4NLzsWsXikw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-KSE-AntiSpam-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Message-Id: <0LmwP6-1RkO1L2N1I-00hCkZ@mrelayeu.kundenserver.de>
X-Provags-ID: V02:K0:igOijBF+koR6Ch8pBCEZ1in+sQzcYMWbEBOnmRUM6pF
 Ohz9Nv313LNpI6pEWjixiZp8RBHxnADEMNwg4uw95GHOXQ+X0J
 OXBg1YHcg1H3SwmHqi5cDUaOaKym1GS5rv53YkNooMEzkFP5xA
 wI4kx3Uhvka7FmrjoUEi2rsQ1l+Nn70tlDKdU8EmI9+FDaDlYa
 h/Bl2vUUOp5V8gERZ8KnmLwsiM8sVVH3bRNe+IF2UC+/Eo5HSr
 oH0IyV9XMVipIVU61RTLx4beAzDVAjFw0UD/bS5wpbWekcWsoy
 jQ9oQJVbgxh3fQxPVGc3DPI9KljQVDmnSkBSgZ0HmxrB7uzTk/
 ZUlbLoVpdRwO9lvalQMKfX3Qmp653txYXprsKxitgNcZBE5hVK
 Ap4PsNMzmbkfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.04.2012 13:02, Linus Walleij wrote:
> On Tue, Apr 24, 2012 at 3:48 PM, Andreas Schallenberg
> <Andreas.Schallenberg@3alitytechnica.com>  wrote:
>
>> From: Andreas Schallenberg<aschallenberg@GWS026Linux.(none)>
> Some more detailed commit blurb here detailing some TC6424 characteristics
> maybe?
Yes, I'll add it.

>>   struct pca953x_chip {
>>         unsigned gpio_start;
>> -       uint16_t reg_output;
>> -       uint16_t reg_direction;
>> +       uint reg_output;
>> +       uint reg_direction;
>>         struct mutex i2c_lock;
> So ther are not 16bit?
>
> Suggest using the kernel-internal u16 otherwise.
> Or u32 if they really are 32bit. Which I suspect they are.
>
> Or if they are 24bit as I see in some below code,
Yes, it is a 24 bit I/O expander.


>   cosider:
>
> u32 foo:24;
Nice. Haven't seen this before.

>> -static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
>> +static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint val)
> u32?
Changing to u32.
>>         if (chip->gpio_chip.ngpio<= 8)
>>                 ret = i2c_smbus_write_byte_data(chip->client, reg, val);
>> +       else if (chip->gpio_chip.ngpio>  16) {
>> +               ret = i2c_smbus_write_word_data(chip->client,
>> +                                               (reg<<  2) | REG_ADDR_AI,
>> +                                               val&  0xffff);
>> +               ret = i2c_smbus_write_byte_data(chip->client,
>> +                                               (reg<<  2) + 2,
>> +                                               (val&  0xff0000)>>  16);
>> +       }
>>         else {
>>                 switch (chip->chip_type) {
>>                 case PCA953X_TYPE:
> And you are positively certain that this does not create a problem
> on other chips in this familym or is this the only chip with
>> 16 IRQs?
All the other chips supported by this driver have 8 or 16 GPIOs. Its the 
only one with 24.

>> @@ -121,12 +131,17 @@ static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
>>         return 0;
>>   }
>>
>> -static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
>> +static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint *val)
> u32?
Changing to u32.

>>   {
>>         int ret;
>>
>>         if (chip->gpio_chip.ngpio<= 8)
>>                 ret = i2c_smbus_read_byte_data(chip->client, reg);
>> +       else if (chip->gpio_chip.ngpio == 24) {
> So is the comparison going to be>  16 (as above) or ==24 as here?
> Decide for *one* way of detecting.
Switching to == 24 in both places.
>> @@ -135,14 +150,14 @@ static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
>>                 return ret;
>>         }
>>
>> -       *val = (uint16_t)ret;
>> +       *val = (uint)ret;
> u32?
>
Changing to u32.
>>   static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
>>   {
>>         struct pca953x_chip *chip;
>> -       uint16_t reg_val;
>> +       uint reg_val;
> u32?
Changing to u32.
>> @@ -173,7 +188,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
>>                 unsigned off, int val)
>>   {
>>         struct pca953x_chip *chip;
>> -       uint16_t reg_val;
>> +       uint reg_val;
> u32?
Changing to u32.
>> @@ -223,7 +238,7 @@ exit:
>>   static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
>>   {
>>         struct pca953x_chip *chip;
>> -       uint16_t reg_val;
>> +       uint reg_val;
> u32?
Changing to u32.
>> @@ -253,7 +268,7 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
>>   static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
>>   {
>>         struct pca953x_chip *chip;
>> -       uint16_t reg_val;
>> +       uint reg_val;
> u32?
Changing to u32.

>> @@ -386,7 +401,7 @@ static struct irq_chip pca953x_irq_chip = {
>>
>>   static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
>>   {
>> -       uint16_t cur_stat;
>> +       uint     cur_stat;
> u32?
Changing to u32.
>> @@ -449,6 +464,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>>   {
>>         struct i2c_client *client = chip->client;
>>         int ret, offset = 0;
>> +       uint temporary;
> u32?
Changing to u32.
>> @@ -606,7 +623,7 @@ out:
>>   static int __devinit device_pca957x_init(struct pca953x_chip *chip, int invert)
>>   {
>>         int ret;
>> -       uint16_t val = 0;
>> +       uint val = 0;
> u32?
Changing to u32.

Thanks for the review, will send an updated patch.

Regards,
Andreas
