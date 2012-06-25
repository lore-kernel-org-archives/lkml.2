Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2FYPP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:15:56 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60552 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575Ab2FYPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:15:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAGl/6E9bdWOb/2dsb2JhbABEtiyBB4JGUoE+E4gPuEqLNIYBA5UukAGCYYFd
X-IronPort-AV: E=Sophos;i="4.77,472,1336341600"; 
   d="scan'208";a="932086506"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Staging: ipack/devices/ipoctal: fix oops when accessing "buffer"
Date: Mon, 25 Jun 2012 17:15:44 +0200
Message-Id: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer[][] field was replaced by tty_port->xmit_buf field but there was
some places that "buffer" was still accessed, giving a kernel oops because
it was uninitialized.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 2921467..7fe1c93 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -46,7 +46,6 @@ struct ipoctal {
 	struct scc2698_channel		*chan_regs;
 	struct scc2698_block		*block_regs;
 	struct ipoctal_stats		chan_stats[NR_CHANNELS];
-	char				*buffer[NR_CHANNELS];
 	unsigned int			nb_bytes[NR_CHANNELS];
 	unsigned int			count_wr[NR_CHANNELS];
 	wait_queue_head_t		queue[NR_CHANNELS];
@@ -305,7 +304,7 @@ static int ipoctal_irq_handler(void *arg)
 				continue;
 			}
 			spin_lock(&ipoctal->lock[channel]);
-			value = ipoctal->buffer[channel][*pointer_write];
+			value = ipoctal->tty_port[channel].xmit_buf[*pointer_write];
 			ipoctal_write_io_reg(ipoctal,
 					     &ipoctal->chan_regs[channel].u.w.thr,
 					     value);
-- 
1.7.10

