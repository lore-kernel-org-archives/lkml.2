Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0DAPyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:54:17 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58252 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab0DAPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=EPngeALdAxsD3XIYMh3rGzE9CAgWC9AN+8lhx5COQWtiL/JBzgrtrg38CWTTZg7zZV
         f6TtRs6wn0L4A7NG3gEthY34WIjdA0F8XLgQ7c6HqWVeDWyadQ1Q2wWM8qL9bWfbNets
         xUsPoXvC3LV4d4eRJwaLNKhwUeSfmxdFI/4YY=
Date: Thu, 1 Apr 2010 18:54:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cciss: unlock on error path
Message-ID: <20100401155404.GD5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mike Miller <mike.miller@hp.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
	Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We take the spin_lock again in fail_all_cmds() so we need to unlock
here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This was found by a static checker and I don't have the hardware myself.
Please review carefully.

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9e3af30..eb5ff05 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3341,6 +3341,7 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 					printk(KERN_WARNING
 					       "cciss: controller cciss%d failed, stopping.\n",
 					       h->ctlr);
+					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 					fail_all_cmds(h->ctlr);
 					return IRQ_HANDLED;
 				}
