Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1AaIJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:09:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1AaIJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:09:23 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=5Uik+EwBRfYs_Pa77+qHngY03ezC63RC0WLQ8@mail.gmail.com>
References: <1296403013-6058-1-git-send-email-thomas@wytron.com.tw> <AANLkTi=5Uik+EwBRfYs_Pa77+qHngY03ezC63RC0WLQ8@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 01:09:02 -0700
X-Google-Sender-Auth: AA9KRke1F2QPFxq9xSWFHWeya6E
Message-ID: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
Subject: Re: [PATCH] i2c-gpio: add devicetree support
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
Cc: Thomas Chou <thomas@wytron.com.tw>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 8:26 PM, Håvard Skinnemoen
<hskinnemoen@gmail.com> wrote:
> Hi,
>
> On Sun, Jan 30, 2011 at 7:56 AM, Thomas Chou <thomas@wytron.com.tw> wrote:
>> From: Albert Herranz <albert_herranz@yahoo.es>
>>
>> This patch is based on an earlier patch from Albert Herranz,
>> http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/
>> 9854eb78607c641ab5ae85bcbe3c9d14ac113733
>
> That commit has a single-line description of which I don't understand
> a single word (unless "wii" is what I think it is, which seems
> likely). Could you please explain how that commit relates to this
> patch?

The URL got wrapped.  Try this one (assuming my mailer doesn't wrap it):

http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/9854eb78607c641ab5ae85bcbe3c9d14ac113733

>
>> The dts binding is modified as Grant suggested. The of probing
>> is merged inline instead of a separate file. It uses the newer
>> of gpio probe.
>
> It seems like a terrible idea to merge firmware-specific code into the
> driver. Is there are reason why of-based platforms can't just pass the
> data they need in pdata like everyone else?

Overall Thomas is doing the right thing here.  The driver data has to
be decoded *somewhere*, but since that code is definitely
driver-specific (as opposed to platform, subsystem, or arch specific)
putting it into the driver is absolutely the right thing to do.  Quite
a few drivers now do exactly this.

It is however generally a wise practice to limit the of-support code
to a hook in the drivers probe hook, and as you point out, care must
be taken to make sure both CONFIG_OF and !CONFIG_OF kernel builds
work.

>
> Not saying that it necessarily _is_ a terrible idea, but I think the
> reasoning behind it needs to be included in the patch description.

Nah, he doesn't really need to defend this since it is a well
established pattern.  device tree support is in core code now (see
of_node an of_match_table in include/linux/device.h), and other
drivers do exactly this.

>> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
>> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>> ---
>>  Documentation/devicetree/bindings/gpio/i2c.txt |   39 ++++++++++++++
>>  drivers/i2c/busses/i2c-gpio.c                  |   67 ++++++++++++++++++++++-
>>  2 files changed, 103 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/gpio/i2c.txt
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/i2c.txt b/Documentation/devicetree/bindings/gpio/i2c.txt
>> new file mode 100644
>> index 0000000..402569e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/i2c.txt
>
> This looks a bit backwards. i2c-gpio is a i2c driver which happens to
> utilize the gpio framework, not the other way around.

Yes, this should be in devicetree/bindings/i2c/i2c-gpio.txt

>
>> @@ -0,0 +1,39 @@
>> +GPIO-based I2C
>> +
>> +Required properties:
>> +- compatible : should be "i2c-gpio".
>> +- gpios : should specify GPIOs used for SDA and SCL lines, in that order.
>> +Optional properties:
>> +- sda-is-open-drain : present if SDA gpio is open-drain.
>> +- scl-is-open-drain : present if SCL gpio is open-drain.
>> +- scl-is-output-only : present if SCL is an output gpio only.
>
> I think "present if the output driver for SCL cannot be turned off" is
> more accurate. Might also be worth mentioning that this will prevent
> clock stretching from working.
>
>> --- a/drivers/i2c/busses/i2c-gpio.c
>> +++ b/drivers/i2c/busses/i2c-gpio.c
>> @@ -14,6 +14,9 @@
>>  #include <linux/module.h>
>>  #include <linux/slab.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/of_i2c.h>
>
> Do these headers provide stubs so non-of platforms won't break?

yes.

>
>> @@ -83,11 +86,52 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
>>        struct i2c_gpio_platform_data *pdata;
>>        struct i2c_algo_bit_data *bit_data;
>>        struct i2c_adapter *adap;
>> +       struct device_node *np = pdev->dev.of_node;
>
> Would be nice if this could be eliminated on non-of platforms.

It's pretty benign.  However, for current mainline this needs to be
protected with a #ifdef CONFIG_OF.  In 2.6.29, the conditional can be
removed since of_node will be a permanent part of struct device.

>
>>        int ret;
>>
>>        pdata = pdev->dev.platform_data;
>> -       if (!pdata)
>> -               return -ENXIO;
>> +       if (!pdata) {
>> +               if (np && of_gpio_count(np) >= 2) {
>
> If that expression somehow always evaluates to false on non-of
> platforms, this might be ok. But please confirm if this is the case;
> otherwise, it looks like a pretty large addition to an otherwise very
> small driver.
>
> How about a tiny bit of restructuring: Move the block below into a
> separate function, which is only called if some constant expression
> says that of is enabled. Then you can move the declaration above
> either into the if block or into the function, depending on where you
> want to do the conditional above.

Yes, moving the dt decoding code to a separate function would keep the
dt-support better isolated from the core of the driver and would make
the CONFIG_OF/!CONFIG_OF handling better.

>
>>  static struct platform_driver i2c_gpio_driver = {
>>        .driver         = {
>>                .name   = "i2c-gpio",
>>                .owner  = THIS_MODULE,
>> +               .of_match_table = i2c_gpio_match,
>
> Is this field always present even when of is disabled?

No, not yet.  It will be in 2.6.29.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
