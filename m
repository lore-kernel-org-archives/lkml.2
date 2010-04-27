Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0D0W5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:57:12 -0400
Received: from forward8.mail.yandex.net ([77.88.61.38]:40149 "EHLO
	forward8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0D0W5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:57:11 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 18:57:11 EDT
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
To: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
Date: Wed, 28 Apr 2010 02:51:43 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/p21LWMN5hJm4wa"
Message-Id: <201004280251.43430.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1272408722
X-Yandex-Spam: 1
X-Yandex-Front: smtp7.mail.yandex.net
X-Yandex-Suid-Status: 1 0,1 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/p21LWMN5hJm4wa
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch makes aio_run_iocb() to always reinitialize iocb->ki_run_list (not 
only when iocb->ki_retry() function returns -EIOCBRETRY) so that subsequent 
call of kick_iocb() will succeed.

Regards, Sergey Temerkhanov,
Cifronic ZAO.

--Boundary-00=_/p21LWMN5hJm4wa
Content-Type: text/x-patch;
  charset="us-ascii";
  name="reinit-ki_run_list.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="reinit-ki_run_list.patch"

diff -r 97344a0f62c9 fs/aio.c
--- a/fs/aio.c	Tue Apr 27 21:18:14 2010 +0400
+++ b/fs/aio.c	Tue Apr 27 21:30:23 2010 +0400
@@ -748,6 +748,9 @@
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 
+	/* will make __queue_kicked_iocb succeed from here on */
+	INIT_LIST_HEAD(&iocb->ki_run_list);
+
 	if (-EIOCBRETRY == ret) {
 		/*
 		 * OK, now that we are done with this iteration
@@ -756,8 +759,6 @@
 		 * "kick" can start the next iteration
 		 */
 
-		/* will make __queue_kicked_iocb succeed from here on */
-		INIT_LIST_HEAD(&iocb->ki_run_list);
 		/* we must queue the next iteration ourselves, if it
 		 * has already been kicked */
 		if (kiocbIsKicked(iocb)) {

--Boundary-00=_/p21LWMN5hJm4wa--
