Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab0D2C6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 22:58:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59544 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab0D2C6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 22:58:40 -0400
Date: Thu, 29 Apr 2010 12:58:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: linux-next: manual merge of the mtd tree with Linus' tree
Message-Id: <20100429125839.9dedf349.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the mtd tree got a conflict in
drivers/mtd/mtdcore.c between commit
a33eb6b91034c95b9b08576f68be170f995b2c7d ("Move mtd_bdi_*mappable to
mtdcore.c") from Linus' tree and commit
b520e412faaaad35641aeedd6059179f9f1b393c ("mtd: Replace static array of
devices with an idr structure") from the mtd tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/mtdcore.c
index b177e75,70a7858..0000000
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@@ -19,39 -17,12 +19,40 @@@
  #include <linux/init.h>
  #include <linux/mtd/compatmac.h>
  #include <linux/proc_fs.h>
 +#include <linux/backing-dev.h>
+ #include <linux/idr.h>
  
  #include <linux/mtd/mtd.h>
 -#include "internal.h"
  
  #include "mtdcore.h"
 +/*
 + * backing device capabilities for non-mappable devices (such as NAND flash)
 + * - permits private mappings, copies are taken of the data
 + */
 +struct backing_dev_info mtd_bdi_unmappable = {
 +	.capabilities	= BDI_CAP_MAP_COPY,
 +};
 +
 +/*
 + * backing device capabilities for R/O mappable devices (such as ROM)
 + * - permits private mappings, copies are taken of the data
 + * - permits non-writable shared mappings
 + */
 +struct backing_dev_info mtd_bdi_ro_mappable = {
 +	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 +			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
 +};
 +
 +/*
 + * backing device capabilities for writable mappable devices (such as RAM)
 + * - permits private mappings, copies are taken of the data
 + * - permits non-writable shared mappings
 + */
 +struct backing_dev_info mtd_bdi_rw_mappable = {
 +	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 +			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
 +			   BDI_CAP_WRITE_MAP),
 +};
  
  static int mtd_cls_suspend(struct device *dev, pm_message_t state);
  static int mtd_cls_resume(struct device *dev);
