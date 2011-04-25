Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab1DYUoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:05 -0400
Received: from 1wt.eu ([62.212.114.60]:34330 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1DYUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:49 -0400
Message-Id: <20110425200238.001353480@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 115/173] cciss: fix lost command issue
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/block/cciss.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -165,6 +165,7 @@ static void SA5_submit_command( ctlr_inf
 	 printk("Sending %x - down to controller\n", c->busaddr );
 #endif /* CCISS_DEBUG */ 
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;


