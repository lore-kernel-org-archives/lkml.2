Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030256Ab2HGX1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:27:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab2HGWbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 087/122] dm thin: fix memory leak in process_prepared_mapping error paths
Date: Tue,  7 Aug 2012 15:26:15 -0700
Message-Id: <20120807221957.012470905@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 905386f82d08f66726912f303f3e6605248c60a3 upstream.

Fix memory leak in process_prepared_mapping by always freeing
the dm_thin_new_mapping structs from the mapping_pool mempool on
the error paths.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -859,7 +859,7 @@ static void process_prepared_mapping(str
 
 	if (m->err) {
 		cell_error(m->cell);
-		return;
+		goto out;
 	}
 
 	/*
@@ -871,7 +871,7 @@ static void process_prepared_mapping(str
 	if (r) {
 		DMERR("dm_thin_insert_block() failed");
 		cell_error(m->cell);
-		return;
+		goto out;
 	}
 
 	/*
@@ -886,6 +886,7 @@ static void process_prepared_mapping(str
 	} else
 		cell_defer(tc, m->cell, m->data_block);
 
+out:
 	list_del(&m->list);
 	mempool_free(m, tc->pool->mapping_pool);
 }


