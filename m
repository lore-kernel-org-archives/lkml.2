Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab0JSIh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:37:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:26784 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab0JSIhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:37:23 -0400
X-IronPort-AV: E=Sophos;i="4.57,349,1283745600"; 
   d="scan'208";a="23630603"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Tue, 19 Oct 2010 09:37:17 +0100
Subject: RE: [PATCH 1/2] gpio: adp5588-gpio: support interrupt controller
Thread-Topic: [PATCH 1/2] gpio: adp5588-gpio: support interrupt controller
Thread-Index: ActvGRxkarjo74jLQX283MABHDRAqAASc2hw
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713094521211@LIMKCMBX1.ad.analog.com>
References: <1287442218-7265-1-git-send-email-vapier@gentoo.org>
 <20101018160630.89b8200f.akpm@linux-foundation.org>
In-Reply-To: <20101018160630.89b8200f.akpm@linux-foundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2010-10-19:
> On Mon, 18 Oct 2010 18:50:17 -0400
> Mike Frysinger <vapier@gentoo.org> wrote:
>
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> This patch implements irq_chip functionality on ADP5588/5587 GPIO
>> expanders.  Only level sensitive interrupts are supported.
>> Interrupts provided by this irq_chip must be requested using
>> request_threaded_irq().
>>
>>
>> ...
>>
>> + /* Configuration Register1 */
>> +#define AUTO_INC    (1 << 7)
>> +#define GPIEM_CFG   (1 << 6)
>> +#define OVR_FLOW_M  (1 << 5)
>> +#define INT_CFG             (1 << 4)
>> +#define OVR_FLOW_IEN        (1 << 3)
>> +#define K_LCK_IM    (1 << 2)
>> +#define GPI_IEN             (1 << 1)
>> +#define KE_IEN              (1 << 0)
>> +
>> +/* Interrupt Status Register */
>> +#define GPI_INT             (1 << 1)
>> +#define KE_INT              (1 << 0)
>
> All copied-n-pasted from drivers/input/keyboard/adp5588-keys.c?
>
> Bad.  Put it in a shared header file please.

Can do - but I then need to touch the input driver as well.

> It might be a good idea to rename them all as well.  Things like
> INT_CFG are rather generic and there is a risk of conflict against
> unrelated headers which use the same symbols.
>
>>  #define DRV_NAME            "adp5588-gpio"
>>  #define MAXGPIO                     18
>>  #define ADP_BANK(offs)              ((offs) >> 3)
>>  #define ADP_BIT(offs)               (1u << ((offs) & 0x7))
>> +/*
>> + * Early pre 4.0 Silicon required to delay readout by at least
>> +25ms,
>> + * since the Event Counter Register updated 25ms after the
>> +interrupt
>> + * asserted.
>> + */
>> +#define WA_DELAYED_READOUT_REVID(rev)               ((rev) < 4)
>> +
>>  struct adp5588_gpio {
>>      struct i2c_client *client;
>>      struct gpio_chip gpio_chip;
>>      struct mutex lock;      /* protect cached dir, dat_out */
>> +    struct mutex irq_lock;  /* P: IRQ */
>
> One wonders what "P: IRQ" means.

Protect serialized access to the interrupt controller bus

>
> It's rare for code to be damaged by excessively verbose description of
> struct fields ;)
>
>>      unsigned gpio_start; +  unsigned irq_base;      uint8_t dat_out[3];
>>      uint8_t dir[3];
>> +    uint8_t int_lvl[3];
>> +    uint8_t int_en[3];
>> +    uint8_t irq_mask[3];
>> +    uint8_t irq_stat[3];
>>  };
>>
>> ...
>>
>> +static void adp5588_irq_bus_sync_unlock(unsigned int irq) {
>> +    struct adp5588_gpio *dev = get_irq_chip_data(irq);
>> +    int i;
>> +
>> +    for (i = 0; i <= ADP_BANK(MAXGPIO); i++)
>> +            if (dev->int_en[i] ^ dev->irq_mask[i]) {
>> +                    dev->int_en[i] = dev->irq_mask[i];
>> +                    adp5588_gpio_write(dev->client, GPIO_INT_EN1 + i,
>> +                                       dev->int_en[i]);
>> +            }
>
> Some description of what this code is doing and why it does it would
> be useful.  This drive-by reader doesn't have a clue.

genirq core code can issue chip->mask/unmask from atomic context.
This doesn't work for slow busses where an access needs to sleep.
bus_sync_unlock() is therefore called outside the atomic context,
syncs the current irq mask state with the slow external controller
and unlocks the bus.

http://www.kerneltrap.com/mailarchive/git-commits-head/2009/9/11/2253


>> +    mutex_unlock(&dev->irq_lock);
>> +}
>> +
>>
>> ...
>>
>> +static int adp5588_irq_set_type(unsigned int irq, unsigned int
>> +type) {
>> +    struct adp5588_gpio *dev = get_irq_chip_data(irq);
>> +    uint16_t gpio = irq - dev->irq_base;
>> +    unsigned bank, bit;
>> +
>> +    if ((type & IRQ_TYPE_EDGE_BOTH)) {
>> +            dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
>> +                    irq, type);
>> +            return -EINVAL;
>> +    }
>> +
>> +    bank = ADP_BANK(gpio);
>> +    bit = ADP_BIT(gpio);
>> +
>> +    if (type & IRQ_TYPE_LEVEL_HIGH)
>> +            dev->int_lvl[bank] |= bit;
>> +    else if (type & IRQ_TYPE_LEVEL_LOW)
>> +            dev->int_lvl[bank] &= ~bit;
>> +    else
>> +            return -EINVAL;
>> +
>> +    might_sleep();
>
> Seems a bit unnecessary - adp5588_gpio_direction_input() does a
> mutex_lock() and mutex_lock() does a might_sleep().

