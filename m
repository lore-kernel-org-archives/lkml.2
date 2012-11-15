Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993074Ab2KOEa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:30:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:49418 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993065Ab2KOEL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Leblond <eric@regit.org>, "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=2055/66=5D=20af-packet=3A=20fix=20oops=20when=20socket=20is=20not=20present?=
Date: Wed, 14 Nov 2012 20:11:00 -0800
Message-Id: <20121115040943.117297130@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Leblond <eric@regit.org>

[ Upstream commit a3d744e995d2b936c500585ae39d99ee251c89b4 ]

Due to a NULL dereference, the following patch is causing oops
in normal trafic condition:

commit c0de08d04215031d68fa13af36f347a6cfa252ca
Author: Eric Leblond <eric@regit.org>
Date:   Thu Aug 16 22:02:58 2012 +0000

    af_packet: don't emit packet on orig fanout group

This buggy patch was a feature fix and has reached most stable
branches.

When skb->sk is NULL and when packet fanout is used, there is a
crash in match_fanout_group where skb->sk is accessed.
This patch fixes the issue by returning false as soon as the
socket is NULL: this correspond to the wanted behavior because
the kernel as to resend the skb to all the listening socket in
this case.

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1644,7 +1644,7 @@ static inline int deliver_skb(struct sk_
 
 static inline bool skb_loop_sk(struct packet_type *ptype, struct sk_buff *skb)
 {
-	if (ptype->af_packet_priv == NULL)
+	if (!ptype->af_packet_priv || !skb->sk)
 		return false;
 
 	if (ptype->id_match)


