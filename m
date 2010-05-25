Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0EYJyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:54:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41616 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab0EYJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=DxJk69Sp6XgP+b45e/FsXiIaG/eo72Dp/UXOS78qAw7yTszxpZvlC2QgqX1qxqBJO9
         8zRg56eic02o+yRN6va9jo3LZrCwxr49H9/Xor6SctGq9VaOZ3FDFWbLOaY64B+WxufD
         sPX+F9dpgoQQsAMat+tLszE3oMUwlEoLA3Quo=
Date: Tue, 25 May 2010 11:53:48 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 1/2] dma/timb_dma: fixup error handling in
	td_alloc_init_desc()
Message-ID: <20100525095348.GI22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Richard =?iso-8859-1?Q?R=F6jfors?= <richard.rojfors@pelagicore.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code tried to kfree(td_desc->desc_list) when td_desc was
NULL so I re-arranged it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 0172fa3..3e101a0 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -390,7 +390,7 @@ static struct timb_dma_desc *td_alloc_init_desc(struct timb_dma_chan *td_chan)
 	td_desc->desc_list = kzalloc(td_desc->desc_list_len, GFP_KERNEL);
 	if (!td_desc->desc_list) {
 		dev_err(chan2dev(chan), "Failed to alloc descriptor\n");
-		goto err;
+		goto err_desc;
 	}
 
 	dma_async_tx_descriptor_init(&td_desc->txd, chan);
@@ -403,14 +403,16 @@ static struct timb_dma_desc *td_alloc_init_desc(struct timb_dma_chan *td_chan)
 	err = dma_mapping_error(chan2dmadev(chan), td_desc->txd.phys);
 	if (err) {
 		dev_err(chan2dev(chan), "DMA mapping error: %d\n", err);
-		goto err;
+		goto err_list;
 	}
 
 	return td_desc;
-err:
+
+err_list:
 	kfree(td_desc->desc_list);
+err_desc:
 	kfree(td_desc);
-
+err:
 	return NULL;
 
 }
