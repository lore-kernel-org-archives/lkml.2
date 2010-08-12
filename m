Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0HLATt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:19:49 -0400
Received: from kroah.org ([198.145.64.141]:60476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011Ab0HLAH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:57 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:13 2010
Message-Id: <20100812000613.674427535@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Huewe <peterhuewe@gmx.de>, Willy Tarreau <w@1wt.eu>
Subject: [11/67] Staging: panel: Prevent double-calling of parport_release - fix oops.
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Huewe <peterhuewe@gmx.de>

commit 060132ae42cce3f9d2fd34d9a17b98362b44b9f9 upstream.

This patch prevents the code from calling parport_release and
parport_unregister_device twice with the same arguments - and thus fixes an oops.

Rationale:
After the first call the parport is already released and the
handle isn't valid anymore and calling parport_release and
parport_unregister_device twice isn't a good idea.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/panel/panel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2179,6 +2179,7 @@ int panel_init(void)
 		if (pprt) {
 			parport_release(pprt);
 			parport_unregister_device(pprt);
+			pprt = NULL;
 		}
 		parport_unregister_driver(&panel_driver);
 		printk(KERN_ERR "Panel driver version " PANEL_VERSION
@@ -2228,6 +2229,7 @@ static void __exit panel_cleanup_module(
 		/* TODO: free all input signals */
 		parport_release(pprt);
 		parport_unregister_device(pprt);
+		pprt = NULL;
 	}
 	parport_unregister_driver(&panel_driver);
 }


