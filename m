Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2J1XgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:36:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42132 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756912Ab2J1X2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:08 -0400
Message-Id: <20121028231552.457274284@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 050/105] net/wireless: ipw2200: Fix panic occurring in
 ipw_handle_promiscuous_tx()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 935120f..768bf61 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -10472,7 +10472,7 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 		} else
 			len = src->len;
 
-		dst = alloc_skb(len + sizeof(*rt_hdr), GFP_ATOMIC);
+		dst = alloc_skb(len + sizeof(*rt_hdr) + sizeof(u16)*2, GFP_ATOMIC);
 		if (!dst)
 			continue;
 


