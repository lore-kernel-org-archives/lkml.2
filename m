Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2DVU5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:57:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13430 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2DVU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:57:12 -0400
Date: Sun, 22 Apr 2012 22:57:09 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Luciano Coelho <coelho@ti.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wl12xx: fix size of two memset's in
 wl1271_cmd_build_arp_rsp()
In-Reply-To: <alpine.LNX.2.00.1204222252000.27455@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204222255460.27455@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204222252000.27455@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2012, Jesper Juhl wrote:

> We currently do this:
> 
> int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
> ...
> 	struct wl12xx_arp_rsp_template *tmpl;
> 	struct ieee80211_hdr_3addr *hdr;
> ...
> 	tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
> 	memset(tmpl, 0, sizeof(tmpl));
> ...
> 	hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
> 	memset(hdr, 0, sizeof(*hdr));
> ...
> 
> I believe we want to set the entire structures to 0 with those
> memset() calls, not just zero the initial part of them (size of the
> pointer bytes).
> 

Sorry, I accidentally copied that code from the fixed version. The above 
should read:


We currently do this:

int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
...
      struct wl12xx_arp_rsp_template *tmpl;
      struct ieee80211_hdr_3addr *hdr;
...
      tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
      memset(tmpl, 0, sizeof(tmpl));
...
      hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
      memset(hdr, 0, sizeof(hdr));
...

I believe we want to set the entire structures to 0 with those
memset() calls, not just zero the initial part of them (size of the
pointer bytes).





> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/net/wireless/wl12xx/cmd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 3414fc1..8e65529 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -1249,7 +1249,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>  	skb_reserve(skb, sizeof(*hdr) + WL1271_EXTRA_SPACE_MAX);
>  
>  	tmpl = (struct wl12xx_arp_rsp_template *)skb_put(skb, sizeof(*tmpl));
> -	memset(tmpl, 0, sizeof(tmpl));
> +	memset(tmpl, 0, sizeof(*tmpl));
>  
>  	/* llc layer */
>  	memcpy(tmpl->llc_hdr, rfc1042_header, sizeof(rfc1042_header));
> @@ -1298,7 +1298,7 @@ int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>  
>  	/* mac80211 header */
>  	hdr = (struct ieee80211_hdr_3addr *)skb_push(skb, sizeof(*hdr));
> -	memset(hdr, 0, sizeof(hdr));
> +	memset(hdr, 0, sizeof(*hdr));
>  	fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS;
>  	if (wlvif->sta.qos)
>  		fc |= IEEE80211_STYPE_QOS_DATA;
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

