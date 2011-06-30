Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1F3VCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:02:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45013 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1F3VCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E0CE332.4040102@gmail.com>
References: <20110630185921.13784.3823.stgit@ponder> <4E0CE332.4040102@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Jun 2011 15:01:45 -0600
X-Google-Sender-Auth: gbyppzAxKwFiHXhnTQ6s5ox1xV8
Message-ID: <BANLkTikw_102PfPtUKhoDrAKnwuJRCtYdg@mail.gmail.com>
Subject: Re: [PATCH] tty/serial: change of_serial to use new
 of_property_read_u32() api
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 2:57 PM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> On 06/30/2011 02:00 PM, Grant Likely wrote:
>> Simplifies the code a bit and drops a few lines.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> I've only actually build tested this, but this shows some of the cleanup
>> achieved using the of_property_read_u32() API.  If this gets merged in the
>> v3.1 merge window then it will need to go via the devicetree/next branch.
>>
>> g.
>
> You can't give yourself bonus points. ;)
>
>>
>>  drivers/tty/serial/of_serial.c |   37 +++++++++++++++----------------------
>>  1 files changed, 15 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
>> index 36038ed..dbfbfda 100644
>> --- a/drivers/tty/serial/of_serial.c
>> +++ b/drivers/tty/serial/of_serial.c
>> @@ -32,17 +32,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>>  {
>>       struct resource resource;
>>       struct device_node *np = ofdev->dev.of_node;
>> -     const __be32 *clk, *spd;
>> -     const __be32 *prop;
>> -     int ret, prop_size;
>> +     u32 clk, spd, prop;
>> +     int ret;
>>
>>       memset(port, 0, sizeof *port);
>> -     spd = of_get_property(np, "current-speed", NULL);
>> -     clk = of_get_property(np, "clock-frequency", NULL);
>> -     if (!clk) {
>> +     if (of_property_read_u32(np, "clock-frequency", &clk)) {
>
> s/clk/port->uartclk/
>
> And below, then remove clk.
>
>>               dev_warn(&ofdev->dev, "no clock-frequency property set\n");
>>               return -ENODEV;
>>       }
>> +     /* If current-speed was set, then try not to change it. */
>> +     if (of_property_read_u32(np, "current-speed", &spd) == 0)
>> +             port->custom_divisor = clk / (16 * spd);
>>
>>       ret = of_address_to_resource(np, 0, &resource);
>>       if (ret) {
>> @@ -54,20 +54,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>>       port->mapbase = resource.start;
>>
>>       /* Check for shifted address mapping */
>> -     prop = of_get_property(np, "reg-offset", &prop_size);
>> -     if (prop && (prop_size == sizeof(u32)))
>> -             port->mapbase += be32_to_cpup(prop);
>> +     if (of_property_read_u32(np, "reg-offset", &prop) == 0)
>> +             port->mapbase += prop;
>>
>>       /* Check for registers offset within the devices address range */
>> -     prop = of_get_property(np, "reg-shift", &prop_size);
>> -     if (prop && (prop_size == sizeof(u32)))
>> -             port->regshift = be32_to_cpup(prop);
>> +     if (of_property_read_u32(np, "reg-shift", &prop) == 0)
>> +             port->regshift = prop;
>
> Can be further simplified:
>
> of_property_read_u32(np, "reg-shift", &port->regshift);

Hey Rob, thanks for the review.

I thought about that, but the new api specifically needs to be passed
a u32 pointer, not an unsigned char pointer which is what is in the
port structure.  That goes for the clk value too.  Even for unsigned
int values, i need the u32 bounce variable because it would break on
64 bit platforms.

g.
