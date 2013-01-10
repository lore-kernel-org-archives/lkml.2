Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3AJIQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:16:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3AJIQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:16:11 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 3.8-rc] tuntap: refuse to re-attach to different tun_struct
Date: Thu, 10 Jan 2013 08:59:48 +0100
Message-Id: <1357804788-19976-1-git-send-email-stefanha@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiqueue tun devices support detaching a tun_file from its tun_struct
and re-attaching at a later point in time.  This allows users to disable
a specific queue temporarily.

ioctl(TUNSETIFF) allows the user to specify the network interface to
attach by name.  This means the user can attempt to attach to interface
"B" after detaching from interface "A".

The driver is not designed to support this so check we are re-attaching
to the right tun_struct.  Failure to do so may lead to oops.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
This fix is for 3.8-rc.

 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fbd106e..cf6da6e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -491,6 +491,8 @@ static int tun_attach(struct tun_struct *tun, struct file *file)
 	err = -EINVAL;
 	if (rcu_dereference_protected(tfile->tun, lockdep_rtnl_is_held()))
 		goto out;
+	if (tfile->detached && tun != tfile->detached)
+		goto out;
 
 	err = -EBUSY;
 	if (!(tun->flags & TUN_TAP_MQ) && tun->numqueues == 1)
-- 
1.8.0.2

