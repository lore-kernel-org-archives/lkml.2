Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2HGT4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:56:50 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49891 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2HGT4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:56:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Samo Pogacnik <samo_pogacnik@t-2.net>
Subject: [PATCH 15/41] TTY: ttyprintk, initialize tty_port earlier
Date: Tue,  7 Aug 2012 21:47:40 +0200
Message-Id: <1344368886-24033-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After tty_register_driver is called, it is too late to initialize a
guy with which we operate in open. When a process already called
open(2) on that node, the structures may be in use uninitialized.

Move the initialization prior to tty_register_driver.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>
---
 drivers/char/ttyprintk.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index 08755c5..be1c3fb 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -180,6 +180,10 @@ static int __init ttyprintk_init(void)
 	int ret = -ENOMEM;
 	void *rp;
 
+	tty_port_init(&tpk_port.port);
+	tpk_port.port.ops = &null_ops;
+	mutex_init(&tpk_port.port_write_mutex);
+
 	ttyprintk_driver = alloc_tty_driver(1);
 	if (!ttyprintk_driver)
 		return ret;
@@ -210,10 +214,6 @@ static int __init ttyprintk_init(void)
 		goto error;
 	}
 
-	tty_port_init(&tpk_port.port);
-	tpk_port.port.ops = &null_ops;
-	mutex_init(&tpk_port.port_write_mutex);
-
 	return 0;
 
 error:
-- 
1.7.10.4


