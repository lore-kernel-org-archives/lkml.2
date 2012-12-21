Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2LUVBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:01:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51348 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LUVBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:01:39 -0500
Message-ID: <50D4CE2F.1090303@wwwdotorg.org>
Date: Fri, 21 Dec 2012 14:01:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: stern@rowland.harvard.edu, gregkh@linuxfoundation.org, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: tegra: Removing dependency on PHY instance number
References: <1356073105-13043-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1356073105-13043-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 11:58 PM, Venu Byravarasu wrote:
> Tegra2 has two varieties of USB PHYs:
> Instance 0 - legacy PHY interface and
> Instace 1 & 2 - non-legacy standard PHY interfaces.
> 
> PHY driver is using instance numbers to identify the
> interface type.
> 
> With this patch Modified PHY driver to make use of
> DT property for handling this.
> 
> ULPI PHY is used on USB PHY instance 1 & UTMI is
> used on other two instances. Hence modified PHY type
> detection also from instance number to the parameter
> passed from host driver.

Mostly seems fine to me; just a couple more things I noticed inline
below. For the record, I'd like to take this through the Tegra tree with
all the other Tegra-related USB patches in order to manage any
dependencies, with the USB maintainers' Acks. Thanks.

> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c

> +struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev,
> +	bool is_legacy_mode, void __iomem *regs, void *config,
> +	enum tegra_usb_phy_mode phy_mode)

> +	u8 index = is_legacy_mode ? 0 : 2;

I know this looks slightly icky, but I discussed earlier with Venu that
this will be replaced by reading all the parameters out of device tree,
as soon as this code becomes a true driver. I think the patch for that
is up next, or at most after a few more cleanup patches.

> +	phy->is_ulpi_phy = config ? true : false;
>  
>  	if (!phy->config) {
> -		if (phy_is_ulpi(phy)) {
> +		if (phy->is_ulpi_phy) {
>  			pr_err("%s: ulpi phy configuration missing", __func__);
>  			err = -EINVAL;
>  			goto err0;

That check will never fire now, since phy->is_ulpi_phy is calculated
based on whether phy->config is set. I think it's fine for now to rely
on the EHCI driver correctly passing config or NULL, and hence you could
simply delete some of this error-checking code. I imagine that when the
PHY driver is reworked to be an actual device rather than a utility
module, phy->is_ulpi_phy will be determined by the compatible value of
the PHY node in device tree.
