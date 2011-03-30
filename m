Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1C3VQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:16:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965253Ab1C3VJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238982"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: bud.brown@redhat.com, mike.miller@hp.com, jaxboe@fusionio.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [247/275] cciss: fix lost command issue
Message-Id: <20110330210813.BD7C23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Bud Brown <bud.brown@redhat.com>

commit 1ddd5049545e0aa1a0ed19bca4d9c9c3ce1ac8a2 upstream.

Under certain workloads a command may seem to get lost. IOW, the Smart Array
thinks all commands have been completed but we still have commands in our
completion queue. This may lead to system instability, filesystems going
read-only, or even panics depending on the affected filesystem. We add an
extra read to force the write to complete.

Testing shows this extra read avoids the problem.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/block/cciss.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/block/cciss.h
===================================================================
--- linux-2.6.35.y.orig/drivers/block/cciss.h	2011-03-29 22:50:13.312917773 -0700
+++ linux-2.6.35.y/drivers/block/cciss.h	2011-03-29 23:03:03.435212271 -0700
@@ -173,6 +173,7 @@
 	 printk("Sending %x - down to controller\n", c->busaddr );
 #endif /* CCISS_DEBUG */ 
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
