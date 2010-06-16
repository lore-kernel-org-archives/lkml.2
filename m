Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0FPEwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:52:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49096
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab0FPEwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:52:01 -0400
Date: Tue, 15 Jun 2010 21:52:12 -0700 (PDT)
Message-Id: <20100615.215212.214211994.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: linux-next: build warnings after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100616133854.1bbbbb37.sfr@canb.auug.org.au>
References: <20100616133854.1bbbbb37.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 Jun 2010 13:38:54 +1000

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> produced these warnings:
> 
> In file included from drivers/usb/gadget/ether.c:123:
> drivers/usb/gadget/rndis.c: In function 'gen_ndis_query_resp':
> drivers/usb/gadget/rndis.c:197: warning: assignment from incompatible pointer type
> In file included from drivers/usb/gadget/multi.c:67:
> drivers/usb/gadget/rndis.c: In function 'gen_ndis_query_resp':
> drivers/usb/gadget/rndis.c:197: warning: assignment from incompatible pointer type
> In file included from drivers/usb/gadget/g_ffs.c:30:
> drivers/usb/gadget/rndis.c: In function 'gen_ndis_query_resp':
> drivers/usb/gadget/rndis.c:197: warning: assignment from incompatible pointer type
> 
> Introduced by commit be1f3c2c027cc5ad735df6a45a542ed1db7ec48b ("net:
> Enable 64-bit net device statistics on 32-bit architectures").  This is a
> call to dev_get_stats() and the return value is being assigned to a
> "struct net_device_stats *".

I've commited the patch below to deal with this, thanks for the report.

There's some pre-existing warnings someone will need to deal with at
some point:

drivers/usb/gadget/rndis.c: whole file: warning: coding style is bolixed

:-)

>From fdb93f8ac39aa5902f3d264edd50dffcabfdd13b Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Tue, 15 Jun 2010 21:50:14 -0700
Subject: [PATCH] gadget/rndis: dev_get_stats() now returns rtnl_link_stats64.

Based upon a report by Stephen Rothwell.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/usb/gadget/rndis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 5c0d06c..fb69b01 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -171,7 +171,7 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 	int			i, count;
 	rndis_query_cmplt_type	*resp;
 	struct net_device	*net;
-	const struct net_device_stats	*stats;
+	const struct rtnl_link_stats64 *stats;
 
 	if (!r) return -ENOMEM;
 	resp = (rndis_query_cmplt_type *) r->buf;
-- 
1.7.0.4

