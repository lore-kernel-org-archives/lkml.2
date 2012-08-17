Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030821Ab2HQDfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:35:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46748 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030631Ab2HQD04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:56 -0400
Message-Id: <20120817030244.417737302@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 04/37] caif: Fix access to freed pernet memory
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

[ Upstream commit 96f80d123eff05c3cd4701463786b87952a6c3ac ]

unregister_netdevice_notifier() must be called before
unregister_pernet_subsys() to avoid accessing already freed
pernet memory. This fixes the following oops when doing rmmod:

Call Trace:
 [<ffffffffa0f802bd>] caif_device_notify+0x4d/0x5a0 [caif]
 [<ffffffff81552ba9>] unregister_netdevice_notifier+0xb9/0x100
 [<ffffffffa0f86dcc>] caif_device_exit+0x1c/0x250 [caif]
 [<ffffffff810e7734>] sys_delete_module+0x1a4/0x300
 [<ffffffff810da82d>] ? trace_hardirqs_on_caller+0x15d/0x1e0
 [<ffffffff813517de>] ? trace_hardirqs_on_thunk+0x3a/0x3
 [<ffffffff81696bad>] system_call_fastpath+0x1a/0x1f

RIP
 [<ffffffffa0f7f561>] caif_get+0x51/0xb0 [caif]

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/caif/caif_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 68223e4..4e9115d 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -428,9 +428,9 @@ static int __init caif_device_init(void)
 
 static void __exit caif_device_exit(void)
 {
-	unregister_pernet_subsys(&caif_net_ops);
 	unregister_netdevice_notifier(&caif_device_notifier);
 	dev_remove_pack(&caif_packet_type);
+	unregister_pernet_subsys(&caif_net_ops);
 }
 
 module_init(caif_device_init);


