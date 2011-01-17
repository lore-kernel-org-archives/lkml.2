Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1AQKIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:08:48 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34325 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1AQKIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=QriLk8+eVBSGB7G5QfDqpz+TeNAraqm/+t9UPw/zVLhIslZceD3catnns9QkyVJgTN
         QG4aZ/Mc35RFpoE/oxXr0Mp9ckpr7txFHGb117sPMzjRzji9oP+VhcGQkIF9K1S85i9T
         audDfR19kqe7s+q+a2/luT9ZwojbDZ+kyRAQk=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: bluetooth: fix locking problem
Date: Mon, 17 Jan 2011 13:08:37 +0300
Message-Id: <1295258917-31092-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If alloc_skb() failed we still hold hci_dev_list_lock.  The code should
unlock it before exit.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 net/bluetooth/mgmt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index f827fd9..ace8726 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -111,8 +111,10 @@ static int read_index_list(struct sock *sk)
 
 	body_len = sizeof(*ev) + sizeof(*rp) + (2 * count);
 	skb = alloc_skb(sizeof(*hdr) + body_len, GFP_ATOMIC);
-	if (!skb)
+	if (!skb) {
+		read_unlock(&hci_dev_list_lock);
 		return -ENOMEM;
+	}
 
 	hdr = (void *) skb_put(skb, sizeof(*hdr));
 	hdr->opcode = cpu_to_le16(MGMT_EV_CMD_COMPLETE);
-- 
1.7.0.4

