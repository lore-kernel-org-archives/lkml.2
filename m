Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051Ab1D3AgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:36:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760962Ab1D3AgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=q0F6BDn9eF0QSzuScwXYF5h0VMgxUbNxCoT3ubAuLgQHVuquNBNrju3Y2CD1EwoseF
         zqD+syWXFPVtGwZ9uFUgJWpyPOicLZZbNeaivRPDiPszc37beLoXw6nqhJuQ6cOAEA06
         PU+WcpN3fPtGqyRX5LdsLf253YPKrb+J/HVXE=
Date: Sat, 30 Apr 2011 02:36:04 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, jeff.chua.linux@gmail.com,
        wlanfae@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110430003604.GA3719@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
 <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB9884F.10409@lwfinger.net>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Larry Finger:

> On 04/28/2011 10:08 AM, clemens fischer wrote:
> >>Larry Finger:
> >
> >>From: Jeff Chua<jeff.chua.linux@gmail.com>
> >>
> >>Driver r8712u is unable to handle ad-hoc mode. The issue is that when
> >>the driver first starts, there will not be an SSID for association.
> >>The fix is to always call the "select and join from scan" routine when
> >>in ad-hoc mode.
> >>
> >>Note: Ad-hoc mode worked intermittently before. If the driver had
> >>previously been associated, then things were OK.
> >>
> >>Signed-off-by: Jeff Chua<jeff.chua.linux@gmail.com>
> >>Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> >>Cc: Stable<stable@kernel.org>
> >>---
> >>
> >>Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
> >>===================================================================
> >>--- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_set.c
> >>+++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
> >>@@ -68,7 +68,10 @@ static u8 do_join(struct _adapter *padap
> >>  	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
> >>  	pmlmepriv->pscanned = plist;
> >>  	pmlmepriv->to_join = true;
> >>-	if (_queue_empty(queue) == true) {
> >>+
> >>+	/* adhoc mode will start with an empty queue, but skip checking */
> >>+	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)&&
> >>+	    _queue_empty(queue)) {
> >>  		if (pmlmepriv->fw_state&  _FW_UNDER_LINKING)
> >>  			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
> >>  		/* when set_ssid/set_bssid for do_join(), but scanning queue
> >
> >Thanks for CC'ing me.
> >
> >This patch doesn't solve my problem[1], unfortunately.  I am using
> >iwconfig(8) to setup things, and it is still impossible to set the ESSID
> >and the power saving mode.  In my case it was even possible to get into
> >Ad-hoc mode without the patch and without ever beeing associated.
> >
> >[1] https://bugzilla.kernel.org/show_bug.cgi?id=33352
> 
> Does this one help? It should be in addition to the previous patch.
> 
> Larry

> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> ===================================================================
> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
>  	struct wlan_network *pnetwork = NULL;
>  	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
>  
> -	if (padapter->bup == false)
> -		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
>  		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
> @@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
>  	struct list_head *phead;
>  	u32 len;
>  
> -	if (padapter->bup == false)
> -		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
>  		return -1;
>  	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

BTW, which version is this patch against?  I applied both of them to the
one tagged "v2.6.38.4", and they applied with a negative offset of about
-5 lines.

Should I rather use [1]?

[1] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git


regards, clemens
