Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1BNKyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:54:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1BNKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:54:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=IchwaTj66/ms1/+amfnFNmA8x1HvaReXglhvtb6Oeuz1GXtuia8kxEbzaWffxwGQll
         uUgm/XClZEfo8qcOV5wY59fokOp1hH0mB+XbB4FPWnenXsVK3P2wSpdkcM5ueF/ps9NT
         a3NoQxCVodnFJvbaprsO+fmYlCS+gnMcpG6vo=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        ebtables-user@lists.sourceforge.net,
        ebtables-devel@lists.sourceforge.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] bridge: netfilter: fix information leak
Date: Mon, 14 Feb 2011 13:54:35 +0300
Message-Id: <1297680875-11663-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struct tmp is copied from userspace.  It is not checked whether the "name"
field is NULL terminated.  This may lead to buffer overflow and passing
contents of kernel stack as a module name to try_then_request_module() and,
consequently, to modprobe commandline.  It would be seen by all userspace
processes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 net/bridge/netfilter/ebtables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5f1825d..1ea820b 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1107,6 +1107,8 @@ static int do_replace(struct net *net, const void __user *user,
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
 
+	tmp.name[sizeof(tmp.name)-1] = 0;
+
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
 	if (!newinfo)
-- 
1.7.0.4

