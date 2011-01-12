Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab1ALBbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:31:04 -0500
Received: from nbd.name ([46.4.11.11]:58244 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab1ALBbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:31:03 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2011 20:31:03 EST
Message-ID: <4D2D01B2.1050201@openwrt.org>
Date: Tue, 11 Jan 2011 18:19:46 -0700
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bernhard Walle <walle@corscience.de>
CC: lrodriguez@atheros.com, jmalinen@atheros.com, vasanth@atheros.com,
        senthilkumar@atheros.com, linville@tuxdriver.com,
        netdev@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] [RFC] ath9k: Fix reporting of RX STBC streams
 to userspace
References: <1294765194-30542-1-git-send-email-walle@corscience.de>
In-Reply-To: <1294765194-30542-1-git-send-email-walle@corscience.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-11 9:59 AM, Bernhard Walle wrote:
> While the driver reports
>
>          ath: TX streams 2, RX streams: 2
>
> in the kernel log (with ATH_DBG_CONFIG set in the debug module
> parameter), "iw list" only reported
>
> [...]
>          Capabilities: 0x12ce
>                  HT20/HT40
>                  SM Power Save disabled
>                  RX HT40 SGI
>                  TX STBC
>                  RX STBC 1-streams
> [...]
>
> The driver seems to set the value as flag while the iw tool interprets
> it as number. This patch fixes that.
>
> Signed-off-by: Bernhard Walle<walle@corscience.de>
> ---
>   drivers/net/wireless/ath/ath9k/init.c |   12 ++++++------
>   1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 639dc93..935b6c3 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -215,17 +215,17 @@ static void setup_ht_cap(struct ath_softc *sc,
>   	else
>   		max_streams = 2;
>
> -	if (AR_SREV_9280_20_OR_LATER(ah)) {
> -		if (max_streams>= 2)
> -			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
> -		ht_info->cap |= (1<<  IEEE80211_HT_CAP_RX_STBC_SHIFT);
> -	}
> -
>   	/* set up supported mcs set */
>   	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
>   	tx_streams = ath9k_cmn_count_streams(common->tx_chainmask, max_streams);
>   	rx_streams = ath9k_cmn_count_streams(common->rx_chainmask, max_streams);
>
> +	if (AR_SREV_9280_20_OR_LATER(ah)) {
> +		if (max_streams>= 2)
> +			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
> +		ht_info->cap |= (rx_streams<<  IEEE80211_HT_CAP_RX_STBC_SHIFT);
> +	}
> +
Are you sure the card can actually receive multiple streams via STBC? As 
far as I know, only one stream can be received properly via STBC, more 
streams have to be sent without it.

- Felix
