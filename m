Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2BMVrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:47:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65036 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2BMVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:47:50 -0500
Message-ID: <4F398503.7020200@lwfinger.net>
Date: Mon, 13 Feb 2012 15:47:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrea Merello <andreamrl@tiscali.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean MacLennan <seanm@seanm.ca>, Mike McCormack <mikem@ring3k.org>
Subject: Re: [PATCH] Staging, rtl8192e, softmac: remove redundant memset and
 fix mem leak
References: <alpine.LNX.2.00.1202130012140.13814@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1202130012140.13814@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 05:15 PM, Jesper Juhl wrote:
> In drivers/staging/rtl8192e/rtllib_softmac.c::rtllib_rx_assoc_resp()
> we allocate memory for 'network' with kzalloc() and then proceed to
> zero the already zeroed mem we got from kzalloc() with
> memset(). That's redundant, so remove the memset()
>
> We also fail to kfree() the memory we allocated for 'network' if we do not enter
>
>    if (ieee->current_network.qos_data.supported == 1) {
>
> and the variable then goes out of scope.
>
> To fix that I simply moved the kfree() that was inside that 'if'
> statement to instead be just after it. It then covers both the case
> where we take the branch and when we don't.
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   drivers/staging/rtl8192e/rtllib_softmac.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
>    Compile tested only.

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
> index 1637f11..c5a15db 100644
> --- a/drivers/staging/rtl8192e/rtllib_softmac.c
> +++ b/drivers/staging/rtl8192e/rtllib_softmac.c
> @@ -2234,7 +2234,6 @@ inline int rtllib_rx_assoc_resp(struct rtllib_device *ieee, struct sk_buff *skb,
>
>   			if (!network)
>   				return 1;
> -			memset(network, 0, sizeof(*network));
>   			ieee->state = RTLLIB_LINKED;
>   			ieee->assoc_id = aid;
>   			ieee->softmac_stats.rx_ass_ok++;
> @@ -2259,8 +2258,8 @@ inline int rtllib_rx_assoc_resp(struct rtllib_device *ieee, struct sk_buff *skb,
>   					ieee->handle_assoc_response(ieee->dev,
>   						 (struct rtllib_assoc_response_frame *)header,
>   						 network);
> -				kfree(network);
>   			}
> +			kfree(network);
>
>   			kfree(ieee->assocresp_ies);
>   			ieee->assocresp_ies = NULL;

