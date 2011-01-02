Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1ABHyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:54:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:35523 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1ABHXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 108/260] tun: Don't add sysfs attributes to devices without sysfs directories
Date: Sun,  2 Jan 2011 02:16:44 -0500
Message-Id: <1293952756-15010-109-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:08.0071 (UTC) FILETIME=[C394E570:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

This applies to 2.6.32 *only*.  It has not been applied upstream since
the limitation no longer exists.

Prior to Linux 2.6.35, net devices outside the initial net namespace
did not have sysfs directories.  Attempting to add attributes to
them will trigger a BUG().

Reported-and-tested-by: Russell Stuart <russell-debian@stuart.id.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/tun.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4326520..7b4a88b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1061,7 +1061,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		if (err < 0)
 			goto err_free_sk;
 
-		if (device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
+		if (!net_eq(dev_net(tun->dev), &init_net) ||
+		    device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_group))
 			printk(KERN_ERR "Failed to create tun sysfs files\n");
-- 
1.7.3.3

