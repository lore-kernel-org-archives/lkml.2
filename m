Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0GOCBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:01:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56315 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab0GOCBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:01:32 -0400
Message-ID: <4C3E6B78.6070808@cn.fujitsu.com>
Date: Thu, 15 Jul 2010 09:59:20 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] CFQ: delay getting cfq group at the very point we really
 need it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delay searching or allocating a cfq group at the very point that
we really need it. This change would save some cycles every time
we're getting a cfq queue.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index eb4086f..9b0cf13 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2820,10 +2820,8 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_context *cic;
-	struct cfq_group *cfqg;
 
 retry:
-	cfqg = cfq_get_cfqg(cfqd, 1);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
@@ -2852,6 +2850,9 @@ retry:
 		}
 
 		if (cfqq) {
+			struct cfq_group *cfqg;
+
+			cfqg = cfq_get_cfqg(cfqd, 1);
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 			cfq_init_prio_data(cfqq, ioc);
 			cfq_link_cfqq_cfqg(cfqq, cfqg);
-- 1.5.4.rc3 
