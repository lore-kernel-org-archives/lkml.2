Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab2BJWnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:43:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731Ab2BJWn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:27 -0500
MIME-Version: 1.0
Message-Id: <20120210222952.450793714@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch 83/86] zcache: fix deadlock condition
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Magenheimer <dan.magenheimer@oracle.com>

commit 9256a4789be3dae37d00924c03546ba7958ea5a3 upstream.

I discovered this deadlock condition awhile ago working on RAMster
but it affects zcache as well.  The list spinlock must be
locked prior to the page spinlock and released after.  As
a result, the page copy must also be done while the locks are held.

Applies to 3.2.  Konrad, please push (via GregKH?)...
this is definitely a bug fix so need not be pushed during
a -rc0 window.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zcache/zcache-main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -358,8 +358,8 @@ static struct zbud_hdr *zbud_create(uint
 	if (unlikely(zbpg == NULL))
 		goto out;
 	/* ok, have a page, now compress the data before taking locks */
-	spin_lock(&zbpg->lock);
 	spin_lock(&zbud_budlists_spinlock);
+	spin_lock(&zbpg->lock);
 	list_add_tail(&zbpg->bud_list, &zbud_unbuddied[nchunks].list);
 	zbud_unbuddied[nchunks].count++;
 	zh = &zbpg->buddy[0];
@@ -389,12 +389,11 @@ init_zh:
 	zh->oid = *oid;
 	zh->pool_id = pool_id;
 	zh->client_id = client_id;
-	/* can wait to copy the data until the list locks are dropped */
-	spin_unlock(&zbud_budlists_spinlock);
-
 	to = zbud_data(zh, size);
 	memcpy(to, cdata, size);
 	spin_unlock(&zbpg->lock);
+	spin_unlock(&zbud_budlists_spinlock);
+
 	zbud_cumul_chunk_counts[nchunks]++;
 	atomic_inc(&zcache_zbud_curr_zpages);
 	zcache_zbud_cumul_zpages++;


