Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457Ab2KZRJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:09:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab2KZRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 158/270] ASoC: fsi: don't reschedule DMA from an atomic context
Date: Mon, 26 Nov 2012 14:57:28 -0200
Message-Id: <1353949160-26803-159-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 57451e437796548d658d03c2c4aab659eafcd799 upstream.

shdma doesn't support transfer re-scheduling or triggering from callbacks
or from atomic context. The fsi driver issues DMA transfers from a tasklet
context, which is a bug. To fix it convert tasklet to a work.

Reported-by: Do Q.Thang <dq-thang@jinso.co.jp>
Tested-by: Do Q.Thang <dq-thang@jinso.co.jp>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/sh/fsi.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 2ef9853..e96c395 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -20,6 +20,7 @@
 #include <linux/sh_dma.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
 #include <sound/soc.h>
 #include <sound/sh_fsi.h>
 
@@ -223,7 +224,7 @@ struct fsi_stream {
 	 */
 	struct dma_chan		*chan;
 	struct sh_dmae_slave	slave; /* see fsi_handler_init() */
-	struct tasklet_struct	tasklet;
+	struct work_struct	work;
 	dma_addr_t		dma;
 };
 
@@ -1085,9 +1086,9 @@ static void fsi_dma_complete(void *data)
 	snd_pcm_period_elapsed(io->substream);
 }
 
-static void fsi_dma_do_tasklet(unsigned long data)
+static void fsi_dma_do_work(struct work_struct *work)
 {
-	struct fsi_stream *io = (struct fsi_stream *)data;
+	struct fsi_stream *io = container_of(work, struct fsi_stream, work);
 	struct fsi_priv *fsi = fsi_stream_to_priv(io);
 	struct dma_chan *chan;
 	struct snd_soc_dai *dai;
@@ -1140,7 +1141,7 @@ static void fsi_dma_do_tasklet(unsigned long data)
 	 * FIXME
 	 *
 	 * In DMAEngine case, codec and FSI cannot be started simultaneously
-	 * since FSI is using tasklet.
+	 * since FSI is using the scheduler work queue.
 	 * Therefore, in capture case, probably FSI FIFO will have got
 	 * overflow error in this point.
 	 * in that case, DMA cannot start transfer until error was cleared.
@@ -1164,7 +1165,7 @@ static bool fsi_dma_filter(struct dma_chan *chan, void *param)
 
 static int fsi_dma_transfer(struct fsi_priv *fsi, struct fsi_stream *io)
 {
-	tasklet_schedule(&io->tasklet);
+	schedule_work(&io->work);
 
 	return 0;
 }
@@ -1195,14 +1196,14 @@ static int fsi_dma_probe(struct fsi_priv *fsi, struct fsi_stream *io)
 	if (!io->chan)
 		return -EIO;
 
-	tasklet_init(&io->tasklet, fsi_dma_do_tasklet, (unsigned long)io);
+	INIT_WORK(&io->work, fsi_dma_do_work);
 
 	return 0;
 }
 
 static int fsi_dma_remove(struct fsi_priv *fsi, struct fsi_stream *io)
 {
-	tasklet_kill(&io->tasklet);
+	cancel_work_sync(&io->work);
 
 	fsi_stream_stop(fsi, io);
 
-- 
1.7.9.5

