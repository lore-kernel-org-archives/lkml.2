Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2EAN1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:27:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45872 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2EAN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:27:19 -0400
Date: Tue, 1 May 2012 06:25:45 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 2/3] vmevent: Pass attr argument to sampling functions
Message-ID: <20120501132544.GB24226@lizard>
References: <20120501132409.GA22894@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120501132409.GA22894@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need the argument for blended attributes, the attributes return
either 0 or the threshold value (which is in attr).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/vmevent.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index 9f1520b..b312236 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -39,9 +39,11 @@ struct vmevent_watch {
 	wait_queue_head_t		waitq;
 };
 
-typedef u64 (*vmevent_attr_sample_fn)(struct vmevent_watch *watch);
+typedef u64 (*vmevent_attr_sample_fn)(struct vmevent_watch *watch,
+				      struct vmevent_attr *attr);
 
-static u64 vmevent_attr_swap_pages(struct vmevent_watch *watch)
+static u64 vmevent_attr_swap_pages(struct vmevent_watch *watch,
+				   struct vmevent_attr *attr)
 {
 #ifdef CONFIG_SWAP
 	struct sysinfo si;
@@ -54,12 +56,14 @@ static u64 vmevent_attr_swap_pages(struct vmevent_watch *watch)
 #endif
 }
 
-static u64 vmevent_attr_free_pages(struct vmevent_watch *watch)
+static u64 vmevent_attr_free_pages(struct vmevent_watch *watch,
+				   struct vmevent_attr *attr)
 {
 	return global_page_state(NR_FREE_PAGES);
 }
 
-static u64 vmevent_attr_avail_pages(struct vmevent_watch *watch)
+static u64 vmevent_attr_avail_pages(struct vmevent_watch *watch,
+				    struct vmevent_attr *attr)
 {
 	return totalram_pages;
 }
@@ -74,7 +78,7 @@ static u64 vmevent_sample_attr(struct vmevent_watch *watch, struct vmevent_attr
 {
 	vmevent_attr_sample_fn fn = attr_samplers[attr->type];
 
-	return fn(watch);
+	return fn(watch, attr);
 }
 
 static bool vmevent_match(struct vmevent_watch *watch)
-- 
1.7.9.2

