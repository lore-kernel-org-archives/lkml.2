Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab0JZNgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:36:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35427 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892Ab0JZNgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:36:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 26 Oct 2010 15:38:56 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 5/7] USB: gadget: f_mass_storage: remove needless complete()
In-reply-to: <1fb12ac8cc8a5dfd642353eaf4a5e8ba3e868baa.1288099890.git.m.nazarewicz@samsung.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <21dc34fe596e4d6694f560d3fa823dac758ba0b4.1288099890.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <7214986593243afb11434ddb86da7e0460dc1f51.1288099890.git.m.nazarewicz@samsung.com>
 <4a6e11ec91ee592689f553dc69df515b4302691b.1288099890.git.m.nazarewicz@samsung.com>
 <e4d7faa839773178984edc8e17cffed7b44e1411.1288099890.git.m.nazarewicz@samsung.com>
 <1fb12ac8cc8a5dfd642353eaf4a5e8ba3e868baa.1288099890.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit removes call to the complete() function done in
fsg_unbind() which was never needed there but was a leftover
form file_storage.c.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

An additional complete() didn't hurt but at the same time it was
rather useless.

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index c71f69f..365f1b3 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2657,7 +2657,7 @@ static int fsg_main_thread(void *common_)
 		up_write(&common->filesem);
 	}
 
-	/* Let the unbind and cleanup routines know the thread has exited */
+	/* Let fsg_unbind() know the thread has exited */
 	complete_and_exit(&common->thread_notifier, 0);
 }
 
@@ -2906,9 +2906,6 @@ static void fsg_common_release(struct kref *ref)
 	if (common->state != FSG_STATE_TERMINATED) {
 		raise_exception(common, FSG_STATE_EXIT);
 		wait_for_completion(&common->thread_notifier);
-
-		/* The cleanup routine waits for this completion also */
-		complete(&common->thread_notifier);
 	}
 
 	if (likely(common->luns)) {
-- 
1.7.1

