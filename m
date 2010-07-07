Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0GGCwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:52:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:48863 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752247Ab0GGCwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:52:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19NRmhsqeZN1nKbwwxj+D0ED0oiMHpYeW2PiR2Xbw
	GZgC3Ijr3SB731
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/panel: Prevent double-calling of parport_release - fix oops.
Date: Wed, 7 Jul 2010 04:52:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, Julia Lawall <julia@diku.dk>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007070452.16860.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch prevents the code from calling parport_release and
parport_unregister_device twice with the same arguments - and thus fixes an oops.

Rationale:
After the first call the parport is already released and the
handle isn't valid anymore and calling parport_release and
parport_unregister_device twice isn't a good idea.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100607

 drivers/staging/panel/panel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 3154ffe..6fa57be 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2277,6 +2277,7 @@ int panel_init(void)
 		if (pprt) {
 			parport_release(pprt);
 			parport_unregister_device(pprt);
+			pprt = NULL;
 		}
 		parport_unregister_driver(&panel_driver);
 		printk(KERN_ERR "Panel driver version " PANEL_VERSION
@@ -2327,6 +2328,7 @@ static void __exit panel_cleanup_module(void)
 		/* TODO: free all input signals */
 		parport_release(pprt);
 		parport_unregister_device(pprt);
+		pprt = NULL;
 	}
 	parport_unregister_driver(&panel_driver);
 }
-- 
1.7.1

