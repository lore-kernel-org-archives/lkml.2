Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2HGDqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:46:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59836 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964807Ab2HGDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:54 -0400
Message-Id: <20120807032801.221289546@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 35/70] dm thin: fix memory leak in process_prepared_mapping error paths
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 905386f82d08f66726912f303f3e6605248c60a3 upstream.

Fix memory leak in process_prepared_mapping by always freeing
the dm_thin_new_mapping structs from the mapping_pool mempool on
the error paths.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-thin.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 93e3e54..423df92 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -870,7 +870,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 
 	if (m->err) {
 		cell_error(m->cell);
-		return;
+		goto out;
 	}
 
 	/*
@@ -882,7 +882,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	if (r) {
 		DMERR("dm_thin_insert_block() failed");
 		cell_error(m->cell);
-		return;
+		goto out;
 	}
 
 	/*
@@ -897,6 +897,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	} else
 		cell_defer(tc, m->cell, m->data_block);
 
+out:
 	list_del(&m->list);
 	mempool_free(m, tc->pool->mapping_pool);
 }


