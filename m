Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2GCNSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:18:09 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:34113 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab2GCNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:18:07 -0400
Message-ID: <4FF2F109.2010300@lwfinger.net>
Date: Tue, 03 Jul 2012 08:18:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe@smile, Perches@smile, joe@perches.com
Subject: Re: [RFC][PATCHv2 3/3] wireless: at76c50x: eliminate hex2str()
References: <1341264199.10162.2.camel@joe2Laptop> <1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com> <1341310000-4082-3-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1341310000-4082-3-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 05:06 AM, Andy Shevchenko wrote:
> The hex2str() is substituted by '%*pMF' specificator.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/net/wireless/at76c50x-usb.c |   54 ++++++++---------------------------
>   1 file changed, 12 insertions(+), 42 deletions(-)

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

>
> diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
> index efc162e..f82f76b 100644
> --- a/drivers/net/wireless/at76c50x-usb.c
> +++ b/drivers/net/wireless/at76c50x-usb.c
> @@ -498,36 +498,6 @@ exit:
>   	return ret;
>   }
>
> -#define HEX2STR_BUFFERS 4
> -#define HEX2STR_MAX_LEN 64
> -
> -/* Convert binary data into hex string */
> -static char *hex2str(void *buf, size_t len)
> -{
> -	static atomic_t a = ATOMIC_INIT(0);
> -	static char bufs[HEX2STR_BUFFERS][3 * HEX2STR_MAX_LEN + 1];
> -	char *ret = bufs[atomic_inc_return(&a) & (HEX2STR_BUFFERS - 1)];
> -	char *obuf = ret;
> -	u8 *ibuf = buf;
> -
> -	if (len > HEX2STR_MAX_LEN)
> -		len = HEX2STR_MAX_LEN;
> -
> -	if (len == 0)
> -		goto exit;
> -
> -	while (len--) {
> -		obuf = hex_byte_pack(obuf, *ibuf++);
> -		*obuf++ = '-';
> -	}
> -	obuf--;
> -
> -exit:
> -	*obuf = '\0';
> -
> -	return ret;
> -}
> -
>   /* LED trigger */
>   static int tx_activity;
>   static void at76_ledtrig_tx_timerfunc(unsigned long data);
> @@ -1004,9 +974,9 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
>   	    WEP_SMALL_KEY_LEN : WEP_LARGE_KEY_LEN;
>
>   	for (i = 0; i < WEP_KEYS; i++)
> -		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %s",
> +		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %*pMF",
>   			 wiphy_name(priv->hw->wiphy), i,
> -			 hex2str(m->wep_default_keyvalue[i], key_len));
> +			 key_len, m->wep_default_keyvalue[i]);
>   exit:
>   	kfree(m);
>   }
> @@ -1031,7 +1001,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
>   	at76_dbg(DBG_MIB, "%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration "
>   		 "%d medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
>   		 "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
> -		 "current_bssid %pM current_essid %s current_bss_type %d "
> +		 "current_bssid %pM current_essid %*pMF current_bss_type %d "
>   		 "pm_mode %d ibss_change %d res %d "
>   		 "multi_domain_capability_implemented %d "
>   		 "international_roaming %d country_string %.3s",
> @@ -1041,7 +1011,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
>   		 le16_to_cpu(m->station_id), le16_to_cpu(m->ATIM_window),
>   		 m->CFP_mode, m->privacy_option_implemented, m->DTIM_period,
>   		 m->CFP_period, m->current_bssid,
> -		 hex2str(m->current_essid, IW_ESSID_MAX_SIZE),
> +		 IW_ESSID_MAX_SIZE, m->current_essid,
>   		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
>   		 m->res, m->multi_domain_capability_implemented,
>   		 m->multi_domain_capability_enabled, m->country_string);
> @@ -1069,7 +1039,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
>   		 "cwmin %d cwmax %d short_retry_time %d long_retry_time %d "
>   		 "scan_type %d scan_channel %d probe_delay %u "
>   		 "min_channel_time %d max_channel_time %d listen_int %d "
> -		 "desired_ssid %s desired_bssid %pM desired_bsstype %d",
> +		 "desired_ssid %*pMF desired_bssid %pM desired_bsstype %d",
>   		 wiphy_name(priv->hw->wiphy),
>   		 le32_to_cpu(m->max_tx_msdu_lifetime),
>   		 le32_to_cpu(m->max_rx_lifetime),
> @@ -1080,7 +1050,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
>   		 le16_to_cpu(m->min_channel_time),
>   		 le16_to_cpu(m->max_channel_time),
>   		 le16_to_cpu(m->listen_interval),
> -		 hex2str(m->desired_ssid, IW_ESSID_MAX_SIZE),
> +		 IW_ESSID_MAX_SIZE, m->desired_ssid,
>   		 m->desired_bssid, m->desired_bsstype);
>   exit:
>   	kfree(m);
> @@ -1160,13 +1130,13 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
>   		goto exit;
>   	}
>
> -	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %s",
> +	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %*pMF",
>   		 wiphy_name(priv->hw->wiphy),
> -		 hex2str(m->channel_list, sizeof(m->channel_list)));
> +		 sizeof(m->channel_list), m->channel_list);
>
> -	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %s",
> +	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %*pMF",
>   		 wiphy_name(priv->hw->wiphy),
> -		 hex2str(m->tx_powerlevel, sizeof(m->tx_powerlevel)));
> +		 sizeof(m->tx_powerlevel), m->tx_powerlevel);
>   exit:
>   	kfree(m);
>   }
> @@ -1369,9 +1339,9 @@ static int at76_startup_device(struct at76_priv *priv)
>   	int ret;
>
>   	at76_dbg(DBG_PARAMS,
> -		 "%s param: ssid %.*s (%s) mode %s ch %d wep %s key %d "
> +		 "%s param: ssid %.*s (%*pMF) mode %s ch %d wep %s key %d "
>   		 "keylen %d", wiphy_name(priv->hw->wiphy), priv->essid_size,
> -		 priv->essid, hex2str(priv->essid, IW_ESSID_MAX_SIZE),
> +		 priv->essid, IW_ESSID_MAX_SIZE, priv->essid,
>   		 priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
>   		 priv->channel, priv->wep_enabled ? "enabled" : "disabled",
>   		 priv->wep_key_id, priv->wep_keys_len[priv->wep_key_id]);
>


