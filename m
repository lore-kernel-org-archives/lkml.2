Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2A2UzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:55:15 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20423 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2A2UzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:55:14 -0500
Date: Sun, 29 Jan 2012 21:55:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        "R.M. Thomas" <rmthomas@sciolus.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH] staging, media, easycap: Fix mem leak in
 easycap_usb_probe()
Message-ID: <alpine.LNX.2.00.1201292152590.27749@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If allocating 'pdata_urb' fails, the function will return -ENOMEM
without freeing the memory allocated, just a few lines above, for
'purb' and will leak that memory when 'purb' goes out of scope.

This patch resolves the leak by freeing the allocated storage with
usb_free_urb() before the return.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/media/easycap/easycap_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

  compile tested only

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 8ff5f38..3d439b7 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3825,6 +3825,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 			pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
 			if (!pdata_urb) {
+				usb_free_urb(purb);
 				SAM("ERROR: Could not allocate struct data_urb.\n");
 				return -ENOMEM;
 			}
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

