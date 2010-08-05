Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732Ab0HEWnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:43:47 -0400
Received: from kroah.org ([198.145.64.141]:37643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260Ab0HEWYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/67] tty: Make vt's have a tty_port
Date: Thu,  5 Aug 2010 15:22:55 -0700
Message-Id: <1281047014-23429-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The vt layer isn't safely handling reference counts to tty object on the input
side. Add a tty port structure to the vt layer in order to implement this using
the standard helpers.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt.c              |    2 ++
 include/linux/console_struct.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 321c928..a950b28 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -777,6 +777,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    if (!vc)
 		return -ENOMEM;
 	    vc_cons[currcons].d = vc;
+	    tty_port_init(&vc->port);
 	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
@@ -2914,6 +2915,7 @@ static int __init con_init(void)
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
+		tty_port_init(&vc->port);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index d7d9acd..25bf67f 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -21,6 +21,8 @@ struct vt_struct;
 #define NPAR 16
 
 struct vc_data {
+	struct tty_port port;			/* Upper level data */
+
 	unsigned short	vc_num;			/* Console number */
 	unsigned int	vc_cols;		/* [#] Console size */
 	unsigned int	vc_rows;
-- 
1.7.2

