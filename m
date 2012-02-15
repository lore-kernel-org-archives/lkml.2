Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2BOTBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:01:44 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2BOTBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:01:42 -0500
Date: Wed, 15 Feb 2012 13:55:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtlwifi: rtl8192se firmware load can overflow target
 buffer
Message-ID: <20120215185525.GE4379@tuxdriver.com>
References: <1328833192-10681-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328833192-10681-1-git-send-email-Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this a fix that should go to 3.3?

On Thu, Feb 09, 2012 at 06:19:52PM -0600, Larry Finger wrote:
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> Define RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE which represents the
> maximimum possible firmware file size. Use it in the definition
> of the buffer which receives the firmware file data.
> 
> Set RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE closer to the actual size of
> the firmware file, e.g., 90000 (down from hard coded 164000). The current
> size of rtlwifi/rtl8192sefw.bin is 88856.
> 
> Set max_fw_size to RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE for the size limit
> check. Fix the error case where max_fw_size is not cleared if the size
> limit check fails.
> 
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/rtlwifi/rtl8192se/fw.h |    3 ++-
>  drivers/net/wireless/rtlwifi/rtl8192se/sw.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> index babe85d..b4afff6 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> @@ -30,6 +30,7 @@
>  #define __REALTEK_FIRMWARE92S_H__
>  
>  #define RTL8190_MAX_FIRMWARE_CODE_SIZE		64000
> +#define RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE	90000
>  #define RTL8190_CPU_START_OFFSET		0x80
>  /* Firmware Local buffer size. 64k */
>  #define	MAX_FIRMWARE_CODE_SIZE			0xFF00
> @@ -217,7 +218,7 @@ struct rt_firmware {
>  	u8 fw_emem[RTL8190_MAX_FIRMWARE_CODE_SIZE];
>  	u32 fw_imem_len;
>  	u32 fw_emem_len;
> -	u8 sz_fw_tmpbuffer[164000];
> +	u8 sz_fw_tmpbuffer[RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE];
>  	u32 sz_fw_tmpbufferlen;
>  	u16 cmdpacket_fragthresold;
>  };
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> index ca38dd9..345d752 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> @@ -108,6 +108,7 @@ static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
>  	if (firmware->size > rtlpriv->max_fw_size) {
>  		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>  			 "Firmware is too big!\n");
> +		rtlpriv->max_fw_size = 0;
>  		release_firmware(firmware);
>  		return;
>  	}
> @@ -232,7 +233,7 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
>  		return 1;
>  	}
>  
> -	rtlpriv->max_fw_size = sizeof(struct rt_firmware);
> +	rtlpriv->max_fw_size = RTL8190_MAX_RAW_FIRMWARE_CODE_SIZE;
>  
>  	pr_info("Driver for Realtek RTL8192SE/RTL8191SE\n"
>  		"Loading firmware %s\n", rtlpriv->cfg->fw_name);
> -- 
> 1.7.9
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
