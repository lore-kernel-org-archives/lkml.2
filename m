Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1E0GAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:00:10 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:38934 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1E0GAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eqKEryHaN2zzcEoTMqv6Basb2YsdXeQKh+PHluFxih8wRKvsKv3Dodc3JjYUWe9v0C
         zfDewyDgfoBSzvIN1RfBIeDBi7+pFHIJjmafr3s85e9/LuukVUSyktg6PLb7Qnz873/8
         zH3o7xWMidiPPyJPAOO5P88+sm3U5GTHEVdeM=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Paul Clements <Paul.Clements@steeleye.com>
Subject: [PATCH 1/3] nbd: pass MSG_* flags to kernel_recvmsg()
Date: Fri, 27 May 2011 15:00:01 +0900
Message-Id: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike kernel_sendmsg(), kernel_recvmsg() requires passing flags explicitly
via last parameter instead of struct msghdr.msg_flags. Therefore calls to
sock_xmit(lo, 0, ..., MSG_WAITALL) have not been processed properly by tcp
layer wrt. the flag. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
---
 drivers/block/nbd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index e6fc716aca45..1df3bfe5225b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -192,7 +192,8 @@ static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
 			if (lo->xmit_timeout)
 				del_timer_sync(&ti);
 		} else
-			result = kernel_recvmsg(sock, &msg, &iov, 1, size, 0);
+			result = kernel_recvmsg(sock, &msg, &iov, 1, size,
+						msg.msg_flags);
 
 		if (signal_pending(current)) {
 			siginfo_t info;
-- 
1.7.5.2

