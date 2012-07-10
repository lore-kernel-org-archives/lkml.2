Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2GJJgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:36:36 -0400
Received: from antcom.de ([188.40.178.216]:45122 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2GJJgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:36:33 -0400
Message-ID: <4FFBF799.9080609@antcom.de>
Date: Tue, 10 Jul 2012 11:36:25 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: axel.lin@gmail.com, riyer@nvidia.com, michael.hennerich@analog.com,
        grant.likely@secretlab.ca, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v8] input: keyboard: Add keys driver for the LPC32xx SoC
References: <1340834596-15642-1-git-send-email-stigge@antcom.de> <20120710063657.GC29257@core.coreip.homeip.net>
In-Reply-To: <20120710063657.GC29257@core.coreip.homeip.net>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry!

On 07/10/2012 08:36 AM, Dmitry Torokhov wrote:
>> +static void lpc32xx_mod_states(struct lpc32xx_kscan_drv *kscandat, int col)
>> +{
>> +	u8 key;
>> +	int row;
>> +	unsigned changed, scancode, keycode;
>> +
>> +	key = readl(LPC32XX_KS_DATA(kscandat->kscan_base, col));
>> +	changed = key ^ kscandat->lastkeystates[col];
>> +	if (changed) {
>> +		for (row = 0; row < kscandat->matrix_sz; row++) {
>> +			if (changed & (1 << row)) {
> 
> I think it could be optimized a bit of you do not scan entire "changed"
> but shift it until it reaches 0 instead.
> 
>> +	of_property_read_u32(np, "nxp,debounce-delay-ms", &kscandat->deb_clks);
>> +	of_property_read_u32(np, "nxp,scan-delay-ms", &kscandat->scan_delay);
>> +	if (!kscandat->deb_clks || !kscandat->scan_delay) {
>> +		dev_err(dev, "debounce or scan delay not specified\n");
>> +		return -ENXIO;
> 
> EINVAL suits better.
> 
>> +
>> +static int __devexit lpc32xx_kscan_remove(struct platform_device *pdev)
>> +{
>> +	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
>> +
>> +	kfree(kscandat->keymap);
> 
> This seems dangerous in case we manage IRQ fire here.
> 
>> +	free_irq(platform_get_irq(pdev, 0), pdev);
>> +	clk_put(kscandat->clk);
>> +	iounmap(kscandat->kscan_base);
>> +	release_mem_region(kscandat->io_p_start, kscandat->io_p_size);
>> +	input_unregister_device(kscandat->input);
>> +	kfree(kscandat);
>> +
>> +	return 0;
>> +}
>> +
> 
> Does the following patch (on top of your) still work with your device?

Thanks for your suggestions and for the incremental patch!

The direct implementation of your above suggestions looks good.
Unfortunately, you reordered things in probe() which leads to breakage,
e.g. NULL pointer dereference on lpc32xx_parse_dt() because you decided
to fill input->dev.parent only _afterwards_.

However, I'm fine with the 2 above suggested changes. I can post an
updated patch addressing this later today.

Are there any other changes you would require?

Thanks in advance,

Roland
