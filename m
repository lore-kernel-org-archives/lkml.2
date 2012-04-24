Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab2DXRnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:43:24 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:37133 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755863Ab2DXRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:43:22 -0400
Message-ID: <1335289392.17274.44.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH net-next 3/3] Add capability to retrieve plug-in module
 EEPROM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stuart Hodgson <smhodgson@solarflare.com>
CC: <netdev@vger.kernel.org>, <bruce.w.allan@intel.com>, <decot@google.com>,
        <alexander.h.duyck@intel.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 24 Apr 2012 18:43:12 +0100
In-Reply-To: <4F9031C7.9070206@solarflare.com>
References: <4F9031C7.9070206@solarflare.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18862.005
X-TM-AS-Result: No--17.637000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 16:39 +0100, Stuart Hodgson wrote:
> Currently allows for SFP+ eeprom to be returned using the ethtool API.
> This can be extended in future to handle different eeprom formats
> and sizes
[...]
> --- a/drivers/net/ethernet/sfc/mcdi_phy.c
> +++ b/drivers/net/ethernet/sfc/mcdi_phy.c
> @@ -304,6 +304,26 @@ static u32 mcdi_to_ethtool_media(u32 media)
>  	}
>  }
> 
> +static u32 mcdi_to_module_eeprom_len(u32 media)
> +{
> +	switch (media) {
> +	case MC_CMD_MEDIA_SFP_PLUS:
> +		return ETH_MODULE_SFF_8079_LEN;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static u32 mcdi_to_module_eeprom_type(u32 media)
> +{
> +	switch (media) {
> +	case MC_CMD_MEDIA_SFP_PLUS:
> +		return ETH_MODULE_SFF_8079;
> +	default:
> +		return 0;
> +	}
> +}

These functions ended up unused, so don't add them.  You should have got
a compiler warning about this...

>  static int efx_mcdi_phy_probe(struct efx_nic *efx)
>  {
>  	struct efx_mcdi_phy_data *phy_data;
> @@ -739,6 +759,95 @@ static const char *efx_mcdi_phy_test_name(struct efx_nic *efx,
>  	return NULL;
>  }
> 
> +#define SFP_PAGE_SIZE	128
> +#define SFP_NUM_PAGES	2
> +static int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx,
> +					  struct ethtool_eeprom *ee, u8 *data)
> +{
> +	u8 outbuf[MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX];
> +	u8 inbuf[MC_CMD_GET_PHY_MEDIA_INFO_IN_LEN];
> +	size_t outlen;
> +	int rc;
> +	unsigned int payload_len;
> +	unsigned int copied = 0;
> +	unsigned int space_remaining = ee->len;
> +	unsigned int page;
> +	unsigned int page_off;
> +	unsigned int to_copy;
> +	u8 *user_data = data;
> +
> +	if (ee->offset > (SFP_PAGE_SIZE * SFP_NUM_PAGES))
> +		return -EINVAL;

Please also add this sanity-check:

	BUILD_BUG_ON(SFP_PAGE_SIZE * SFP_NUM_PAGES != ETH_MODULE_SFF_8079_LEN);

> +	page_off = (ee->offset % SFP_PAGE_SIZE);
> +	page = (ee->offset > SFP_PAGE_SIZE) ? 1 : 0;

Off-by-one error; the comparison should be >=.  Why not use the
straightforward calculation:

	page = ee->offset / SFP_PAGE_SIZE;

[...]
> +static int efx_mcdi_phy_get_module_info(struct efx_nic *efx,
> +					struct ethtool_modinfo *modinfo)
> +{
> +	/* This will return a length of the eeprom
> +	 * type of the module that was detected during the probe,
> +	 * if not modules inserted then phy_data will be NULL */
> +	struct efx_mcdi_phy_data *phy_cfg;
> +
> +	phy_cfg = efx->phy_data;
> +	modinfo->eeprom_len = 0;
> +	modinfo->type = 0;
> +
> +	switch (phy_cfg->media) {
> +	case MC_CMD_MEDIA_SFP_PLUS:
> +		modinfo->type = ETH_MODULE_SFF_8079;
> +		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
> +		break;
> +	default:

The default case should return -EOPNOTSUPP, just as if we didn't
implement this operation at all.  And there's no need to set
modinfo->{type,eeprom_len} to 0 in that case.

Ben.

> +		break;
> +	}
> +
> +	return 0;
> +}
[...]

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

