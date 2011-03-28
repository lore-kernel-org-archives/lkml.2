Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1C1WYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:24:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35755 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab1C1WYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:24:22 -0400
Date: Tue, 29 Mar 2011 09:24:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] memstick: make enable_dma less generic in r592
Message-Id: <20110329092416.a4b1d98f.sfr@canb.auug.org.au>
In-Reply-To: <20110328144458.efedbefc.sfr@canb.auug.org.au>
References: <20110328144458.efedbefc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 14:44:58 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as different kind of symbol
> arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here
> 
> Caused by commit 926341250102 ("memstick: add driver for Ricoh R5C592
> card reader").
> 
> enable_dma() is also defined in a few other architectures including x86
> (presumably asm/dma.h does not get included there).
> 
> I just reverted that commit for today.

I will, instead, apply this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Mar 2011 09:12:53 +1100
Subject: [PATCH] memstick: make enable_dma less generic in r592

Fixes this build error:

drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as different kind of symbol
arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/r592.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 767406c..ecf3d7d 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -23,7 +23,7 @@
 #include <linux/swab.h>
 #include "r592.h"
 
-static int enable_dma = 1;
+static int r592_enable_dma = 1;
 static int debug;
 
 static const char *tpc_names[] = {
@@ -267,7 +267,7 @@ static void r592_stop_dma(struct r592_device *dev, int error)
 /* Test if hardware supports DMA */
 static void r592_check_dma(struct r592_device *dev)
 {
-	dev->dma_capable = enable_dma &&
+	dev->dma_capable = r592_enable_dma &&
 		(r592_read_reg(dev, R592_FIFO_DMA_SETTINGS) &
 			R592_FIFO_DMA_SETTINGS_CAP);
 }
@@ -898,7 +898,7 @@ static void __exit r592_module_exit(void)
 module_init(r592_module_init);
 module_exit(r592_module_exit);
 
-module_param(enable_dma, bool, S_IRUGO);
+module_param_named(r592_enable_dma, enable_dma, bool, S_IRUGO);
 MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
 module_param(debug, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug level (0-3)");
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
