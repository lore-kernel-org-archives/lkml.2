Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab2KVU7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:59:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47691 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2KVU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:59:10 -0500
MIME-Version: 1.0
In-Reply-To: <50AD862D.40302@samsung.com>
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
	<1353535387-32106-2-git-send-email-dianders@chromium.org>
	<50AD862D.40302@samsung.com>
Date: Wed, 21 Nov 2012 20:43:57 -0800
X-Google-Sender-Auth: Qpc4rc3Hq66My5lWUGyrkZp1Cew
Message-ID: <CAD=FV=W9injFAP+Qx9Ge9zK8DxwuWBCPHc4w4Jyn3PKuX_3vkg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Handle wp-gpios from device tree
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

Thanks for the review.  See below for comments.  I'll plan on a new
patch either Monday or Tuesday when I have a chance to spin and
re-test.


On Wed, Nov 21, 2012 at 5:55 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> On 11/22/2012 07:03 AM, Doug Anderson wrote:
>> On some SoCs (like exynos5250) you need to use an external GPIO for
>> write protect.  Add support for wp-gpios to the core dw_mmc driver
>> since it could be useful across multiple SoCs.
>>
>> With this change I am able to make use of the write protect for the
>> external SD slot on exynos5250-snow.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mmc/host/dw_mmc.c |   35 +++++++++++++++++++++++++++++++++++
>>  1 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 5b41348..9c79870 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -34,6 +34,7 @@
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/of.h>
>> +#include <linux/of_gpio.h>
>>
>>  #include "dw_mmc.h"
>>
>> @@ -74,6 +75,7 @@ struct idmac_desc {
>>   * struct dw_mci_slot - MMC slot state
>>   * @mmc: The mmc_host representing this slot.
>>   * @host: The MMC controller this slot is using.
>> + * @wp_gpio: If gpio_is_valid() we'll use this to read write protect.
>>   * @ctype: Card type for this slot.
>>   * @mrq: mmc_request currently being processed or waiting to be
>>   *   processed, or NULL when the slot is idle.
>> @@ -88,6 +90,8 @@ struct dw_mci_slot {
>>       struct mmc_host         *mmc;
>>       struct dw_mci           *host;
>>
>> +     int                     wp_gpio;
>> +
>>       u32                     ctype;
>>
>>       struct mmc_request      *mrq;
>> @@ -832,6 +836,8 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
>>               read_only = 0;
>>       else if (brd->get_ro)
>>               read_only = brd->get_ro(slot->id);
>> +     else if (gpio_is_valid(slot->wp_gpio))
>> +             read_only = gpio_get_value(slot->wp_gpio);
>>       else
>>               read_only =
>>                       mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1 : 0;
>> @@ -1802,6 +1808,29 @@ static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>>                              " as 1\n");
>>       return bus_wd;
>>  }
>> +
>> +/* find the write protect gpio for a given slot; or -1 if none specified */
>> +static u32 dw_mci_of_get_wp_gpio(struct device *dev, u8 slot)
>> +{
>> +     struct device_node *np = dw_mci_of_find_slot_node(dev, slot);
>> +     int gpio;
>> +
>> +     if (!np)
>> +             return -1;
> I think good that use the error number instead of -1. Also the below code.

In this case it's not really returning an error code which is why I
chose -1.  It's returning a gpio number or anything that is a sentinel
value indicating that the GPIO is not valid.

...but you're right, an error code would work.  I'll replace with
"-EINVAL" in my next patch.

>
>> +
>> +     gpio = of_get_named_gpio(np, "wp-gpios", 0);
>> +
>> +     /* Having a missing entry is valid; return silently */
>> +     if (!gpio_is_valid(gpio))
>> +             return -1;
>> +
>> +     if (devm_gpio_request(dev, gpio, "dw-mci-wp")) {
>> +             dev_warn(dev, "gpio [%d] request failed\n", gpio);
>> +             return -1;
>> +     }
>> +
>> +     return gpio;
> gpio is int type, but return type is u32?

Good catch.  Will fix.

>
> Best Regards,
> Jaehoon Chung
>> +}
>>  #else /* CONFIG_OF */
>>  static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>>  {
>> @@ -1811,6 +1840,10 @@ static struct device_node *dw_mci_of_find_slot_node(struct device *dev, u8 slot)
>>  {
>>       return NULL;
>>  }
>> +static u32 dw_mci_of_get_wp_gpio(struct device *dev, u8 slot)
>> +{
>> +     return -1;
>> +}
>>  #endif /* CONFIG_OF */
>>
>>  static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>> @@ -1923,6 +1956,8 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>       else
>>               clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>>
>> +     slot->wp_gpio = dw_mci_of_get_wp_gpio(host->dev, slot->id);
>> +
>>       mmc_add_host(mmc);
>>
>>  #if defined(CONFIG_DEBUG_FS)
>>
>
