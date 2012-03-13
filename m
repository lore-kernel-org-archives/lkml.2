Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab2CMAYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:48675 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab2CMAY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Romain Francoise <romain@orebokech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 160/196] ipv6: Silence privacy extensions initialization
Date: Mon, 12 Mar 2012 20:21:13 -0400
Message-Id: <1331598109-31424-115-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain Francoise <romain@orebokech.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2fdc1c8093255f9da877d7b9ce3f46c2098377dc upstream.

When a network namespace is created (via CLONE_NEWNET), the loopback
interface is automatically added to the new namespace, triggering a
printk in ipv6_add_dev() if CONFIG_IPV6_PRIVACY is set.

This is problematic for applications which use CLONE_NEWNET as
part of a sandbox, like Chromium's suid sandbox or recent versions of
vsftpd. On a busy machine, it can lead to thousands of useless
"lo: Disabled Privacy Extensions" messages appearing in dmesg.

It's easy enough to check the status of privacy extensions via the
use_tempaddr sysctl, so just removing the printk seems like the most
sensible solution.

Signed-off-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv6/addrconf.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 844ffc5..34ad669 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -408,9 +408,6 @@ static struct inet6_dev * ipv6_add_dev(struct net_device *dev)
 	    dev->type == ARPHRD_TUNNEL6 ||
 	    dev->type == ARPHRD_SIT ||
 	    dev->type == ARPHRD_NONE) {
-		printk(KERN_INFO
-		       "%s: Disabled Privacy Extensions\n",
-		       dev->name);
 		ndev->cnf.use_tempaddr = -1;
 	} else {
 		in6_dev_hold(ndev);
-- 
1.7.9.3

