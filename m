Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab0J1VfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:35:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934603Ab0J1VdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:17 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 17/20] fanotify: do not recalculate the mask if the ignored
	mask changed
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:33:13 -0400
Message-ID: <20101028213313.24810.5978.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fanotify sets a new bit in the ignored mask it will cause the generic
fsnotify layer to recalculate the real mask.  This is stupid since we
didn't change that part.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ff1a908..fa71d5d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -558,15 +558,15 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 				       __u32 mask,
 				       unsigned int flags)
 {
-	__u32 oldmask;
+	__u32 oldmask = -1;
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		oldmask = fsn_mark->mask;
 		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask | mask));
 	} else {
-		oldmask = fsn_mark->ignored_mask;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask | mask));
+		__u32 tmask = fsn_mark->ignored_mask | mask;
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}

