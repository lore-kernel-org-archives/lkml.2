Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab2JAXkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:40:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35020 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2JAW7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:48 -0400
Message-Id: <20121001225159.394708465@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Louis Rilling <louis.rilling@kerlabs.com>,
        Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 042/180] block: Fix io_context leak after clone with CLONE_IO
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Rilling <louis.rilling@kerlabs.com>

commit 61cc74fbb87af6aa551a06a370590c9bc07e29d9 upstream

With CLONE_IO, copy_io() increments both ioc->refcount and ioc->nr_tasks.
However exit_io_context() only decrements ioc->refcount if ioc->nr_tasks
reaches 0.

Always call put_io_context() in exit_io_context().

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 block/blk-ioc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index d4ed600..dcd0412 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -80,8 +80,8 @@ void exit_io_context(void)
 			ioc->aic->exit(ioc->aic);
 		cfq_exit(ioc);
 
-		put_io_context(ioc);
 	}
+	put_io_context(ioc);
 }
 
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
-- 
1.7.2.1.45.g54fbc



