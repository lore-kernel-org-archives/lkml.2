Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2JaKoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:44:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44942 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2JaKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:44:17 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net
Subject: [PATCH] isdn/gigaset: use tasklet_kill in device remove/release process
Date: Wed, 31 Oct 2012 18:44:51 +0800
Message-Id: <1351680291-27202-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some driver uses tasklet_disable in device remove/release process,
tasklet_disable will inc tasklet->count and return. If the tasklet
is not handled yet under some softirq pressure, the tasklet will be
placed on the tasklet_vec, never have a chance to be excuted. This might
lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
tasklet is disabled. tasklet_kill should be used in this case.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: gigaset307x-common@lists.sourceforge.net 
---
 drivers/isdn/gigaset/interface.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 67abf3f..284c7f3 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -544,7 +544,6 @@ void gigaset_if_free(struct cardstate *cs)
 	if (!drv->have_tty)
 		return;
 
-	tasklet_disable(&cs->if_wake_tasklet);
 	tasklet_kill(&cs->if_wake_tasklet);
 	cs->tty_dev = NULL;
 	tty_unregister_device(drv->tty, cs->minor_index);
-- 
1.7.9.5

