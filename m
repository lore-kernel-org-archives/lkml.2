Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2KUMCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:02:05 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32306 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab2KUMCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:02:03 -0500
Subject: Re: [PATCH 14/14] mm: Account for WRITEBACK_TEMP in
 balance_dirty_pages
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        linux-mm@kvack.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Wed, 21 Nov 2012 16:01:28 +0400
Message-ID: <20121121115314.20471.52148.stgit@maximpc.sw.ru>
In-Reply-To: <20121116171039.3196.92186.stgit@maximpc.sw.ru>
References: <20121116171039.3196.92186.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added linux-mm@ to cc:. The patch can stand on it's own.

> Make balance_dirty_pages start the throttling when the WRITEBACK_TEMP
> counter is high enough. This prevents us from having too many dirty
> pages on fuse, thus giving the userspace part of it a chance to write
> stuff properly.
> 
> Note, that the existing balance logic is per-bdi, i.e. if the fuse
> user task gets stuck in the function this means, that it either
> writes to the mountpoint it serves (but it can deadlock even without
> the writeback) or it is writing to some _other_ dirty bdi and in the
> latter case someone else will free the memory for it.

Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 mm/page-writeback.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 830893b..499a606 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1220,7 +1220,8 @@ static void balance_dirty_pages(struct address_space *mapping,
 		 */
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
+		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK) +
+			global_page_state(NR_WRITEBACK_TEMP);
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 

