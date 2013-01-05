Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3AEJmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 04:42:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab3AEJm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:42:29 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 3/3] tuntap: don't add to waitqueue when POLLERR
Date: Sat,  5 Jan 2013 17:34:06 +0800
Message-Id: <1357378446-19656-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1357378446-19656-1-git-send-email-jasowang@redhat.com>
References: <1357378446-19656-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, tun_chr_poll() returns POLLERR after waitqueue adding during device
unregistration. This would confuse some of its user such as vhost which assume
when POLLERR is returned, it wasn't added to the waitqueue. Fix this by
returning POLLERR before adding to waitqueue.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fbd106e..f9c0049 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -886,7 +886,7 @@ static unsigned int tun_chr_poll(struct file *file, poll_table *wait)
 	struct sock *sk;
 	unsigned int mask = 0;
 
-	if (!tun)
+	if (!tun || tun->dev->reg_state != NETREG_REGISTERED)
 		return POLLERR;
 
 	sk = tfile->socket.sk;
@@ -903,9 +903,6 @@ static unsigned int tun_chr_poll(struct file *file, poll_table *wait)
 	     sock_writeable(sk)))
 		mask |= POLLOUT | POLLWRNORM;
 
-	if (tun->dev->reg_state != NETREG_REGISTERED)
-		mask = POLLERR;
-
 	tun_put(tun);
 	return mask;
 }
-- 
1.7.1

