Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0H0T3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:29:00 -0400
Received: from mail.atheros.com ([12.19.149.2]:22461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0H0T24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:28:56 -0400
Date: Fri, 27 Aug 2010 12:28:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>, Zhu Yi <yi.zhu@intel.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bitops: Provide generic sign_extend function (moving
 it out from wireless code)
Message-ID: <20100827192853.GD7317@tux>
References: <20100827101651.GC5348@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100827101651.GC5348@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 03:16:51AM -0700, Andreas Herrmann wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> Provide a common function to sign extend a value.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c    |    6 ------
>  drivers/net/wireless/ath/ath9k/hw.h     |    6 ------
>  drivers/net/wireless/iwlwifi/iwl-4965.c |   16 ----------------
>  include/linux/bitops.h                  |   11 +++++++++++
>  4 files changed, 11 insertions(+), 28 deletions(-)
> 
> Recently I needed to sign extend some register values for further
> computation. I also stumbled over two functions in wireless code
> which do the same (in different ways).
> 
> Thus I wonder whether a generic function should be provided for this.
> 
> Below patch (against tip/master) provides the iwl-4965-variant of that
> function in bitops.h I am not sure whether that's the right place to
> add this function.  What do you think? Or is it a dumb idea anyway?

Think its reasonable. Adding linux-wireless.

  Luis
> 
> 
> Thanks,
> Andreas
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 6284c38..9e6f551 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1101,12 +1101,6 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
>    PHY calibration
>  \*****************/
>  
> -static int sign_extend(int val, const int nbits)
> -{
> -	int order = BIT(nbits-1);
> -	return (val ^ order) - order;
> -}
> -
>  static s32 ath5k_hw_read_measured_noise_floor(struct ath5k_hw *ah)
>  {
>  	s32 val;
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 399f7c1..5dad02f 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -858,12 +858,6 @@ static inline struct ath_hw_ops *ath9k_hw_ops(struct ath_hw *ah)
>  	return &ah->ops;
>  }
>  
> -static inline int sign_extend(int val, const int nbits)
> -{
> -	int order = BIT(nbits-1);
> -	return (val ^ order) - order;
> -}
> -
>  /* Initialization, Detach, Reset */
>  const char *ath9k_hw_probe(u16 vendorid, u16 devid);
>  void ath9k_hw_deinit(struct ath_hw *ah);
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index d92b729..9a53dee 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -1551,22 +1551,6 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
>  }
>  
>  /**
> - * sign_extend - Sign extend a value using specified bit as sign-bit
> - *
> - * Example: sign_extend(9, 3) would return -7 as bit3 of 1001b is 1
> - * and bit0..2 is 001b which when sign extended to 1111111111111001b is -7.
> - *
> - * @param oper value to sign extend
> - * @param index 0 based bit index (0<=index<32) to sign bit
> - */
> -static s32 sign_extend(u32 oper, int index)
> -{
> -	u8 shift = 31 - index;
> -
> -	return (s32)(oper << shift) >> shift;
> -}
> -
> -/**
>   * iwl4965_hw_get_temperature - return the calibrated temperature (in Kelvin)
>   * @statistics: Provides the temperature reading from the uCode
>   *
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index fc68053..618f69e 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -109,6 +109,17 @@ static inline __u8 ror8(__u8 word, unsigned int shift)
>  	return (word >> shift) | (word << (8 - shift));
>  }
>  
> +/**
> + * sign_extend - Sign extend a value using specified bit as sign-bit
> + * @value: value to sign extend
> + * @index: 0 based bit index (0<=index<32) to sign bit
> + */
> +static inline __s32 sign_extend(__u32 value, int index)
> +{
> +	__u8 shift = 31 - index;
> +	return (__s32)(value << shift) >> shift;
> +}
> +
>  static inline unsigned fls_long(unsigned long l)
>  {
>  	if (sizeof(l) == 4)
> -- 
> 1.6.4.4
> 
