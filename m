Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1CWTdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:33:44 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:45960 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1CWTdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:33:42 -0400
Date: Wed, 23 Mar 2011 14:33:40 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, bud.brown@redhat.com,
        mike.bacco@hp.com, Tom Coughlan <coughlan@redhat.com>,
        alan.ross@hp.com
Subject: [PATCH 1/1] cciss: fix lost command issue
Message-ID: <20110323193340.GB18722@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 of 1

cciss: fix lost command problem

From: Bud Brown <bud.brown@redhat.com>

Under certain workloads a command may seem to get lost. IOW, the Smart Array
thinks all commands have been completed but we still have commands in our
completion queue. This may lead to system instability, filesystems going
read-only, or even panics depending on the affected filesystem. We add an
extra read to force the write to complete.

Testing shows this extra read avoids the problem.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff -urNp linux-2.6/drivers/block/cciss.h linux-2.6-03212011/drivers/block/cciss.h
--- linux-2.6/drivers/block/cciss.h	2011-03-21 15:41:23.100192400 -0500
+++ linux-2.6-03212011/drivers/block/cciss.h	2011-03-21 15:39:20.472192814 -0500
@@ -222,6 +222,7 @@ static void SA5_submit_command( ctlr_inf
 			h->ctlr, c->busaddr);
 #endif /* CCISS_DEBUG */
 	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	h->commands_outstanding++;
 	if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;
