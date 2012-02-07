Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2BGGzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:55:54 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2247 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab2BGGzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:55:52 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: [PATCH] bnx2x: Fix mem leak in bnx2x_tpa_stop() if
 build_skb() fails.
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Jesper Juhl" <jj@chaosbits.net>, "Eric Dumazet" <eric.dumazet@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David Miller" <davem@davemloft.net>,
        "Eliezer Tamir" <eliezert@broadcom.com>
In-Reply-To: <1328568833.2476.1.camel@edumazet-laptop>
References: <alpine.LNX.2.00.1202062224210.20532@swampdragon.chaosbits.net>
 <1328568833.2476.1.camel@edumazet-laptop>
Organization: Broadcom
Date: Tue, 7 Feb 2012 08:55:01 +0200
Message-ID: <1328597701.18349.0.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 632E13603GG26003766-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 23:53 +0100, Eric Dumazet wrote:
> Le lundi 06 février 2012 à 22:28 +0100, Jesper Juhl a écrit :
> > We allocate memory for 'new_data' with kmalloc(). If we get the memory
> > we then try to build_skb() and if that should fail (which it can) we
> > do not enter 'if (likely(skb)) {' and actually use 'new_data' but
> > instead fall through to the 'drop:' label and end up returning from
> > the function without ever assigning 'new'data' to anything or freeing
> > it. That leaks the memory allocated to 'new_data'.
> > 
> > This patch fixes the memory leak by doing a kfree(new_data) in the
> > case where build_skb() fails (or where allocation of 'new_data' itself
> > fails, but in taht case it's just a harmless kfree(NULL)).
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> >  No hardware to test, so compile tested only.
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> > index 03f3935..7aee469 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> > @@ -523,7 +523,6 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
> >  		skb = build_skb(data);
> >  
> >  	if (likely(skb)) {
> > -
> >  #ifdef BNX2X_STOP_ON_ERROR
> >  		if (pad + len > fp->rx_buf_size) {
> >  			BNX2X_ERR("skb_put is about to fail...  "
> > @@ -557,7 +556,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
> >  
> >  		return;
> >  	}
> > -
> > +	kfree(new_data);
> >  drop:
> >  	/* drop the packet and keep the buffer in the bin */
> >  	DP(NETIF_MSG_RX_STATUS,
> > -- 
> > 1.7.9
> > 
> > 
> 
> Good catch, my bad.
> 
> Thanks
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Indeed - nice catch. Thanks Jesper.

Acked-by: Eilon Greenstein <eilong@broadcom.com>





