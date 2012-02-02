Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2BBGv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 01:51:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2BBGvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 01:51:25 -0500
Message-ID: <4F2A3305.9050009@cn.fujitsu.com>
Date: Thu, 02 Feb 2012 14:53:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] blkcg: make CONFIG_BLK_CGROUP bool
References: <1328129429-11823-1-git-send-email-tj@kernel.org> <1328129429-11823-2-git-send-email-tj@kernel.org>
In-Reply-To: <1328129429-11823-2-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-02 14:49:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-02 14:49:56,
	Serialize complete at 2012-02-02 14:49:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Block cgroup core can be built as module; however, it isn't too useful
> as blk-throttle can only be built-in and cfq-iosched is usually the
> default built-in scheduler.  Scheduled blkcg cleanup requires calling
> into blkcg from block core.  To simplify that, disallow building blkcg
> as module by making CONFIG_BLK_CGROUP bool.
> 
> If building blkcg core as module really matters, which I doubt, we can
> revisit it after blkcg API cleanup.
> 
> -v2: Vivek pointed out that IOSCHED_CFQ was incorrectly updated to
>      depend on BLK_CGROUP.  Fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/Kconfig.iosched |    4 ----
>  block/blk-cgroup.c    |   17 -----------------
>  block/blk-cgroup.h    |   10 ++--------
>  init/Kconfig          |    2 +-
>  4 files changed, 3 insertions(+), 30 deletions(-)
> 

You can merge the following change with your patch.

Moreover, some cgroup APIs were exported to allow blk-cgroup to be built
as a module, and now they can be unexported.

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fa8f263..bc8ea70 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -55,9 +55,7 @@ struct cgroup_subsys blkio_subsys = {
 	.subsys_id = blkio_subsys_id,
 #endif
 	.use_id = 1,
-	.module = THIS_MODULE,
 };
-EXPORT_SYMBOL_GPL(blkio_subsys);
 
 static inline void blkio_policy_insert_node(struct blkio_cgroup *blkcg,
 					    struct blkio_policy_node *pn)
@@ -1594,8 +1592,6 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 
 	free_css_id(&blkio_subsys, &blkcg->css);
 	rcu_read_unlock();
-	if (blkcg != &blkio_root_cgroup)
-		kfree(blkcg);
 }
 
 static struct cgroup_subsys_state *


