Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1KCBcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:32:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1KCBcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:32:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:51 2011
Message-Id: <20111102221451.093770996@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michal Schmidt <mschmidt@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [011/107] GRO: fix merging a paged skb after non-paged skbs
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

commit d1dc7abf2fafa34b0ffcd070fd59405aa9c0a4d8 upstream.

Suppose that several linear skbs of the same flow were received by GRO. They
were thus merged into one skb with a frag_list. Then a new skb of the same flow
arrives, but it is a paged skb with data starting in its frags[].

Before adding the skb to the frag_list skb_gro_receive() will of course adjust
the skb to throw away the headers. It correctly modifies the page_offset and
size of the frag, but it leaves incorrect information in the skb:
 ->data_len is not decreased at all.
 ->len is decreased only by headlen, as if no change were done to the frag.
Later in a receiving process this causes skb_copy_datagram_iovec() to return
-EFAULT and this is seen in userspace as the result of the recv() syscall.

In practice the bug can be reproduced with the sfc driver. By default the
driver uses an adaptive scheme when it switches between using
napi_gro_receive() (with skbs) and napi_gro_frags() (with pages). The bug is
reproduced when under rx load with enough successful GRO merging the driver
decides to switch from the former to the latter.

Manual control is also possible, so reproducing this is easy with netcat:
 - on machine1 (with sfc): nc -l 12345 > /dev/null
 - on machine2: nc machine1 12345 < /dev/zero
 - on machine1:
   echo 1 > /sys/module/sfc/parameters/rx_alloc_method  # use skbs
   echo 2 > /sys/module/sfc/parameters/rx_alloc_method  # use pages
 - See that nc has quit suddenly.

[v2: Modified by Eric Dumazet to avoid advancing skb->data past the end
     and to use a temporary variable.]

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/skbuff.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2746,8 +2746,12 @@ int skb_gro_receive(struct sk_buff **hea
 
 merge:
 	if (offset > headlen) {
-		skbinfo->frags[0].page_offset += offset - headlen;
-		skbinfo->frags[0].size -= offset - headlen;
+		unsigned int eat = offset - headlen;
+
+		skbinfo->frags[0].page_offset += eat;
+		skbinfo->frags[0].size -= eat;
+		skb->data_len -= eat;
+		skb->len -= eat;
 		offset = headlen;
 	}
 


