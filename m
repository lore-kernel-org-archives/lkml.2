Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2BRS3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 13:29:34 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:59399 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab2BRS3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 13:29:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAOzsP08Y9geI/2dsb2JhbAAMOIUSsDcEUT0WCwILAwIBAgFLAQwGAgEBr1WRPIwuBjEHARADgz4DKBQFghmBFgSIToYAkCOJUYE+
X-IronPort-AV: E=Sophos;i="4.73,443,1325480400"; 
   d="scan'208";a="163557453"
Message-ID: <4F3FEE09.6070502@teksavvy.com>
Date: Sat, 18 Feb 2012 13:29:29 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb: fix tuner registration without CONFIG_DVB_NET
Content-Type: multipart/mixed;
 boundary="------------020501080205070806050805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020501080205070806050805
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ever since linux-3.1, my DVB tuners have been non-functional.
This turns out to be due to a bug in with this chunk of code
inside linux/drivers/media/video/videobuf-dvb.c:

        /* register network adapter */
        dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
        if (dvb->net.dvbdev == NULL) {
                result = -ENOMEM;
                goto fail_fe_conn;
        }

The problem is, dvb_net_init() doesn't do anything
for the case where CONFIG_DVB_NET is not set.
And the code in videobuf-dvb.c treats this as a fatal error.

The patch below (linux-3.2.6) fixes the regression.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
Patch is also attached to bypass email mangling.

--- linux-3.2.6/drivers/media/video/videobuf-dvb.c	2012-02-13 14:17:29.000000000
-0500
+++ linux/drivers/media/video/videobuf-dvb.c	2012-02-18 13:21:42.422716047 -0500
@@ -226,9 +226,10 @@
 	}

 	/* register network adapter */
-	dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
-	if (dvb->net.dvbdev == NULL) {
-		result = -ENOMEM;
+	result = dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
+	if (result < 0) {
+		printk(KERN_WARNING "%s: dvb_net_init failed (errno = %d)\n",
+		       dvb->name, result);
 		goto fail_fe_conn;
 	}
 	return 0;

--------------020501080205070806050805
Content-Type: text/x-patch;
 name="13_linux-3.2_dvb_net_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="13_linux-3.2_dvb_net_fix.patch"

--- linux-3.2.6/drivers/media/video/videobuf-dvb.c	2012-02-13 14:17:29.000000000 -0500
+++ linux/drivers/media/video/videobuf-dvb.c	2012-02-18 13:21:42.422716047 -0500
@@ -226,9 +226,10 @@
 	}
 
 	/* register network adapter */
-	dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
-	if (dvb->net.dvbdev == NULL) {
-		result = -ENOMEM;
+	result = dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
+	if (result < 0) {
+		printk(KERN_WARNING "%s: dvb_net_init failed (errno = %d)\n",
+		       dvb->name, result);
 		goto fail_fe_conn;
 	}
 	return 0;

--------------020501080205070806050805--
