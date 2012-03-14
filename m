Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab2CNESS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:18:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48365 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2CNESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:18:16 -0400
Message-ID: <4F601C02.8070909@gmail.com>
Date: Wed, 14 Mar 2012 15:18:10 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Miller <amiller@amilx.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
References: <1331686689-6763-1-git-send-email-amiller@amilx.com> <1331688836.27389.13.camel@joe2Laptop>
In-Reply-To: <1331688836.27389.13.camel@joe2Laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/12 12:33, Joe Perches wrote:

> On Tue, 2012-03-13 at 20:58 -0400, Andrew Miller wrote:
>> Fix long line coding style issue
>> Signed-off-by: Andrew Miller <amiller@amilx.com>
> 
> Hi Andrew.
> 
> Please strive for clarity instead of just fixing
> random 80 char warnings.
> 
>> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> []
>> @@ -1607,17 +1609,20 @@ void rtl8180_rx(struct net_device *dev)
>>  		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
>>  		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
>>  		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
>> -		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) | (((*(priv->rxringtail)) & (0x04000000)) != 0)
>> -			| (((*(priv->rxringtail)) & (0x08000000)) != 0) | (((~(*(priv->rxringtail))) & (0x10000000)) != 0) | (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
>> +		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
>> +			   (((*(priv->rxringtail)) & (0x04000000)) != 0) |
>> +			   (((*(priv->rxringtail)) & (0x08000000)) != 0) |
>> +			   (((~(*(priv->rxringtail))) & (0x10000000)) != 0) |
>> +			   (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
> 
> Likely these | uses should be ||
> 
>>  		bCRC = ((*(priv->rxringtail)) & (0x00002000)) >> 13;
>>  		bICV = ((*(priv->rxringtail)) & (0x00001000)) >> 12;
>>  		hdr = (struct ieee80211_hdr_4addr *)priv->rxbuffer->buf;
>>  		    fc = le16_to_cpu(hdr->frame_ctl);
>>  		type = WLAN_FC_GET_TYPE(fc);
>>  
>> -			if ((IEEE80211_FTYPE_CTL != type) &&
>> -				(eqMacAddr(priv->ieee80211->current_network.bssid, (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
>> -				 && (!bHwError) && (!bCRC) && (!bICV)) {
>> +			if ((IEEE80211_FTYPE_CTL != type) && (eqMacAddr(priv->ieee80211->current_network.bssid,
>> +			    (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
>> +			    && (!bHwError) && (!bCRC) && (!bICV)) {
> 
> This is difficult to read and could be better written
> removing unnecessary parentheses and making the egMacAddr
> clearer as a function/macro call:
> 
> 			if (IEEE80211_FTYPE_CTL != type &&
> 			    eqMacAddr(priv->ieee80211->current_network.bssid,
> 				      fc & IEEE80211_FCTL_TODS ? hdr->addr1 :
> 				      fc & IEEE80211_FCTL_FROMDS ? hdr->addr2 :
> 				      hdr->addr3) &&
> 			    !bHwError &&
> 			    !bCRC &&
> 			    !bICV)


That's still pretty nasty. Eight lines for an if expression! It took me
a couple of glances to realise that there were only two arguments to
eqMacAddr. If you add some temporary variables then you can make the
code a lot more sane, without making it overly verbose:

	u8 *addr, *bssid = priv->ieee80211->current_network.bssid;

	if (fc & IEEE80211_FCTL_TODS)
		addr = hdr->addr1;
	else if (fc & IEEE80211_FCTL_FROMDS)
		addr = hdr->addr2;
	else
		addr = hdr->addr3;

	if (!bHwError && !bCRC && !bICV &&
	    type != IEEE80211_FTYPE_CTL && eqMacAddr(bssid, addr)) {
		...

Also note that the whole if block is indented one too many tab stops.
Would be best to fix that in a separate patch though. If you fix that
first, then you will have more horizontal space to re-organise the
expression inside the if :-).

~Ryan

