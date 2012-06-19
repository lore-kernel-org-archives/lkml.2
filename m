Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2FSIeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:34:14 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43104 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2FSIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:34:10 -0400
Message-ID: <4FE03949.4080308@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:33:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 02/10] zcache: fix refcount leak
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061822-1396-0000-0000-0000016A07FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zcache_get_pool_by_id, the refcount of zcache_host is not increased, but
it is always decreased in zcache_put_pool

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index d215fb4..32fe0ba 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -942,8 +942,9 @@ static struct tmem_pool *zcache_get_pool_by_id(uint16_t cli_id, uint16_t poolid)
 		cli = &zcache_clients[cli_id];
 		if (cli == NULL)
 			goto out;
-		atomic_inc(&cli->refcount);
 	}
+
+	atomic_inc(&cli->refcount);
 	if (poolid < MAX_POOLS_PER_CLIENT) {
 		pool = cli->tmem_pools[poolid];
 		if (pool != NULL)
-- 
1.7.7.6

