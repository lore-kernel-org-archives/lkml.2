Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab0LBKJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:09:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51941 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751492Ab0LBKJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:09:15 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18RXHwwfCcRHDcEYoY2o5EjqttjpCt+70hDhiu5xB
	r3LvBR+ZVr0EOF
Date: Thu, 2 Dec 2010 11:07:09 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/6] fanotify: only destroy a mark if both its mask and its
	ignored_mask are cleared
Message-ID: <20101202100709.GE5196@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we destroy a mark if one of its masks - event mask or ignored mask - are
cleared without checking if the other mask is also clear.

With this patch we only destroy a mark if both masks are cleared.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c9cd1b9..6b9606a 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -517,6 +517,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 					    unsigned int flags)
 {
 	__u32 oldmask;
+	int destroy_mark;
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
@@ -526,9 +527,10 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
 		oldmask = fsn_mark->ignored_mask;
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
 	}
+	destroy_mark = (!fsn_mark->mask && !fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
 
-	if (!(oldmask & ~mask))
+	if (destroy_mark)
 		fsnotify_destroy_mark(fsn_mark);
 
 	return mask & oldmask;
-- 
1.5.6.5

