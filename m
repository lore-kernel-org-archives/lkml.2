Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031383Ab2HGWw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:52:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42489 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031246Ab2HGWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:47:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Sjur=20Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=2031/49=5D=20caif=3A=20Fix=20access=20to=20freed=20pernet=20memory?=
Date: Tue,  7 Aug 2012 15:44:49 -0700
Message-Id: <20120807222029.666240197@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/caif_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -424,9 +424,9 @@ static int __init caif_device_init(void)
 
 static void __exit caif_device_exit(void)
 {
-	unregister_pernet_subsys(&caif_net_ops);
 	unregister_netdevice_notifier(&caif_device_notifier);
 	dev_remove_pack(&caif_packet_type);
+	unregister_pernet_subsys(&caif_net_ops);
 }
 
 module_init(caif_device_init);


