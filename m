Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2ACWex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:34:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab2ACWes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:34:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:31 2012
Message-Id: <20120103223031.793601522@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, majianpeng <majianpeng@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [06/67] cfq-iosched: free cic_index if blkio_alloc_blkg_stats fails
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 2984ff38ccf6cbc02a7a996a36c7d6f69f3c6146 upstream.

If we fail allocating the blkpg stats, we free cfqd and cfgq.
But we need to free the IDA cfqd->cic_index as well.

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4015,6 +4015,11 @@ static void *cfq_init_queue(struct reque
 
 	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
 		kfree(cfqg);
+
+		spin_lock(&cic_index_lock);
+		ida_remove(&cic_index_ida, cfqd->cic_index);
+		spin_unlock(&cic_index_lock);
+
 		kfree(cfqd);
 		return NULL;
 	}


