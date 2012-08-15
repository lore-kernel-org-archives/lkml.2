Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab2HOT7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:59:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:39393 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2HOT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:59:24 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] scripts/modpost: add a exception for USB gadget drivers
Date: Wed, 15 Aug 2012 21:59:12 +0200
Message-Id: <1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de>
References: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "driver" struct for a gadget driver is named *_driver. On module
load, the gadget expects a UDC driver to be loaded and avaiable. If this
is not the case => -ENODEV and bye bye. That means that the gadget
driver is initialized immediately. The initialization process includes
calling ->bind() for the gadget driver. Therefore it is okay to put this
in __init. It will never be called again, we don't (yet) allow two
gadgets of the same kind to be ->bind() again.

Commit 07a18bd716 ("usb gadget: don't save bind callback in struct
usb_composite_driver") move the ->bind() member from the struct to an
argument.
I'm reverting this and adding this exception. For g_zero we save around
400bytes. I'm not having the conversion about how important it is to
save 400 bytes. I wait for configfs interface for the gadget subsystem.
This will remove the __init from the ->bind() because we will be able to
call ->bind() more than once and _after_ the init has been dropped.

Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 scripts/mod/modpost.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 68e9f5e..5e30776 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -920,6 +920,9 @@ static const char *head_sections[] = { ".head.text*", NULL };
 static const char *linker_symbols[] =
 	{ "__init_begin", "_sinittext", "_einittext", NULL };
 
+static const char *const driver_sym[] = { "*_driver", NULL };
+static const char *const gadget_bind[] = { "*_bind", NULL };
+
 enum mismatch {
 	TEXT_TO_ANY_INIT,
 	DATA_TO_ANY_INIT,
@@ -1129,6 +1132,13 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 	    match(fromsym, mismatch->symbol_white_list))
 		return 0;
 
+	/* Check for pattern 2a */
+	if (match(tosec, init_exit_sections) &&
+	    match(fromsec, data_sections) &&
+	    match(fromsym, driver_sym) &&
+	    match(tosym, gadget_bind))
+		return 0;
+
 	/* Check for pattern 3 */
 	if (match(fromsec, head_sections) &&
 	    match(tosec, init_sections))
-- 
1.7.10.4

