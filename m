Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2JJXVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:21:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58531 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566Ab2JJWyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:47 -0400
X-Sasl-enc: 6LfU7xTXDUpr16fctu2tGupaCn2tgLfkpbv5RPRxmemJ 1349909686
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Linus=20L=FCssing?= <linus.luessing@web.de>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <ordex@autistici.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20043/133=5D=20batman-adv=3A=20make=20batadv=5Ftest=5Fbit=28=29=20return=200=20or=201=20only?=
Date: Thu, 11 Oct 2012 07:51:09 +0900
Message-Id: <20121010224902.248029092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Linus Lüssing <linus.luessing@web.de>

[ Upstream commit dbd6b11e15a2f96030da17dbeda943a8a98ee990 ]

On some architectures test_bit() can return other values than 0 or 1:

With a generic x86 OpenWrt image in a kvm setup (batadv_)test_bit()
frequently returns -1 for me, leading to batadv_iv_ogm_update_seqnos()
wrongly signaling a protected seqno window.

This patch tries to fix this issue by making batadv_test_bit() return 0
or 1 only.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bitarray.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/batman-adv/bitarray.h
+++ b/net/batman-adv/bitarray.h
@@ -22,8 +22,9 @@
 #ifndef _NET_BATMAN_ADV_BITARRAY_H_
 #define _NET_BATMAN_ADV_BITARRAY_H_
 
-/* returns true if the corresponding bit in the given seq_bits indicates true
- * and curr_seqno is within range of last_seqno */
+/* Returns 1 if the corresponding bit in the given seq_bits indicates true
+ * and curr_seqno is within range of last_seqno. Otherwise returns 0.
+ */
 static inline int bat_test_bit(const unsigned long *seq_bits,
 			       uint32_t last_seqno, uint32_t curr_seqno)
 {
@@ -33,7 +34,7 @@ static inline int bat_test_bit(const uns
 	if (diff < 0 || diff >= TQ_LOCAL_WINDOW_SIZE)
 		return 0;
 	else
-		return  test_bit(diff, seq_bits);
+		return test_bit(diff, seq_bits) != 0;
 }
 
 /* turn corresponding bit on, so we can remember that we got the packet */


