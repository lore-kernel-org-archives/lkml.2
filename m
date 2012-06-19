Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2FSIhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:37:22 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36438 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2FSIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:37:19 -0400
Message-ID: <4FE03A37.4040805@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:37:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 09/10] zcache: introduce get_zcache_client
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061908-2674-0000-0000-000004F27D27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce get_zcache_client to remove the common code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |   46 +++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 2ee55c4..542f181 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -70,6 +70,17 @@ static inline uint16_t get_client_id_from_client(struct zcache_client *cli)
 	return cli - &zcache_clients[0];
 }

+static struct zcache_client *get_zcache_client(uint16_t cli_id)
+{
+	if (cli_id == LOCAL_CLIENT)
+		return &zcache_host;
+
+	if ((unsigned int)cli_id < MAX_CLIENTS)
+		return &zcache_clients[cli_id];
+
+	return NULL;
+}
+
 static inline bool is_local_client(struct zcache_client *cli)
 {
 	return cli == &zcache_host;
@@ -929,15 +940,9 @@ static struct tmem_pool *zcache_get_pool_by_id(uint16_t cli_id, uint16_t poolid)
 	struct tmem_pool *pool = NULL;
 	struct zcache_client *cli = NULL;

-	if (cli_id == LOCAL_CLIENT)
-		cli = &zcache_host;
-	else {
-		if (cli_id >= MAX_CLIENTS)
-			goto out;
-		cli = &zcache_clients[cli_id];
-		if (cli == NULL)
-			goto out;
-	}
+	cli = get_zcache_client(cli_id);
+	if (!cli)
+		goto out;

 	atomic_inc(&cli->refcount);
 	if (poolid < MAX_POOLS_PER_CLIENT) {
@@ -962,13 +967,11 @@ static void zcache_put_pool(struct tmem_pool *pool)

 int zcache_new_client(uint16_t cli_id)
 {
-	struct zcache_client *cli = NULL;
+	struct zcache_client *cli;
 	int ret = -1;

-	if (cli_id == LOCAL_CLIENT)
-		cli = &zcache_host;
-	else if ((unsigned int)cli_id < MAX_CLIENTS)
-		cli = &zcache_clients[cli_id];
+	cli = get_zcache_client(cli_id);
+
 	if (cli == NULL)
 		goto out;
 	if (cli->allocated)
@@ -1644,17 +1647,16 @@ static int zcache_flush_object(int cli_id, int pool_id,
 static int zcache_destroy_pool(int cli_id, int pool_id)
 {
 	struct tmem_pool *pool = NULL;
-	struct zcache_client *cli = NULL;
+	struct zcache_client *cli;
 	int ret = -1;

 	if (pool_id < 0)
 		goto out;
-	if (cli_id == LOCAL_CLIENT)
-		cli = &zcache_host;
-	else if ((unsigned int)cli_id < MAX_CLIENTS)
-		cli = &zcache_clients[cli_id];
+
+	cli = get_zcache_client(cli_id);
 	if (cli == NULL)
 		goto out;
+
 	atomic_inc(&cli->refcount);
 	pool = cli->tmem_pools[pool_id];
 	if (pool == NULL)
@@ -1680,12 +1682,10 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
 	struct tmem_pool *pool;
 	struct zcache_client *cli = NULL;

-	if (cli_id == LOCAL_CLIENT)
-		cli = &zcache_host;
-	else if ((unsigned int)cli_id < MAX_CLIENTS)
-		cli = &zcache_clients[cli_id];
+	cli = get_zcache_client(cli_id);
 	if (cli == NULL)
 		goto out;
+
 	atomic_inc(&cli->refcount);
 	pool = kmalloc(sizeof(struct tmem_pool), GFP_ATOMIC);
 	if (pool == NULL) {
-- 
1.7.7.6

