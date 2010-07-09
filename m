Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0GIDV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0GIDV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:21:58 -0400
Message-ID: <4C36954A.5050501@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:19:38 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 08/11] blkiocg async: Function to search blkcg from css
 ID
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iotrack stores css ID of blkcg in page_cgroup.  The blkcg is what
the process which dirtied the page belongs to.
This patch introduces a function to search blkcg from the recorded
ID.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/blk-cgroup.c |   13 +++++++++++++
 block/blk-cgroup.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a680964..0756910 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -408,6 +408,19 @@ struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
 }
 EXPORT_SYMBOL_GPL(blkiocg_lookup_group);
 
+/* called under rcu_read_lock(). */
+struct blkio_cgroup *blkiocg_id_to_blkcg(unsigned short id)
+{
+	struct cgroup_subsys_state *css;
+
+	css = css_lookup(&blkio_subsys, id);
+	if (!css)
+		return NULL;
+
+	return container_of(css, struct blkio_cgroup, css);
+}
+EXPORT_SYMBOL_GPL(blkiocg_id_to_blkcg);
+
 #define SHOW_FUNCTION(__VAR)						\
 static u64 blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
 				       struct cftype *cftype)		\
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2b866ec..75c73bd 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -216,6 +216,7 @@ extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
+extern struct blkio_cgroup *blkiocg_id_to_blkcg(unsigned short id);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 					unsigned long time);
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
-- 
1.6.2.5
