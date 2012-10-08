Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2JHFW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:22:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54754 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab2JHFW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:22:57 -0400
Message-ID: <50726319.8050900@ti.com>
Date: Mon, 8 Oct 2012 10:52:33 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <arnd@arndb.de>, <olof@lixom.net>, <rdunlap@xenotime.net>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: OMAP: ocp2scp: create omap device for ocp2scp
References: <1349431628-2819-1-git-send-email-kishon@ti.com> <1349431628-2819-4-git-send-email-kishon@ti.com> <506F5F69.6040104@mvista.com>
In-Reply-To: <506F5F69.6040104@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 06 October 2012 04:00 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 05-10-2012 12:07, Kishon Vijay Abraham I wrote:
>
>> Platfrom device for ocp2scp is created using omap_device_build in
>> devices file. This is used for both omap4(musb) and omap5(dwc3).
>>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>> ---
>>   arch/arm/mach-omap2/devices.c |   72
>> +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 72 insertions(+)
>>
>> diff --git a/arch/arm/mach-omap2/devices.c
>> b/arch/arm/mach-omap2/devices.c
>> index c8c2117..e2ba505 100644
>> --- a/arch/arm/mach-omap2/devices.c
>> +++ b/arch/arm/mach-omap2/devices.c
> [...]
>> @@ -613,6 +614,76 @@ static void omap_init_vout(void)
> [...]
>
>> +static void omap_init_ocp2scp(void)
>> +{
>> +    struct omap_hwmod    *oh;
>> +    struct platform_device    *pdev;
>> +    int            bus_id = -1, dev_cnt = 0, i;
>> +    struct omap_ocp2scp_dev    *ocp2scp_dev;
>> +    const char        *oh_name, *name;
>> +    struct omap_ocp2scp_platform_data *pdata;
>> +
>> +    oh_name = "ocp2scp_usb_phy";
>> +    name    = "omap-ocp2scp";
>> +
>> +    oh = omap_hwmod_lookup(oh_name);
>> +    if (!oh) {
>> +        pr_err("%s: could not find omap_hwmod for %s\n", __func__,
>> +                                oh_name);
>> +        return;
>> +    }
>> +
>> +    pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
>> +    if (!pdata) {
>> +        pr_err("%s: No memory for ocp2scp pdata\n", __func__);
>> +        return;
>> +    }
>> +
>> +    ocp2scp_dev = oh->dev_attr;
>> +    dev_cnt = count_ocp2scp_devices(ocp2scp_dev);
>> +
>> +    if (!dev_cnt) {
>> +        pr_err("%s: No devices connected to ocp2scp\n", __func__);
>> +        return;
>
>     Don't you leak 'pdata' here?
>
>> +    }
>> +
>> +    pdata->devices = kzalloc(sizeof(struct omap_ocp2scp_dev *)
>> +                    * dev_cnt, GFP_KERNEL);
>> +    if (!pdata->devices) {
>> +        pr_err("%s: No memory for ocp2scp pdata devices\n", __func__);
>> +        return;
>> +    }
>> +
>> +    for (i = 0; i<  dev_cnt; i++, ocp2scp_dev++)
>> +        pdata->devices[i] = ocp2scp_dev;
>> +
>> +    pdata->dev_cnt    = dev_cnt;
>> +
>> +    pdev = omap_device_build(name, bus_id, oh, pdata, sizeof(*pdata),
>> NULL,
>> +                                0, false);
>> +    if (IS_ERR(pdev)) {
>> +        pr_err("Could not build omap_device for %s %s\n",
>> +                        name, oh_name);
>> +        return;
>
>     Don't you leak 'pdata' and 'pdata->devices' here?

Will re-post the patch fixing it.

Thanks
Kishon
