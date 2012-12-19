Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2LSL7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:59:16 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46142 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2LSL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:59:04 -0500
MIME-Version: 1.0
Date: Wed, 19 Dec 2012 19:59:03 +0800
Message-ID: <CAJd=RBCXiBC2ctrESGPekrPO067tifg7=tDOx5xQhJESzXK-2w@mail.gmail.com>
Subject: Re: [PATCH 25/26] aio: use xchg() instead of completion_lock
From: Hillf Danton <dhillf@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>@@ -686,9 +685,10 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
> 	 * ctx->ctx_lock to prevent other code from messing with the tail
> 	 * pointer since we might be called from irq context.
> 	 */

Well the comment is stale.

Hillf
>-	spin_lock_irqsave(&ctx->completion_lock, flags);
>+	local_irq_save(flags);
>+	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
>+		cpu_relax();
