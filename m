Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1AaD01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 22:26:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63007 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1AaD0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 22:26:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZRQNGq57ZvlxkvGYiJzY7QGzfdlzHSdgtlSDGg5098yqI0ZxX+ddX66ATbND2+ya0x
         VIarKzHjZMMNMZxT3B3uEyyybiWGmNBWBqOKxWWrWbiNOqRnjRBrFX5VgBtikbEn50kQ
         rbWyIQ2GdoFyPmnzDRy/W9W5MY4ws7v/OfVWI=
MIME-Version: 1.0
In-Reply-To: <1296403013-6058-1-git-send-email-thomas@wytron.com.tw>
References: <1296403013-6058-1-git-send-email-thomas@wytron.com.tw>
Date: Sun, 30 Jan 2011 19:26:24 -0800
Message-ID: <AANLkTi=5Uik+EwBRfYs_Pa77+qHngY03ezC63RC0WLQ8@mail.gmail.com>
Subject: Re: [PATCH] i2c-gpio: add devicetree support
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Albert Herranz <albert_herranz@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 30, 2011 at 7:56 AM, Thomas Chou <thomas@wytron.com.tw> wrote:
> From: Albert Herranz <albert_herranz@yahoo.es>
>
> This patch is based on an earlier patch from Albert Herranz,
> http://git.infradead.org/users/herraa1/gc-linux-2.6.git/commit/
> 9854eb78607c641ab5ae85bcbe3c9d14ac113733

That commit has a single-line description of which I don't understand
a single word (unless "wii" is what I think it is, which seems
likely). Could you please explain how that commit relates to this
patch?

> The dts binding is modified as Grant suggested. The of probing
> is merged inline instead of a separate file. It uses the newer
> of gpio probe.

It seems like a terrible idea to merge firmware-specific code into the
driver. Is there are reason why of-based platforms can't just pass the
data they need in pdata like everyone else?

Not saying that it necessarily _is_ a terrible idea, but I think the
reasoning behind it needs to be included in the patch description.

> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
>  Documentation/devicetree/bindings/gpio/i2c.txt |   39 ++++++++++++++
>  drivers/i2c/busses/i2c-gpio.c                  |   67 ++++++++++++++++++++++-
>  2 files changed, 103 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/i2c.txt
>
> diff --git a/Documentation/devicetree/bindings/gpio/i2c.txt b/Documentation/devicetree/bindings/gpio/i2c.txt
> new file mode 100644
> index 0000000..402569e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/i2c.txt

This looks a bit backwards. i2c-gpio is a i2c driver which happens to
utilize the gpio framework, not the other way around.

> @@ -0,0 +1,39 @@
> +GPIO-based I2C
> +
> +Required properties:
> +- compatible : should be "i2c-gpio".
> +- gpios : should specify GPIOs used for SDA and SCL lines, in that order.
> +Optional properties:
> +- sda-is-open-drain : present if SDA gpio is open-drain.
> +- scl-is-open-drain : present if SCL gpio is open-drain.
> +- scl-is-output-only : present if SCL is an output gpio only.

I think "present if the output driver for SCL cannot be turned off" is
more accurate. Might also be worth mentioning that this will prevent
clock stretching from working.

> --- a/drivers/i2c/busses/i2c-gpio.c
> +++ b/drivers/i2c/busses/i2c-gpio.c
> @@ -14,6 +14,9 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_i2c.h>

Do these headers provide stubs so non-of platforms won't break?

> @@ -83,11 +86,52 @@ static int __devinit i2c_gpio_probe(struct platform_device *pdev)
>        struct i2c_gpio_platform_data *pdata;
>        struct i2c_algo_bit_data *bit_data;
>        struct i2c_adapter *adap;
> +       struct device_node *np = pdev->dev.of_node;

Would be nice if this could be eliminated on non-of platforms.

>        int ret;
>
>        pdata = pdev->dev.platform_data;
> -       if (!pdata)
> -               return -ENXIO;
> +       if (!pdata) {
> +               if (np && of_gpio_count(np) >= 2) {

If that expression somehow always evaluates to false on non-of
platforms, this might be ok. But please confirm if this is the case;
otherwise, it looks like a pretty large addition to an otherwise very
small driver.

How about a tiny bit of restructuring: Move the block below into a
separate function, which is only called if some constant expression
says that of is enabled. Then you can move the declaration above
either into the if block or into the function, depending on where you
want to do the conditional above.

>  static struct platform_driver i2c_gpio_driver = {
>        .driver         = {
>                .name   = "i2c-gpio",
>                .owner  = THIS_MODULE,
> +               .of_match_table = i2c_gpio_match,

Is this field always present even when of is disabled?

Havard
