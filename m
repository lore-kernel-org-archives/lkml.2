Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2BNCQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:16:53 -0500
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:59546
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751515Ab2BNCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:16:53 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Feb 2012 21:16:52 EST
Date: Mon, 13 Feb 2012 21:10:09 -0500
From: Sean MacLennan <seanm@seanm.ca>
To: Jesper Juhl <jj@chaosbits.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrea Merello <andreamrl@tiscali.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Mike McCormack <mikem@ring3k.org>
Subject: Re: [PATCH] Staging, rtl8192e, softmac: remove redundant memset and
 fix mem leak
Message-ID: <20120213211009.7c0335cc@opus.seanm.ca>
In-Reply-To: <alpine.LNX.2.00.1202130012140.13814@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202130012140.13814@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 00:15:02 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> We also fail to kfree() the memory we allocated for 'network' if we
> do not enter
> 
>   if (ieee->current_network.qos_data.supported == 1) {
> 
> and the variable then goes out of scope.
> 
> To fix that I simply moved the kfree() that was inside that 'if'
> statement to instead be just after it. It then covers both the case
> where we take the branch and when we don't.

Nice catch! We know that the driver leaks memory if left running for a
long time, this will help!

I would recommend a small change: instead of moving the kfree() out of
the loop, why not move the kzalloc into it? The qos_data.supported == 0
is the normal case (at least for me), so why not save an alloc?

Something like this:

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 1637f11..59b991f 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -2228,13 +2228,6 @@ inline int rtllib_rx_assoc_resp(struct rtllib_device *ieee, struct sk_buff *skb,
 	     (ieee->iw_mode == IW_MODE_INFRA)) {
 		errcode = assoc_parse(ieee, skb, &aid);
 		if (0 == errcode) {
-			struct rtllib_network *network =
-				 kzalloc(sizeof(struct rtllib_network),
-				 GFP_ATOMIC);
-
-			if (!network)
-				return 1;
-			memset(network, 0, sizeof(*network));
 			ieee->state = RTLLIB_LINKED;
 			ieee->assoc_id = aid;
 			ieee->softmac_stats.rx_ass_ok++;
@@ -2242,6 +2235,13 @@ inline int rtllib_rx_assoc_resp(struct rtllib_device *ieee, struct sk_buff *skb,
 			/* Let the register setting default with Legacy station */
 			assoc_resp = (struct rtllib_assoc_response_frame *)skb->data;
 			if (ieee->current_network.qos_data.supported == 1) {
+				struct rtllib_network *network =
+					kzalloc(sizeof(struct rtllib_network),
+						GFP_ATOMIC);
+
+				if (!network)
+					return 1;
+
 				if (rtllib_parse_info_param(ieee, assoc_resp->info_element,
 							rx_stats->len - sizeof(*assoc_resp),
 							network, rx_stats)) {

Cheers,
   Sean
