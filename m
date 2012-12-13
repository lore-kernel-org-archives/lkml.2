Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2LMOXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:23:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45001 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225Ab2LMONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Leblond <eric@regit.org>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 204/241] af-packet: fix oops when socket is not present
Date: Thu, 13 Dec 2012 11:59:29 -0200
Message-Id: <1355407206-17100-205-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Leblond <eric@regit.org>

commit a3d744e995d2b936c500585ae39d99ee251c89b4 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4ef7993..75845ba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1642,7 +1642,7 @@ static inline int deliver_skb(struct sk_buff *skb,
 
 static inline bool skb_loop_sk(struct packet_type *ptype, struct sk_buff *skb)
 {
-	if (ptype->af_packet_priv == NULL)
+	if (!ptype->af_packet_priv || !skb->sk)
 		return false;
 
 	if (ptype->id_match)
-- 
1.7.9.5

