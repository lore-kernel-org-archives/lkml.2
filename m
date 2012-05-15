Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966560Ab2EOTWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:22:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2383 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966529Ab2EOTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:22:17 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ocl9IesFS4YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Q-fNiiVtAAAA:8 a=1mFdLfmRpSGx8jM4uTQA:9 a=t6bQRiCvFBUxeS6X6ZkA:7 a=PUjeQqilurYA:10 a=lcTMV_K9oDIA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337109734.14207.348.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] compile fix for brcm80211 on v3.2.17
From: Steven Rostedt <rostedt@goodmis.org>
To: Clark Williams <williams@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        BrettRudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Roland Vossen <rvossen@broadcom.com>
Date: Tue, 15 May 2012 15:22:14 -0400
In-Reply-To: <20120515140413.04c19fad@redhat.com>
References: <20120515140413.04c19fad@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 14:04 -0500, Clark Williams wrote:
> Ben,
> 
> Found this while building v3.2.17-rt28:
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index f98becc..833cbef 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -7879,7 +7879,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
>         if (wlc->hw->suspended_fifos) {
>                 hdr = (struct ieee80211_hdr *)p->data;
>                 if (ieee80211_is_beacon(hdr->frame_control))
> -                       brcms_b_mute(wlc->hw, false);
> +                       brcms_b_mute(wlc->hw, false, 0);
>         }
>  
>         memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
> 
> Not sure if that's completely correct but I found another call site for
> brcms_b_mute() that also passed 0 flags. 

The bug was caused by this patch:

commit d609909f0d6c69937057237b3eff577311d08d07
Author: Arend van Spriel <arend@broadcom.com>
brcm80211: smac: resume transmit fifo upon receiving frames

(mainline: badc4f07622f0f7093a201638f45e85765f1b5e4)

Because it was added to mainline after this patch:

commit c6c44893c864429a7c6a4f7942dfb3ee182b4ad1
Author: Roland Vossen <rvossen@broadcom.com>
brcm80211: smac: fixed inconsistency in transmit mute

Which converted brcms_b_mute() from 3 arguments to 2.

-- Steve



