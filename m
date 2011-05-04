Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1EDPUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:20:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53715 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1EDPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:20:11 -0400
Date: Wed, 4 May 2011 11:20:08 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Per Forlin <per.forlin@linaro.org>
cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, linaro-dev@lists.linaro.org,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Ulf HANSSON <ulf.hansson@stericsson.com>
Subject: Re: [PATCH] sdio: optimized SDIO IRQ handling for single function
In-Reply-To: <BANLkTim_x28NyWzo-Ug3+ZprgeT=VFwEfQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1105041117170.24613@xanadu.home>
References: <1304453087-7365-1-git-send-email-per.forlin@linaro.org> <alpine.LFD.2.00.1105032339370.24613@xanadu.home> <BANLkTim_x28NyWzo-Ug3+ZprgeT=VFwEfQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Per Forlin wrote:

> On 4 May 2011 05:40, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Tue, 3 May 2011, Per Forlin wrote:
> >
> >> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
> >>
> >> If there is only 1 function registered, and IRQ:s are supported and
> >> currently enabled, call the callback handler directly
> >> without checking the CCCR registers.
> >>
> >> Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
> >> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> >
> > Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> >
> I am working o a patch version 2 after offline discussion with Ulf Hansson.
> Instead of adding this code here.
> Add sdio_single_func member in mmc_card. Set and reset this function
> in sdio_claim_irq and sdio_release_irq.
> process_sdio_pending_irqs would only check if sdio_single_func is !=
> null and call it.

Yes, that's what I was about to propose after thinking about it some 
more.

> This will result in a bigger patch overall but the new code in
> process_sdio_pending_irqs will be minimal.

Something like this (untested) ?

diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index b300161..4552727 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -32,6 +32,12 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 	int i, ret, count;
 	unsigned char pending;
 
+	if (card->sdio_single_irq) {
+		struct sdio_func *func = card->sdio_single_irq;
+		func->irq_handler(func);
+		return 1;
+	}
+
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
 	if (ret) {
 		printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
@@ -166,6 +172,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
 			host->sdio_irqs--;
 			return err;
 		}
+		return 1;
 	}
 
 	return 0;
@@ -183,7 +190,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
 		kthread_stop(host->sdio_irq_thread);
 	}
 
-	return 0;
+	return (host->sdio_irqs == 1);
 }
 
 /**
@@ -225,8 +232,12 @@ int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
 
 	func->irq_handler = handler;
 	ret = sdio_card_irq_get(func->card);
-	if (ret)
+	if (ret < 0) {
 		func->irq_handler = NULL;
+	} else if (ret == 1) {
+		card->sdio_single_irq = func;
+		ret = 0;
+	}
 
 	return ret;
 }
@@ -250,7 +261,17 @@ int sdio_release_irq(struct sdio_func *func)
 
 	if (func->irq_handler) {
 		func->irq_handler = NULL;
-		sdio_card_irq_put(func->card);
+		if (sdio_card_irq_put(func->card) == 1) {
+			int i;
+			for (i = 0, i < 7; i++) {
+				if (func->card->sdio_func[i].irq_handler) {
+					func->card->sdio_single_irq =
+						func->card->sdio_func[i];
+					break;
+				}
+			}
+		} else
+			func->card->sdio_single_irq = NULL;
 	}
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IENx, 0, &reg);
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index adb4888..fee3df3 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -145,6 +145,7 @@ struct mmc_card {
 	struct sdio_cccr	cccr;		/* common card info */
 	struct sdio_cis		cis;		/* common tuple info */
 	struct sdio_func	*sdio_func[SDIO_MAX_FUNCS]; /* SDIO functions (devices) */
+	struct sdio_func	*sdio_single_irq;		/* SDIO function when only one IRQ active */
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */


Nicolas
