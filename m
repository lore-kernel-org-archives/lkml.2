Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab2AYWcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:32:54 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19868 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AYWcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:32:53 -0500
MIME-Version: 1.0
Message-ID: <356ccc29-31af-4274-b372-c8fd1a9b10cb@default>
Date: Wed, 25 Jan 2012 14:32:51 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH] zcache: fix deadlock condition
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F20830E.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered this deadlock condition awhile ago working on RAMster
but it affects zcache as well.  The list spinlock must be
locked prior to the page spinlock and released after.  As
a result, the page copy must also be done while the locks are held.

Applies to 3.2.  Konrad, please push (via GregKH?)...
this is definitely a bug fix so need not be pushed during
a -rc0 window.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 56c1f9c..5b9f74e 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -358,8 +358,8 @@ static struct zbud_hdr *zbud_create(uint16_t client_id, uint16_t pool_id,
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
