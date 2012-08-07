Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2HGXHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:07:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35146 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620Ab2HGWjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 066/109] dm thin: fix memory leak in process_prepared_mapping error paths
Date: Tue,  7 Aug 2012 15:35:25 -0700
Message-Id: <20120807222048.896079401@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -855,7 +855,7 @@ static void process_prepared_mapping(str
 
 	if (m->err) {
 		cell_error(m->cell);
-		return;
+		goto out;
 	}
 
 	/*
@@ -867,7 +867,7 @@ static void process_prepared_mapping(str
 	if (r) {
 		DMERR("dm_thin_insert_block() failed");
 		cell_error(m->cell);
-		return;
+		goto out;
 	}
 
 	/*
@@ -882,6 +882,7 @@ static void process_prepared_mapping(str
 	} else
 		cell_defer(tc, m->cell, m->data_block);
 
+out:
 	list_del(&m->list);
 	mempool_free(m, tc->pool->mapping_pool);
 }


