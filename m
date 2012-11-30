Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab2K3S5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:57:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:58690 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab2K3S4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 55/56] net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()
Date: Fri, 30 Nov 2012 10:55:47 -0800
Message-Id: <20121130185123.927244281@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ipw2x00/ipw2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -10471,7 +10471,7 @@ static void ipw_handle_promiscuous_tx(st
 		} else
 			len = src->len;
 
-		dst = alloc_skb(len + sizeof(*rt_hdr), GFP_ATOMIC);
+		dst = alloc_skb(len + sizeof(*rt_hdr) + sizeof(u16)*2, GFP_ATOMIC);
 		if (!dst)
 			continue;
 


