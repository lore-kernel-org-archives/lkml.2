Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0CXXhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:37:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11256 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0CXXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:37:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=TSXIACV0OWXGaMpUE7ur1zs1xcsAEiN1ySC5cvE3/txTbNeRdPocSjklhRgEhVPTk
	dIRzJ01IG7C/zHe57fw2Q==
From: Ricky Benitez <rickyb@google.com>
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Ricky Benitez <rickyb@google.com>
Subject: [PATCH] Expose the statistics in blkio.time and blkio.sectors for the root cgroup
Date: Wed, 24 Mar 2010 16:35:56 -0700
Message-Id: <1269473756-30327-1-git-send-email-rickyb@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the io statistics for the root cgroup are maintained, but
they are not shown because the device information is not available at
the point that the root blkio cgroup is created. This patch updates
the device information when the statistics are updated so that the
statistics become visible.

Signed-off-by: Ricky Benitez <rickyb@google.com>
---
 block/cfq-iosched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dee9d93..4a3579a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -947,6 +947,11 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	unsigned int major, minor;
 
 	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfqg->blkg.dev = MKDEV(major, minor);
+		goto done;
+	}
 	if (cfqg || !create)
 		goto done;
 
-- 
1.7.0.1

