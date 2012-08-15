Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2HOUdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:33:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:36509 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2HOTtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 028/165] GRO: fix merging a paged skb after non-paged skbs
Date: Wed, 15 Aug 2012 15:46:12 -0400
Message-ID: <1345060109-9187-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/skbuff.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9e7214e..7865bec 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2749,8 +2749,12 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 
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
 
-- 
1.7.12.rc2

