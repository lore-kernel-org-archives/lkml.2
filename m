Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2LTRwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:52:10 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36628 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2LTRv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:51:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iGe3Hz6OiVNDa=8c98CyNGaELfg-uRbCO0kFdpdv_gQpw@mail.gmail.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-4-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=WLVpwBo1g41BYwMUdedN3MJcmfaWwYow=RfsLC5bX1jg@mail.gmail.com>
	<CAFp+6iGe3Hz6OiVNDa=8c98CyNGaELfg-uRbCO0kFdpdv_gQpw@mail.gmail.com>
Date: Thu, 20 Dec 2012 09:51:53 -0800
Message-ID: <CAD=FV=XsqZGxhcFzFfHnFxYyT2P+HVBWP9fn6LfRAwPfb06QrA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] USB: ehci-s5p: Add phy driver support
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        yulgon.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com, kishon@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Rob Herring <rob.herring@calxeda.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 10:37 PM, Vivek Gautam
<gautamvivek1987@gmail.com> wrote:
>
> On Thu, Dec 20, 2012 at 5:00 AM, Doug Anderson <dianders@chromium.org> wrote:
>>
>> On Tue, Dec 18, 2012 at 6:43 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>>> +static void s5p_ehci_phy_enable(struct s5p_ehci_hcd *s5p_ehci)
>>> +{
>>> +       struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
>>> +
>>> +       if (s5p_ehci->phy) {
>>> +               samsung_usbphy_set_type(s5p_ehci->phy, USB_PHY_TYPE_HOST);
>>
>> This confuses me.  Why are you setting the type to host here?
>>
> Being in host controller, before calling usb_phy_init() we set type to
> Host since, with certain SOCs
> like 4210, same register has different bit settings for HOST type and
> device type. So setting this
> to Host type here make the flow of usb_phy_init to go in the direction of Host.

OK.  I think I need to study the code more...

>>>
>>> +       phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>>> +       if (IS_ERR_OR_NULL(phy)) {
>>> +               /* Fallback to pdata */
>>> +               if (!pdata) {
>>> +                       dev_err(&pdev->dev, "no platform data or transceiver defined\n");
>>> +                       return -EPROBE_DEFER;
>>
>> Shouldn't you return -EINVAL like the old code did?
>
> We are deferring the probe since the usb-phy transceiver may get
> probed after ehci/ohci controllers.
> And if we return -EINVAL like the previous code, we would end up not
> setting the phy.

OK.  Something is wrong here then, since this really isn't an error:
* It should be commented about why you're deferring.
* You shouldn't have a dev_err for something that's not fatal.

Ideally we'd want something that would force probing to happen in the
right order.  I spent a little time looking and didn't see anything,
but maybe I'm missing something obvious.  If nothing pops out, the
defer seems OK as long as it is commented well.
