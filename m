Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1EJL4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:56:03 -0400
Received: from exht1.emulex.com ([138.239.113.183]:8943 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754319Ab1EJL4B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:56:01 -0400
From: <Sathya.Perla@Emulex.Com>
To: <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Somnath.Kotur@Emulex.Com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Date: Tue, 10 May 2011 04:55:36 -0700
Subject: RE: linux-next: manual merge of the net tree with the net-current
 tree
Thread-Topic: linux-next: manual merge of the net tree with the net-current
 tree
Thread-Index: AcwOtIPNsSw2oERmT9GGgurD6aLL6gAVG2IQ
Message-ID: <8473e76e-64b3-46bb-b4c3-7997f87d53ea@exht1.ad.emulex.com>
References: <20110510114917.11f8738f.sfr@canb.auug.org.au>
In-Reply-To: <20110510114917.11f8738f.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, your conflict fix below looks fine. Thanks.

-Sathya

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Tuesday, May 10, 2011 7:19 AM
To: David Miller; netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Kotur, Somnath; Perla, Sathya
Subject: linux-next: manual merge of the net tree with the net-current tree

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/benet/be_main.c between commit 6709d9521df0 ("be2net: Fixed
bugs related to PVID") from the net-current tree and commit 15d721847f56
("be2net: parse vid and vtm fields of rx-compl only if vlanf bit is set")
from the net tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/benet/be_main.c
index 9187fb4,7b19931..0000000
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@@ -1103,9 -1102,14 +1104,14 @@@ static void be_parse_rx_compl_v1(struc
  		AMAP_GET_BITS(struct amap_eth_rx_compl_v1, numfrags, compl);
  	rxcp->pkt_type =
  		AMAP_GET_BITS(struct amap_eth_rx_compl_v1, cast_enc, compl);
- 	rxcp->vtm = AMAP_GET_BITS(struct amap_eth_rx_compl_v1, vtm, compl);
- 	rxcp->vlan_tag = AMAP_GET_BITS(struct amap_eth_rx_compl_v1, vlan_tag,
- 					compl);
+ 	rxcp->rss_hash =
+ 		AMAP_GET_BITS(struct amap_eth_rx_compl_v1, rsshash, rxcp);
+ 	if (rxcp->vlanf) {
+ 		rxcp->vtm = AMAP_GET_BITS(struct amap_eth_rx_compl_v1, vtm,
+ 				compl);
 -		rxcp->vid = AMAP_GET_BITS(struct amap_eth_rx_compl_v1, vlan_tag,
++		rxcp->vlan_tag = AMAP_GET_BITS(struct amap_eth_rx_compl_v1, vlan_tag,
+ 				compl);
+ 	}
  }
  
  static void be_parse_rx_compl_v0(struct be_adapter *adapter,
@@@ -1130,9 -1134,14 +1136,14 @@@
  		AMAP_GET_BITS(struct amap_eth_rx_compl_v0, numfrags, compl);
  	rxcp->pkt_type =
  		AMAP_GET_BITS(struct amap_eth_rx_compl_v0, cast_enc, compl);
- 	rxcp->vtm = AMAP_GET_BITS(struct amap_eth_rx_compl_v0, vtm, compl);
- 	rxcp->vlan_tag = AMAP_GET_BITS(struct amap_eth_rx_compl_v0, vlan_tag,
- 					compl);
+ 	rxcp->rss_hash =
+ 		AMAP_GET_BITS(struct amap_eth_rx_compl_v0, rsshash, rxcp);
+ 	if (rxcp->vlanf) {
+ 		rxcp->vtm = AMAP_GET_BITS(struct amap_eth_rx_compl_v0, vtm,
+ 				compl);
 -		rxcp->vid = AMAP_GET_BITS(struct amap_eth_rx_compl_v0, vlan_tag,
++		rxcp->vlan_tag = AMAP_GET_BITS(struct amap_eth_rx_compl_v0, vlan_tag,
+ 				compl);
+ 	}
  }
  
  static struct be_rx_compl_info *be_rx_compl_get(struct be_rx_obj *rxo)
@@@ -1154,17 -1163,19 +1165,20 @@@
  	else
  		be_parse_rx_compl_v0(adapter, compl, rxcp);
  
- 	/* vlanf could be wrongly set in some cards. ignore if vtm is not set */
- 	if ((adapter->function_mode & 0x400) && !rxcp->vtm)
- 		rxcp->vlanf = 0;
+ 	if (rxcp->vlanf) {
+ 		/* vlanf could be wrongly set in some cards.
+ 		 * ignore if vtm is not set */
+ 		if ((adapter->function_mode & 0x400) && !rxcp->vtm)
+ 			rxcp->vlanf = 0;
  
- 	if (!lancer_chip(adapter))
- 		rxcp->vlan_tag = swab16(rxcp->vlan_tag);
+ 		if (!lancer_chip(adapter))
 -			rxcp->vid = swab16(rxcp->vid);
++			rxcp->vlan_tag = swab16(rxcp->vlan_tag);
  
- 	if (((adapter->pvid & VLAN_VID_MASK) ==
- 		(rxcp->vlan_tag & VLAN_VID_MASK)) &&
- 		!adapter->vlan_tag[rxcp->vlan_tag])
- 		rxcp->vlanf = 0;
 -		if ((adapter->pvid == rxcp->vid) &&
 -			!adapter->vlan_tag[rxcp->vid])
++		if (((adapter->pvid & VLAN_VID_MASK) ==
++			(rxcp->vlan_tag & VLAN_VID_MASK)) &&
++			!adapter->vlan_tag[rxcp->vlan_tag])
+ 			rxcp->vlanf = 0;
+ 	}
  
  	/* As the compl has been parsed, reset it; we wont touch it again */
  	compl->dw[offsetof(struct amap_eth_rx_compl_v1, valid) / 32] = 0;
