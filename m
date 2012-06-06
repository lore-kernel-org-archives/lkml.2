Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2FFWqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:46:55 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38378 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FFWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:46:54 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 22:46:52 +0000
Message-ID: <CA+Z7AcYDcZiAxPr+Au8PKoNzoT6G_0F0dAn75nb9ktXp9kBf9g@mail.gmail.com>
Subject: [PATCH] change lock model in aio_put_req
From: mihailov ivan <mihailov.iaa@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why used spin_lock/unlock_irq instead of
spin_lock_irqsave/spin_unlock_irqrestore?
__aio_put_req it's interrupt safe call but why aio_put_req not?

simply if I'll do some kind of this code:

spin_lock_irqsave(&lock, flags);
--some functions 1--
aio_put_req(aiocb);
--some functions 2--
spin_unlock_irqrestore(&lock, flags);

On aio_put_req we unlock all interrupts...
And after that 'some functions 2' unsafe now.

Or this call work as designed?
If not I have smally patchset for that.


--- /usr/src/linux/fs/aio.c	2011-07-22 02:17:23.000000000 +0000
+++ aio.c	2012-06-07 01:12:33.737299121 +0000
@@ -581,10 +581,10 @@
 int aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
-	int ret;
-	spin_lock_irq(&ctx->ctx_lock);
+	int ret, flags;
+	spin_lock_irqsave(&ctx->ctx_lock, flags);
 	ret = __aio_put_req(ctx, req);
-	spin_unlock_irq(&ctx->ctx_lock);
+	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(aio_put_req);
