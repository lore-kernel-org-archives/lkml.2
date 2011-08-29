Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1H2USD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:18:03 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:53695 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1H2USA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:18:00 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: lirc: fix mismatch in mutex lock-unlock in imon_probe
Date: Tue, 30 Aug 2011 00:17:56 +0400
Message-Id: <1314649076-28825-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc failed for allocation of context, goto alloc_status_switch
leads to unlock of unacquired driver_lock. The patch moves
mutex_lock(&driver_lock) before allocation of context.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/lirc/lirc_imon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lirc/lirc_imon.c b/drivers/staging/lirc/lirc_imon.c
index 4a9e563..f5308d5 100644
--- a/drivers/staging/lirc/lirc_imon.c
+++ b/drivers/staging/lirc/lirc_imon.c
@@ -727,6 +727,9 @@ static int imon_probe(struct usb_interface *interface,
 	int i;
 	u16 vendor, product;
 
+	/* prevent races probing devices w/multiple interfaces */
+	mutex_lock(&driver_lock);
+
 	context = kzalloc(sizeof(struct imon_context), GFP_KERNEL);
 	if (!context) {
 		err("%s: kzalloc failed for context", __func__);
@@ -753,9 +756,6 @@ static int imon_probe(struct usb_interface *interface,
 	dev_dbg(dev, "%s: found iMON device (%04x:%04x, intf%d)\n",
 		__func__, vendor, product, ifnum);
 
-	/* prevent races probing devices w/multiple interfaces */
-	mutex_lock(&driver_lock);
-
 	/*
 	 * Scan the endpoint list and set:
 	 *	first input endpoint = IR endpoint
-- 
1.7.4.1

