Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2JSCwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:52:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:52660 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189Ab2JSCtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Do Q.Thang" <dq-thang@jinso.co.jp>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 71/76] ASoC: fsi: dont reschedule DMA from an atomic context
Date: Thu, 18 Oct 2012 19:47:35 -0700
Message-Id: <20121019024401.545421391@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/fsi.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

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
 	struct snd_soc_dai *dai;
 	struct dma_async_tx_descriptor *desc;
@@ -1129,7 +1130,7 @@ static void fsi_dma_do_tasklet(unsigned
 	 * FIXME
 	 *
 	 * In DMAEngine case, codec and FSI cannot be started simultaneously
-	 * since FSI is using tasklet.
+	 * since FSI is using the scheduler work queue.
 	 * Therefore, in capture case, probably FSI FIFO will have got
 	 * overflow error in this point.
 	 * in that case, DMA cannot start transfer until error was cleared.
@@ -1153,7 +1154,7 @@ static bool fsi_dma_filter(struct dma_ch
 
 static int fsi_dma_transfer(struct fsi_priv *fsi, struct fsi_stream *io)
 {
-	tasklet_schedule(&io->tasklet);
+	schedule_work(&io->work);
 
 	return 0;
 }
@@ -1195,14 +1196,14 @@ static int fsi_dma_probe(struct fsi_priv
 		return fsi_stream_probe(fsi, dev);
 	}
 
-	tasklet_init(&io->tasklet, fsi_dma_do_tasklet, (unsigned long)io);
+	INIT_WORK(&io->work, fsi_dma_do_work);
 
 	return 0;
 }
 
 static int fsi_dma_remove(struct fsi_priv *fsi, struct fsi_stream *io)
 {
-	tasklet_kill(&io->tasklet);
+	cancel_work_sync(&io->work);
 
 	fsi_stream_stop(fsi, io);
 


