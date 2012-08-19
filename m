Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2HSHD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:03:58 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:17835
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab2HSHDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 03:03:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="153342473"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] sound/atmel/ac97c.c: fix error return code
Date: Sun, 19 Aug 2012 09:02:57 +0200
Message-Id: <1345359780-18647-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

In the first case, the second test of whether retval is negative is
redundant.  It is dropped and the previous and subsequent tests are
combined.

In the second case, add an initialization of retval on failure of ioremap.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/atmel/ac97c.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index 3c8d3ba..9052aff 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -278,14 +278,9 @@ static int atmel_ac97c_capture_hw_params(struct snd_pcm_substream *substream,
 	if (retval < 0)
 		return retval;
 	/* snd_pcm_lib_malloc_pages returns 1 if buffer is changed. */
-	if (cpu_is_at32ap7000()) {
-		if (retval < 0)
-			return retval;
-		/* snd_pcm_lib_malloc_pages returns 1 if buffer is changed. */
-		if (retval == 1)
-			if (test_and_clear_bit(DMA_RX_READY, &chip->flags))
-				dw_dma_cyclic_free(chip->dma.rx_chan);
-	}
+	if (cpu_is_at32ap7000() && retval == 1)
+		if (test_and_clear_bit(DMA_RX_READY, &chip->flags))
+			dw_dma_cyclic_free(chip->dma.rx_chan);
 
 	/* Set restrictions to params. */
 	mutex_lock(&opened_mutex);
@@ -980,6 +975,7 @@ static int __devinit atmel_ac97c_probe(struct platform_device *pdev)
 
 	if (!chip->regs) {
 		dev_dbg(&pdev->dev, "could not remap register memory\n");
+		retval = -ENOMEM;
 		goto err_ioremap;
 	}
 

