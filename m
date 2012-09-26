Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2IZFk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:40:56 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:53930 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398Ab2IZFku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:40:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120919115647.GI3772@arwen.pp.htv.fi>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
	<1348054229-27362-5-git-send-email-kishon@ti.com>
	<20120919115647.GI3772@arwen.pp.htv.fi>
Date: Wed, 26 Sep 2012 11:10:48 +0530
Message-ID: <CAAe_U6Kr8t1=T7MGMjAe+1n6S-NncypnPkXYqA2_FtVK=uxULA@mail.gmail.com>
Subject: Re: [PATCH 4/4] usb: phy: omap-usb2: enable 960Mhz clock for omap5
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 19, 2012 at 5:26 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Sep 19, 2012 at 05:00:29PM +0530, Kishon Vijay Abraham I wrote:
>> "usb_otg_ss_refclk960m" is needed by usb2 phy present in omap5. For
>> omap4, the clk_get of this clock will fail since it does not have this
>> clock.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  Documentation/devicetree/bindings/usb/usb-phy.txt |    3 +++
>>  drivers/usb/phy/omap-usb2.c                       |   28 ++++++++++++++++++++-
>>  2 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> index 7c5fd89..d5626de 100644
>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> @@ -24,6 +24,9 @@ Required properties:
>>  add the address of control module phy power register until a driver for
>>  control module is added
>>
>> +Optional properties:
>> + - has960mhzclk: should be added if the phy needs 960mhz clock
>> +
>>  This is usually a subnode of ocp2scp to which it is connected.
>>
>>  usb3phy@4a084400 {
>> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
>> index d36c282..d6612ba 100644
>> --- a/drivers/usb/phy/omap-usb2.c
>> +++ b/drivers/usb/phy/omap-usb2.c
>> @@ -146,6 +146,7 @@ static int __devinit omap_usb2_probe(struct platform_device *pdev)
>>       struct omap_usb                 *phy;
>>       struct usb_otg                  *otg;
>>       struct resource                 *res;
>> +     struct device_node              *np = pdev->dev.of_node;
>>
>>       phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>>       if (!phy) {
>> @@ -190,6 +191,15 @@ static int __devinit omap_usb2_probe(struct platform_device *pdev)
>>       }
>>       clk_prepare(phy->wkupclk);
>>
>> +     if (of_property_read_bool(np, "has960mhzclk")) {
>> +             phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
>> +             if (IS_ERR(phy->optclk)) {
>> +                     dev_err(&pdev->dev, "unable to get refclk960m\n");
>> +                     return PTR_ERR(phy->optclk);
>> +             }
>> +             clk_prepare(phy->optclk);
>> +     }
>
> instead, can't you just always try to get the clock but ignore the error
> if it fails ?

This clock is needed for usb2 to work in dwc3 (omap5). So we have to
report the error in case we dont get the clock no?

Thanks
Kishon
