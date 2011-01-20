Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1ATXzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:55:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62572 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1ATXzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RCK4KwReRNVAWtqcgEWnOj0e7+WgY6YcHhQzG7/0eqKIyApVScw+92sjJT/3K04kQE
         5kBq2lBaLgbZSMBdiNM6n8oYSlPBx/ImgpNKCbn+nE4LeMG9X2R9c3GBqy4YJKRCh/rA
         tBYn94EXcAZkPF/8b/jVsUQajSa5AQSxxTCWc=
Message-ID: <4D38CB7E.5000304@lwfinger.net>
Date: Thu, 20 Jan 2011 17:55:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] Fix NULL dereference in rtlwifi driver
References: <alpine.LNX.2.00.1101202309030.11854@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101202309030.11854@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 04:18 PM, Jesper Juhl wrote:
> In drivers/net/wireless/rtlwifi/pci.c::_rtl_pci_rx_interrupt() we call 
> dev_alloc_skb(), which may fail and return NULL, but we do not check the 
> returned value against NULL before dereferencing the returned pointer. 
> This may lead to a NULL pointer dereference which means we'll crash - not 
> good.
> 
> This patch tries to solve the issue by testing for NULL and bailing out if 
> we couldn't allocate a skb. However, I don't know this code well, so I'm 
> not sure that jumping to the 'done' label here is the correct action to 
> take. Someone more knowledgable about this code than me should definately 
> review it before it is applied anywhere.
> While I was in the area I also moved an assignment in 
> _rtl_pci_init_rx_ring() a bit - if the dev_alloc_skb() call in that 
> function fails there's no reason to waste clock cycles assigning to the 
> local variable 'entry', we may as well do that after the NULL check and 
> potential bail out.
> 
> Here's the proposed patch, but please don't take it as much more than a 
> bug report. If it happens to be correct, then by all means apply it, but 
> I'm not personally making any guarantees.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  pci.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
>   compile tested only, I don't have the hardware to test for real.
> 
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 0fa36aa..5e99f89 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -619,6 +619,13 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>  					struct sk_buff *uskb = NULL;
>  					u8 *pdata;
>  					uskb = dev_alloc_skb(skb->len + 128);
> +					if (!uskb) {
> +						RT_TRACE(rtlpriv,
> +							(COMP_INTR | COMP_RECV),
> +							DBG_DMESG,
> +							("can't alloc rx skb\n"));
> +						goto done;
> +					}
>  					memcpy(IEEE80211_SKB_RXCB(uskb),
>  							&rx_status,
>  							sizeof(rx_status));
> @@ -1066,9 +1073,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
>  			struct sk_buff *skb =
>  			    dev_alloc_skb(rtlpci->rxbuffersize);
>  			u32 bufferaddress;
> -			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
>  			if (!skb)
>  				return 0;
> +			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
>  
>  			/*skb->dev = dev; */
>  

This patch looks mostly good to me. The only change I would make is to replace
"DBG_DMESG" in the RT_TRACE statement with "DBG_EMERG". The standard setting of
the debug variable does not generate output for DBG_DMESG.

With that change, ACK and
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

