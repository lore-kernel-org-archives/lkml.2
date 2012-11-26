Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab2KZRh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:37:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab2KZRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 187/270] net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()
Date: Mon, 26 Nov 2012 14:57:57 -0200
Message-Id: <1353949160-26803-188-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Yakovlev <stas.yakovlev@gmail.com>

commit bf11315eeda510ea4fc1a2bf972d8155d31d89b4 upstream.

The driver does not count space of radiotap fields when allocating skb for
radiotap packet. This leads to kernel panic with the following call trace:

...
[67607.676067] [<c152f90f>] error_code+0x67/0x6c
[67607.676067] [<c142f831>] ? skb_put+0x91/0xa0
[67607.676067] [<f8cf5e5b>] ? ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2200]
[67607.676067] [<f8cf5e5b>] ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2200]
[67607.676067] [<f8cf899b>] ipw_net_hard_start_xmit+0x8b/0x90 [ipw2200]
[67607.676067] [<f8741c5a>] libipw_xmit+0x55a/0x980 [libipw]
[67607.676067] [<c143d3e8>] dev_hard_start_xmit+0x218/0x4d0
...

This bug was found by VittGam.
https://bugzilla.kernel.org/show_bug.cgi?id=43255

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 0036737..1f2edf2 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -10470,7 +10470,7 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 		} else
 			len = src->len;
 
-		dst = alloc_skb(len + sizeof(*rt_hdr), GFP_ATOMIC);
+		dst = alloc_skb(len + sizeof(*rt_hdr) + sizeof(u16)*2, GFP_ATOMIC);
 		if (!dst)
 			continue;
 
-- 
1.7.9.5

