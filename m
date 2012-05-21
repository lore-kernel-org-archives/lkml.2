Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2EUA4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 20:56:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28812 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2EUA4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 20:56:42 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-8a-4fb992c969a5
Message-id: <4FB992C8.8090105@samsung.com>
Date: Mon, 21 May 2012 09:56:40 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Gustavo Padovan <gustavo@padovan.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] Bluetooth: prevent double l2cap_chan_destroy
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd2Tk3b6Gyz5x28x51ofs8XlXXPY
	LI4tEHNg9vi8SS6AMYrLJiU1J7MstUjfLoErY/WVN8wFtzgqNm3cydLAuJG9i5GTQ0LAROLd
	ylesELaYxIV769m6GLk4hAQWMUq8PHCHCcJ5yygxf9EqNpAqXgEticV3z4J1sAioSnw40s0I
	YrMJKEvcfXYLLC4qECbxesohFoh6QYkfk++B2SICmhJTT20B28AscINRYs23V2AJYQFHiS03
	voEtYBbQkdjfOg3KlpfYvOYt8wRGvllIZs1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMFh9kx6B+OqBotDjAIcjEo8vAZdO/2FWBPLiitzDzFKcDArifBKZ+3wF+JNSays
	Si3Kjy8qzUktPsQozcGiJM77ZAlQSiA9sSQ1OzW1ILUIJsvEwSnVwFgjUSPO0GrRdyneWG7N
	JdGqa/8m3ls93/X5BoPJh39N2f/lnZn2sXNB2ZeOqaRe1WS4Nve44bM5QqpJTDeK/DLNjSWM
	417/Vf9kPpOlzZTj1hK/KmPbXtXMMJ0Hv9NvXjSexqudcHeZ3/RJVR8/BKWwqc2ate9U9Vue
	/RPn8Ff+qOe5kPE5wE2JpTgj0VCLuag4EQAKwiG5LwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

l2cap_sock_kill can be called in l2cap_sock_release and l2cap_sock_close_cb
either. This lead l2cap_chan_destroy to be called twice for same channel.
To prevent double list_del and double chan_put, chan_destroy should be protected
with chan->refcnt and chan_list_lock so that reentrance could be forbidden.

Signed-off-by: Minho Ban <mhban@samsung.com>
---
 net/bluetooth/l2cap_core.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 24f144b..156ca14 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -400,10 +400,14 @@ struct l2cap_chan *l2cap_chan_create(void)
 void l2cap_chan_destroy(struct l2cap_chan *chan)
 {
 	write_lock(&chan_list_lock);
+	/* Check if channel is valid */
+	if (!atomic_read(&chan->refcnt)) {
+		write_unlock(&chan_list_lock);
+		return;
+	}
 	list_del(&chan->global_l);
-	write_unlock(&chan_list_lock);
-
 	l2cap_chan_put(chan);
+	write_unlock(&chan_list_lock);
 }
 
 void l2cap_chan_set_defaults(struct l2cap_chan *chan)
-- 
1.7.5.4