I see

>> +    adp5588_gpio_direction_input(&dev->gpio_chip, gpio);
>> +    adp5588_gpio_write(dev->client, GPIO_INT_LVL1 + bank,
>> +                       dev->int_lvl[bank]);
>> +
>> +    return 0;
>> +}
>> +
>>
>> ...
>>
>> +static int adp5588_irq_setup(struct adp5588_gpio *dev) { +  struct
>> i2c_client *client = dev->client; +  struct adp5588_gpio_platform_data
>> *pdata = client- dev.platform_data; +        unsigned gpio; +        int ret; +
>> +    adp5588_gpio_write(client, CFG, AUTO_INC);
>> +    adp5588_gpio_write(client, INT_STAT, -1); /* status is W1C */
>> +    adp5588_gpio_read_intstat(client, dev->irq_stat); /* read to clear
>> +*/ + +      dev->irq_base = pdata->irq_base; +      mutex_init(&dev->irq_lock);
>> + +  for (gpio = 0; gpio < dev->gpio_chip.ngpio; gpio++) { +         int irq =
>> gpio + dev->irq_base; +              set_irq_chip_data(irq, dev);
>> +            set_irq_chip_and_handler(irq, &adp5588_irq_chip, +
>> handle_level_irq); +         set_irq_nested_thread(irq, 1); +#ifdef CONFIG_ARM
>> +            set_irq_flags(irq, IRQF_VALID); +#else +                set_irq_noprobe(irq);
>> +#endif
>
> Needs a code comment explaining why ARM is different.  How am I
> possibly to review this without mind-reading powers?
>
> Why _is_ ARM different?  Is something busted?

ARM needs us to explicitly flag the IRQ as VALID,
once we do so, it will also set the noprobe.

Honestly I'm not an ARM expert - I don't know why ARM is different here
- but this is what many other interrupt chips do here as well.

>> +    }
>> +
>> +    ret = request_threaded_irq(client->irq,
>> +                               NULL,
>> +                               adp5588_irq_handler,
>> +                               IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +                               dev_name(&client->dev), dev);
>> +    if (ret) {
>> +            dev_err(&client->dev, "failed to request irq %d\n",
>> +                    client->irq);
>> +            goto out;
>> +    }
>> +
>> +    dev->gpio_chip.to_irq = adp5588_gpio_to_irq;
>> +    adp5588_gpio_write(client, CFG, AUTO_INC | INT_CFG | GPI_INT);
>> +
>> +    return 0;
>> +
>> +out:
>> +    dev->irq_base = 0;
>> +    return ret;
>> +}
>> +static void adp5588_irq_teardown(struct adp5588_gpio *dev)
>
> Missing a newline.
>
>> +{
>> +    if (dev->irq_base)
>> +            free_irq(dev->client->irq, dev);
>> +}
>> +
>> +#else
>> +static int adp5588_irq_setup(struct adp5588_gpio *dev) {
>> +    struct i2c_client *client = dev->client;
>> +    dev_warn(&client->dev, "interrupt support not compiled in\n");
>> +
>> +    return 0;
>> +}
>> +
>>
>> ...
>>

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


