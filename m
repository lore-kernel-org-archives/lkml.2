Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1D1Pbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:31:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61518 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1D1Pbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=g6EweUO4Tb52jswqfedGlUVIrVqPE9hECTu5xC45TJHzaHXlseYvdj9nOis5nXXKFZ
         DQdWUJdlG4fGTEGKPrRFdSIUcg13sETRyduMkMCFTg3t8GMiuQe5vyKOBnqYC6JCRpL2
         ebjDJVqscThC2yxs3egn3gEe5GcRXPpqPTNqA=
Message-ID: <4DB9884F.10409@lwfinger.net>
Date: Thu, 28 Apr 2011 10:31:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, jeff.chua.linux@gmail.com,
        wlanfae@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net> <20110428150819.GA3713@spotteswoode.de.eu.org>
In-Reply-To: <20110428150819.GA3713@spotteswoode.de.eu.org>
Content-Type: multipart/mixed;
 boundary="------------070809010405040102080608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070809010405040102080608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/28/2011 10:08 AM, clemens fischer wrote:
>> Larry Finger:
>
>> From: Jeff Chua<jeff.chua.linux@gmail.com>
>>
>> Driver r8712u is unable to handle ad-hoc mode. The issue is that when
>> the driver first starts, there will not be an SSID for association.
>> The fix is to always call the "select and join from scan" routine when
>> in ad-hoc mode.
>>
>> Note: Ad-hoc mode worked intermittently before. If the driver had
>> previously been associated, then things were OK.
>>
>> Signed-off-by: Jeff Chua<jeff.chua.linux@gmail.com>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> Cc: Stable<stable@kernel.org>
>> ---
>>
>> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_set.c
>> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
>> @@ -68,7 +68,10 @@ static u8 do_join(struct _adapter *padap
>>   	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
>>   	pmlmepriv->pscanned = plist;
>>   	pmlmepriv->to_join = true;
>> -	if (_queue_empty(queue) == true) {
>> +
>> +	/* adhoc mode will start with an empty queue, but skip checking */
>> +	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)&&
>> +	    _queue_empty(queue)) {
>>   		if (pmlmepriv->fw_state&  _FW_UNDER_LINKING)
>>   			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
>>   		/* when set_ssid/set_bssid for do_join(), but scanning queue
>
> Thanks for CC'ing me.
>
> This patch doesn't solve my problem[1], unfortunately.  I am using
> iwconfig(8) to setup things, and it is still impossible to set the ESSID
> and the power saving mode.  In my case it was even possible to get into
> Ad-hoc mode without the patch and without ever beeing associated.
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=33352

Does this one help? It should be in addition to the previous patch.

Larry

--------------070809010405040102080608
Content-Type: text/plain;
 name="r8712u_set_essid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="r8712u_set_essid"

Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
 	struct wlan_network *pnetwork = NULL;
 	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
 
-	if (padapter->bup == false)
-		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
@@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
 	struct list_head *phead;
 	u32 len;
 
-	if (padapter->bup == false)
-		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

--------------070809010405040102080608--
