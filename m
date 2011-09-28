Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab1I1Wtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933383Ab1I1Wtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.172568539@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [188/244] xfrm: Perform a replay check after return from async codepaths
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit bcf66bf54aabffc150acd1c99e0f4bc51935eada ]

When asyncronous crypto algorithms are used, there might be many
packets that passed the xfrm replay check, but the replay advance
function is not called yet for these packets. So the replay check
function would accept a replay of all of these packets. Also the
system might crash if there are more packets in async processing
than the size of the anti replay window, because the replay advance
function would try to update the replay window beyond the bounds.

This pach adds a second replay check after resuming from the async
processing to fix these issues.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/xfrm/xfrm_input.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -212,6 +212,11 @@ resume:
 		/* only the first xfrm gets the encap type */
 		encap_type = 0;
 
+		if (async && x->repl->check(x, skb, seq)) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
+			goto drop_unlock;
+		}
+
 		x->repl->advance(x, seq);
 
 		x->curlft.bytes += skb->len;


