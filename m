Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0GASXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:17 -0400
Received: from kroah.org ([198.145.64.141]:35514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab0GASXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:13 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:11 2010
Message-Id: <20100701173210.928494181@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Bruce Rogers <brogers@novell.com>
Subject: [patch 049/149] virtio_net: Make delayed refill more reliable
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 39d321577405e8e269fd238b278aaf2425fa788a upstream.

I have seen RX stalls on a machine that experienced a suspected
OOM.  After the stall, the RX buffer is empty on the guest side
and there are exactly 16 entries available on the host side.  As
the number of entries is less than that required by a maximal
skb, the host cannot proceed.

The guest did not have a refill job scheduled.

My diagnosis is that an OOM had occured, with the delayed refill
job scheduled.  The job was able to allocate at least one skb, but
not enough to overcome the minimum required by the host to proceed.

As the refill job would only reschedule itself if it failed completely
to allocate any skbs, this would lead to an RX stall.

The following patch removes this stall possibility by always
rescheduling the refill job until the ring is totally refilled.

Testing has shown that the RX stall no longer occurs whereas
previously it would occur within a day.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Bruce Rogers <brogers@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/virtio_net.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -398,8 +398,7 @@ static void refill_work(struct work_stru
 
 	vi = container_of(work, struct virtnet_info, refill.work);
 	napi_disable(&vi->napi);
-	try_fill_recv(vi, GFP_KERNEL);
-	still_empty = (vi->num == 0);
+	still_empty = !try_fill_recv(vi, GFP_KERNEL);
 	napi_enable(&vi->napi);
 
 	/* In theory, this can happen: if we don't get any buffers in


