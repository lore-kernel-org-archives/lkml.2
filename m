Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842Ab1D0Sxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:53:44 -0400
Received: from mail.solarflare.com ([216.237.3.220]:24607 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab1D0Sxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:53:42 -0400
Subject: Re: [PATCHv2 2/4] ethtool: Call ethtool's get/set_settings
 callbacks with cleaned data
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1303929290-21037-3-git-send-email-decot@google.com>
References: <1303001651-4074-1-git-send-email-decot@google.com>
	 <1303929290-21037-3-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 27 Apr 2011 19:53:38 +0100
Message-ID: <1303930418.2875.106.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Apr 2011 18:53:41.0913 (UTC) FILETIME=[6D57F890:01CC050C]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18098.005
X-TM-AS-Result: No--12.483900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 11:34 -0700, David Decotigny wrote:
> This makes sure that when a driver calls the ethtool's
> get/set_settings() callback of another driver, the data passed to it
> is clean. This guarantees that speed_hi will be zeroed correctly if
> the called callback doesn't explicitely set it: we are sure we don't
> get a corrupted speed from the underlying driver. We also take care of
> setting the cmd field appropriately (ETHTOOL_GSET/SSET).
> 
> This applies to dev_ethtool_get_settings(), which now makes sure it
> sets up that ethtool command parameter correctly before passing it to
> drivers. This also means that whoever calls dev_ethtool_get_settings()
> does not have to clean the ethtool command parameter. This function
> also becomes an exported symbol instead of an inline.
> 
> All drivers visible to make allyesconfig under x86_64 have been
> updated.
> 
> Signed-off-by: David Decotigny <decot@google.com>
[...]
> diff --git a/drivers/net/mdio.c b/drivers/net/mdio.c
> index e85bf04..2e717a2 100644
> --- a/drivers/net/mdio.c
> +++ b/drivers/net/mdio.c
> @@ -176,6 +176,9 @@ static u32 mdio45_get_an(const struct mdio_if_info *mdio, u16 addr)
>   * @npage_adv: Modes currently advertised on next pages
>   * @npage_lpa: Modes advertised by link partner on next pages
>   *
> + * The @ecmd parameter is expected to have been cleared before calling
> + * mii_ethtool_gset().

Copy-pasta: should say mdio45_get_an() not mii_ethtool_gset().

[...]
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3bbb4c2..36e57fb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4496,6 +4496,30 @@ void dev_set_rx_mode(struct net_device *dev)
>  }
>  
>  /**
> + *	dev_ethtool_get_settings - call device's ethtool::get_settings()
> + *	@dev: device
> + *	@cmd: memory area for ethtool_cmd::get_settings() result
> + *
> + *      The cmd arg is initialized properly (cleared and
> + *      ethtoo_cmd::cmd field set to ETHTOOL_GSET).

Typo: 'ethtoo_cmd' should be 'ethtool_cmd'.

> + *	Return device's ethtool_cmd::get_settings() result value or
> + *	-EOPNOTSUPP when device doesn't expose
> + *	ethtool_cmd::get_settings() operation.
[...]

The operation is ethtool_ops::get_settings, not ethtool::get_settings or
ethtool_cmd::get_settings.

Other than that, this looks fine.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

