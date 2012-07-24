Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2GXOts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:49:48 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57040 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2GXOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:49:47 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Devendra Naga <devendra.aaru@gmail.com>, benchan@chromium.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2] staging: gdm72xx: fix reference counting in gdm_wimax_event_init
Date: Tue, 24 Jul 2012 07:49:42 -0700
Message-Id: <1343141382-31087-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the commit "staging/gdm72xx: cleanup little at
gdm_wimax_event_rcv" (8df858ea76b76dde9a39d4edd9aaded983582cfe),
which mishandles the reference counting of wm_event.

Signed-off-by: Ben Chan <benchan@chromium.org>
---
Fixed the commit message as suggested by Dan Carpenter.

 drivers/staging/gdm72xx/gdm_wimax.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 0716efc..6cb8107 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -258,12 +258,16 @@ static int gdm_wimax_event_init(void)
 	if (!wm_event.ref_cnt) {
 		wm_event.sock = netlink_init(NETLINK_WIMAX,
 						gdm_wimax_event_rcv);
-		if (wm_event.sock)
-			wm_event.ref_cnt++;
-		INIT_LIST_HEAD(&wm_event.evtq);
-		INIT_LIST_HEAD(&wm_event.freeq);
-		INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
-		spin_lock_init(&wm_event.evt_lock);
+		if (wm_event.sock) {
+			INIT_LIST_HEAD(&wm_event.evtq);
+			INIT_LIST_HEAD(&wm_event.freeq);
+			INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
+			spin_lock_init(&wm_event.evt_lock);
+		}
+	}
+
+	if (wm_event.sock) {
+		wm_event.ref_cnt++;
 		return 0;
 	}
 
-- 
1.7.7.3

