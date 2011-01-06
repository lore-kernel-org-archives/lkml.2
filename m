Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1AFOFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:05:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42050 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1AFOFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:05:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CNH2CGgTByenjz0lyb7YqCjPxhQ55hhTP3R7PcVMShxmU59Yd2RaYGvQVRWpl6Kb1N
         +ktYAmMdadGUUdpKC6ShhftiQzwvwnKP8DXBZT8l9iCZR4cKNn59lfP8qiVCNy9AUEo4
         yD5TIUTF02C/aqG7jAyZDB+CvbMZES18MQxDY=
Date: Thu, 6 Jan 2011 17:05:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, Daniel Mack <daniel@caiaq.de>,
        leiwen@marvell.com, haojian.zhuang@marvell.com,
        David.Woodhouse@intel.com, eric.y.miao@gmail.com,
        Artem.Bityutskiy@nokia.com
Subject: [patch v2] mtd: pxa3xx_nand: NULL dereference in pxa3xx_nand_probe
Message-ID: <20110106140536.GB1717@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Sven Neumann <s.neumann@raumfeld.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
	Daniel Mack <daniel@caiaq.de>, leiwen@marvell.com,
	haojian.zhuang@marvell.com, David.Woodhouse@intel.com,
	eric.y.miao@gmail.com, Artem.Bityutskiy@nokia.com
References: <1294227801.3996.62.camel@sven>
 <20110106124525.GA1717@bicker>
 <1294321502.2218.5.camel@sven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294321502.2218.5.camel@sven>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"info->cmdset" gets dereferenced in __readid() so it needs to be
initialized earlier in the function.  This bug was introduced in 
18c81b1828f8 "mtd: pxa3xx_nand: remove the flash info in driver
structure".

Cc: stable@kernel.org [2.6.37+]
Reported-and-tested-by: Sven Neumann <s.neumann@raumfeld.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2:  changed the commit text.  added stable@kernel.org and a reported-by tag.

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 17f8518..ea2c288 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -885,6 +885,7 @@ static int pxa3xx_nand_detect_config(struct pxa3xx_nand_info *info)
 	/* set info fields needed to __readid */
 	info->read_id_bytes = (info->page_size == 2048) ? 4 : 2;
 	info->reg_ndcr = ndcr;
+	info->cmdset = &default_cmdset;
 
 	if (__readid(info, &id))
 		return -ENODEV;
@@ -915,7 +916,6 @@ static int pxa3xx_nand_detect_config(struct pxa3xx_nand_info *info)
 
 	info->ndtr0cs0 = nand_readl(info, NDTR0CS0);
 	info->ndtr1cs0 = nand_readl(info, NDTR1CS0);
-	info->cmdset = &default_cmdset;
 
 	return 0;
 }

