Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2AXW1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:27:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54310 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2AXW1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:27:34 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: levinsasha928@gmail.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, davej@redhat.com,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH net] caif: Fix crash due to uninitialized net name-space.
Date: Tue, 24 Jan 2012 23:27:25 +0100
Message-Id: <1327444045-1033-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <CA+1xoqdZapYjS4gPf_uGwEdFQQdZ525mASr7iFKPXJdCBdRLKA@mail.gmail.com>
References: <CA+1xoqdZapYjS4gPf_uGwEdFQQdZ525mASr7iFKPXJdCBdRLKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net_generic() calls BUG_ON() if called with uninitialized
network name-space. Add check if net is initialized before
calling net_generic(). This fixes the following oops:

[  200.752016] kernel BUG at include/net/netns/generic.h:40!
...
[  200.752016]  [<ffffffff825c3cea>] ? get_cfcnfg+0x3a/0x180
[  200.752016]  [<ffffffff821cf0b0>] ? lockdep_rtnl_is_held+0x10/0x20
[  200.752016]  [<ffffffff825c41be>] caif_device_notify+0x2e/0x530
[  200.752016]  [<ffffffff810d61b7>] notifier_call_chain+0x67/0x110
[  200.752016]  [<ffffffff810d67c1>] raw_notifier_call_chain+0x11/0x20
[  200.752016]  [<ffffffff821bae82>] call_netdevice_notifiers+0x32/0x60
[  200.752016]  [<ffffffff821c2b26>] register_netdevice+0x196/0x300
[  200.752016]  [<ffffffff821c2ca9>] register_netdev+0x19/0x30
[  200.752016]  [<ffffffff81c1c67a>] loopback_net_init+0x4a/0xa0
[  200.752016]  [<ffffffff821b5e62>] ops_init+0x42/0x180
[  200.752016]  [<ffffffff821b600b>] setup_net+0x6b/0x100
[  200.752016]  [<ffffffff821b6466>] copy_net_ns+0x86/0x110
[  200.752016]  [<ffffffff810d5789>] create_new_namespaces+0xd9/0x190

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---

Hi Sasha,

Do you have any chance to review and test this patch?
I'd like to get the net namespace handling this right this time ...

Thanks,
Sjur 

 net/caif/caif_dev.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 673728a..6110ade 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -371,6 +371,14 @@ static int caif_device_notify(struct notifier_block *me, unsigned long what,
 	struct cflayer *layer, *link_support;
 	int head_room = 0;
 	struct caif_device_entry_list *caifdevs;
+	int len;
+
+	rcu_read_lock();
+	len = rcu_dereference(dev_net(dev)->gen)->len;
+	rcu_read_unlock();
+
+	if (caif_net_id == 0 || caif_net_id > len)
+		return 0;
 
 	cfg = get_cfcnfg(dev_net(dev));
 	caifdevs = caif_device_list(dev_net(dev));
-- 
1.7.0.4

