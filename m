Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1DLOhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:36 -0400
Received: from kroah.org ([198.145.64.141]:57358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab1DLOhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:48 2011
Message-Id: <20110412143548.671345022@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:33:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [007/105] cciss: fix lost command issue
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -222,6 +222,7 @@ static void SA5_submit_command( ctlr_inf
 			h->ctlr, c->busaddr);
 #endif /* CCISS_DEBUG */
          writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
 	 h->commands_outstanding++;
 	 if ( h->commands_outstanding > h->max_outstanding)
 		h->max_outstanding = h->commands_outstanding;


