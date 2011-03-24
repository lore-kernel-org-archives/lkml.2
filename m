Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab1CXHaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:30:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306Ab1CXHaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:30:20 -0400
From: Amit Shah <amit.shah@redhat.com>
To: linuxppc-dev@ozlabs.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, greg@kroah.com,
        Amit Shah <amit.shah@redhat.com>, stable@kernel.org
Subject: [PATCH] hvc_console: Don't access hvc_task if not initialised
Date: Thu, 24 Mar 2011 12:59:58 +0530
Message-Id: <df8ea6d65c1ceeb25b0a3fdfc66995b8a8273ea5.1300951793.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hvc_open() can be called without having any backing device.  This
results in a call to hvc_kick() which calls wake_up_process on a NULL
pointer.  Ensure hvc is initialised by checking for a non-NULL hvc_task
before waking up the hvc thread.

This was found by an autotest run for virtio_console without having a
console backend.

CC: stable@kernel.org
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/tty/hvc/hvc_console.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index e9cba13..b2cb5cc 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -286,6 +286,9 @@ EXPORT_SYMBOL_GPL(hvc_instantiate);
 /* Wake the sleeping khvcd */
 void hvc_kick(void)
 {
+	if (!hvc_task)
+		return;
+
 	hvc_kicked = 1;
 	wake_up_process(hvc_task);
 }
-- 
1.7.4

