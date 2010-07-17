Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab0GQPUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 11:20:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51810 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760027Ab0GQPUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 11:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LMs6KRPes3Lc1iQTo+i+V5nI0XgCCTrao/YFKEt+h/LGUxGpsDF6H36YAQO/h7mlaf
         ldVuML2QqLHw7ug79pmUCz8iGvXOtsmwVllcnYskZvoQH08tMzLMDjuIO8gx1XbAimQ4
         oxcowEiTdLK9AnC5QdaEOb+tobHbQssiAwBEE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Anatolij Gustschin <agust@denx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] dma: dmatest: fix potential sign bug
Date: Sat, 17 Jul 2010 19:19:48 +0400
Message-Id: <1279379988-15232-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'cnt' is unsigned, so this code may become wrong in future as
dmatest_add_threads() can return error code:

	cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
	thread_count += cnt > 0 ? cnt : 0;
		        ^^^^^^^

Now it can return only -EINVAL if and only if second argument of
dmatest_add_threads() is not one of DMA_MEMCPY, DMA_XOR, DMA_PQ.
So, now it is not wrong but may become wrong in future.


The semantic patch that finds this problem (many false-positive results):
(http://coccinelle.lip6.fr/)

// <smpl>
@ r1 @
identifier f;
@@
int f(...) { ... }

@@
identifier r1.f;
type T;
unsigned T x;
@@

*x = f(...)
 ...
*x > 0

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/dma/dmatest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 68d58c4..5589358 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -540,7 +540,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
 	struct dmatest_chan	*dtc;
 	struct dma_device	*dma_dev = chan->device;
 	unsigned int		thread_count = 0;
-	unsigned int		cnt;
+	int cnt;
 
 	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_KERNEL);
 	if (!dtc) {
-- 
1.7.0.4

