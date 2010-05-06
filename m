Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab0EFMTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 08:19:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35465 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0EFMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 08:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=NZR/BuuWS1NVsE4TUXepHkoug4x2jt3khlvSkmxj7ZpToEW8WgagIts828MOv8/Svf
         IzN8/qoq7epRzrl15e2Ukxr+ylTNApu6A2O4S+mGrL96MmWdGfKEigRaN9Mf5FhcaDzQ
         ahxAytwT222Va+3c09OggpeGEOKZUe0tka9bY=
Message-ID: <4BE2B3BE.3090901@gmail.com>
Date: Thu, 06 May 2010 20:19:10 +0800
From: Ang Way Chuang <wcang79@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-media-owner@vger.kernel.org, linux-kernel@vger.kernel.org
CC: mchehab@redhat.com
Subject: [PATCH] dvb-core: Fix ULE decapsulation bug when less than 4 bytes
 of ULE SNDU is packed into the remaining bytes of a MPEG2-TS frame
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation 
code has a bug that incorrectly treats ULE SNDU packed into the 
remaining 2 or 3 bytes of a MPEG2-TS frame as having invalid pointer 
field on the subsequent MPEG2-TS frame.

This patch was generated and tested against v2.6.34-rc6. I suspect 
that this bug was introduced in kernel version 2.6.15, but had not 
verified it.

Care has been taken not to introduce more bug by fixing this bug, but
please scrutinize the code because I always produces buggy code.

Signed-off-by: Ang Way Chuang <wcang@nav6.org>
---
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 441c064..35a4afb 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -458,8 +458,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
						       "field: %u.\n", priv->ts_count, *from_where);

						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-						if (priv->ule_skb) {
-							dev_kfree_skb( priv->ule_skb );
+						if (priv->ule_skb || priv->ule_sndu_remain) {
+							if (priv->ule_skb)
+								dev_kfree_skb( priv->ule_skb );
							dev->stats.rx_errors++;
							dev->stats.rx_frame_errors++;
						}
@@ -534,6 +535,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
				from_where += 2;
			}

+			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
			/*
			 * State of current TS:
			 *   ts_remain (remaining bytes in the current TS cell)
@@ -543,6 +545,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
			 */
			switch (ts_remain) {
				case 1:
+					priv->ule_sndu_remain--;
					priv->ule_sndu_type = from_where[0] << 8;
					priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
					ts_remain -= 1; from_where += 1;
@@ -556,6 +559,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
				default: /* complete ULE header is present in current TS. */
					/* Extract ULE type field. */
					if (priv->ule_sndu_type_1) {
+						priv->ule_sndu_type_1 = 0;
						priv->ule_sndu_type |= from_where[0];
						from_where += 1; /* points to payload start. */
						ts_remain -= 1;



