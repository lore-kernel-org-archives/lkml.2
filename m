Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab0J1OGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:06:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60394 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab0J1OGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=sQOI/LThKbht2iRMaTfVGljBGOo95kT0FgbX+PeMZmac9v54LyVTpL0yhvVqf3od3T
         SbLWwSIazSmVcLMFdYMc1CkSGYqZRZHqpFo9S1NOuJuYvlN03qODQa1596bcw/5Gg/ZH
         JB34OFJFBgxaX0Qof0ck614ILqqKUB3JZ056c=
Date: Thu, 28 Oct 2010 16:06:21 +0200
From: Dan Carpenter <error27@gmail.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Li Yang <leoli@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rapidio: use resource_size()
Message-ID: <20101028140621.GE6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alexandre Bounine <alexandre.bounine@idt.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Li Yang <leoli@freescale.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size calculation is done incorrectly here because it should include
both the start and end (end - start + 1).  It's easiest to just use
resource_size() which does the right thing.

I was worried there was something non-standard going on because the
printk() subtracts "end - 1", but the rest of the file uses the normal
resource size calculations.  This function is only called from
fsl_rio_setup() in arch/powerpc/sysdev/fsl_rio.c and the calculation
there is also:
	port->iores.start = law_start;
	port->iores.end = law_start + law_size - 1;
So I think this is the correct fix.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested only.

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 68cf0c9..7b5080c 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1159,11 +1159,11 @@ int __devinit rio_init_mports(void)
 
 	list_for_each_entry(port, &rio_mports, node) {
 		if (!request_mem_region(port->iores.start,
-					port->iores.end - port->iores.start,
+					resource_size(&port->iores),
 					port->name)) {
 			printk(KERN_ERR
 			       "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
-			       (u64)port->iores.start, (u64)port->iores.end - 1);
+			       (u64)port->iores.start, (u64)port->iores.end);
 			rc = -ENOMEM;
 			goto out;
 		}
