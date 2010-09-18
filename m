Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0IRTPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:48 -0400
Received: from kroah.org ([198.145.64.141]:43645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab0IRTPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:44 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:04 2010
Message-Id: <20100918191304.282958309@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [081/129] mmc: fix the use of kunmap_atomic() in tmio_mmc.h
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 5600efb1bc2745d93ae0bc08130117a84f2b9d69 upstream.

kunmap_atomic() takes the cookie, returned by the kmap_atomic() as its
argument and not the page address, used as an argument to kmap_atomic().
This patch fixes the compile error:

In file included from drivers/mmc/host/tmio_mmc.c:37:
drivers/mmc/host/tmio_mmc.h: In function 'tmio_mmc_kunmap_atomic':
drivers/mmc/host/tmio_mmc.h:192: error: negative width in bit-field '<anonymous>'

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Tested-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/tmio_mmc.c |    7 ++++---
 drivers/mmc/host/tmio_mmc.h |    8 +++-----
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -164,6 +164,7 @@ tmio_mmc_start_command(struct tmio_mmc_h
 static void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 {
 	struct mmc_data *data = host->data;
+	void *sg_virt;
 	unsigned short *buf;
 	unsigned int count;
 	unsigned long flags;
@@ -173,8 +174,8 @@ static void tmio_mmc_pio_irq(struct tmio
 		return;
 	}
 
-	buf = (unsigned short *)(tmio_mmc_kmap_atomic(host, &flags) +
-	      host->sg_off);
+	sg_virt = tmio_mmc_kmap_atomic(host->sg_ptr, &flags);
+	buf = (unsigned short *)(sg_virt + host->sg_off);
 
 	count = host->sg_ptr->length - host->sg_off;
 	if (count > data->blksz)
@@ -191,7 +192,7 @@ static void tmio_mmc_pio_irq(struct tmio
 
 	host->sg_off += count;
 
-	tmio_mmc_kunmap_atomic(host, &flags);
+	tmio_mmc_kunmap_atomic(sg_virt, &flags);
 
 	if (host->sg_off == host->sg_ptr->length)
 		tmio_mmc_next_sg(host);
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -174,19 +174,17 @@ static inline int tmio_mmc_next_sg(struc
 	return --host->sg_len;
 }
 
-static inline char *tmio_mmc_kmap_atomic(struct tmio_mmc_host *host,
+static inline char *tmio_mmc_kmap_atomic(struct scatterlist *sg,
 	unsigned long *flags)
 {
-	struct scatterlist *sg = host->sg_ptr;
-
 	local_irq_save(*flags);
 	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
 }
 
-static inline void tmio_mmc_kunmap_atomic(struct tmio_mmc_host *host,
+static inline void tmio_mmc_kunmap_atomic(void *virt,
 	unsigned long *flags)
 {
-	kunmap_atomic(sg_page(host->sg_ptr), KM_BIO_SRC_IRQ);
+	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
 	local_irq_restore(*flags);
 }
 


