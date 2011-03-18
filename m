Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1CRD5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:57:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab1CRD53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:57:29 -0400
Message-ID: <4D82D892.5000908@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:59:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/36] md,rcu: convert call_rcu(free_conf) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:56:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:56:05,
	Serialize complete at 2011-03-18 11:56:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback free_conf() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_conf).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/md/linear.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 0ed7f6b..a5b9e53 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -231,12 +231,6 @@ static int linear_run (mddev_t *mddev)
 	return 0;
 }
 
-static void free_conf(struct rcu_head *head)
-{
-	linear_conf_t *conf = container_of(head, linear_conf_t, rcu);
-	kfree(conf);
-}
-
 static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	/* Adding a drive to a linear array allows the array to grow.
@@ -265,7 +259,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
-	call_rcu(&oldconf->rcu, free_conf);
+	kfree_rcu(oldconf, rcu);
 	return 0;
 }
 
-- 
1.7.4
