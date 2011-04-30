Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1D3FFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 01:05:07 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:38499 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1D3FFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 01:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eRs4AO2X7/DdDlDF0oPeL3RF/Q2X7cav6yfRGoYDtFTl/BNpZlbHl3SM7bN1uOoefC
         mTtIkqhDewtZAbErg5DE7162zDrz6bCXTmeekhk++NjieyjXyVN6u2ILS8CEM6g5XIF/
         z6eW4czIjNw4IiDE4exFR4UjLZsMA826ZjaAs=
Message-ID: <4DBB987B.1040003@lwfinger.net>
Date: Sat, 30 Apr 2011 00:04:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: clemens fischer <ino-news@spotteswoode.dnsalias.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, jeff.chua.linux@gmail.com,
        wlanfae@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net> <20110428150819.GA3713@spotteswoode.de.eu.org> <4DB9884F.10409@lwfinger.net> <20110430003604.GA3719@spotteswoode.de.eu.org>
In-Reply-To: <20110430003604.GA3719@spotteswoode.de.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 07:36 PM, clemens fischer wrote:
>> Larry Finger:
>
>> On 04/28/2011 10:08 AM, clemens fischer wrote:
>>>> Larry Finger:
>>>
>>>> From: Jeff Chua<jeff.chua.linux@gmail.com>
>>>>
>>>> Driver r8712u is unable to handle ad-hoc mode. The issue is that when
>>>> the driver first starts, there will not be an SSID for association.
>>>> The fix is to always call the "select and join from scan" routine when
>>>> in ad-hoc mode.
>>>>
>>>> Note: Ad-hoc mode worked intermittently before. If the driver had
>>>> previously been associated, then things were OK.
>>>>
>>>> Signed-off-by: Jeff Chua<jeff.chua.linux@gmail.com>
>>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>> Cc: Stable<stable@kernel.org>
>>>> ---
>>>>
>>>> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_set.c
>>>> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
>>>> @@ -68,7 +68,10 @@ static u8 do_join(struct _adapter *padap
>>>>   	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
>>>>   	pmlmepriv->pscanned = plist;
>>>>   	pmlmepriv->to_join = true;
>>>> -	if (_queue_empty(queue) == true) {
>>>> +
>>>> +	/* adhoc mode will start with an empty queue, but skip checking */
>>>> +	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)&&
>>>> +	    _queue_empty(queue)) {
>>>>   		if (pmlmepriv->fw_state&   _FW_UNDER_LINKING)
>>>>   			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
>>>>   		/* when set_ssid/set_bssid for do_join(), but scanning queue
>>>
>>> Thanks for CC'ing me.
>>>
>>> This patch doesn't solve my problem[1], unfortunately.  I am using
>>> iwconfig(8) to setup things, and it is still impossible to set the ESSID
>>> and the power saving mode.  In my case it was even possible to get into
>>> Ad-hoc mode without the patch and without ever beeing associated.
>>>
>>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=33352
>>
>> Does this one help? It should be in addition to the previous patch.
>>
>> Larry
>
>> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> @@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
>>   	struct wlan_network *pnetwork = NULL;
>>   	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
>>
>> -	if (padapter->bup == false)
>> -		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
>>   		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
>> @@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
>>   	struct list_head *phead;
>>   	u32 len;
>>
>> -	if (padapter->bup == false)
>> -		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
>>   		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))
>
> BTW, which version is this patch against?  I applied both of them to the
> one tagged "v2.6.38.4", and they applied with a negative offset of about
> -5 lines.
>
> Should I rather use [1]?
>
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

My patches are against the mainline tree that you quote above; however, as long 
as they apply, it won't matter. Offsets don;t really make much difference.

Larry
