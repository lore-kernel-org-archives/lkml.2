Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab0KVRs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:48:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58100 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754336Ab0KVRs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:48:26 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18ywatA58cyzUFYWX0j37JGIc7JlmKUL2iZBy81yk
	wlZzYb3g5aW9+y
Date: Mon, 22 Nov 2010 18:46:33 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fanotify: Dont allow a mask of 0 if setting or removing a
	mark
Message-ID: <20101122174633.GB5512@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In mark_remove_from_mask() we destroy marks that have their event mask cleared.
Thus we should not allow the creation of those marks in the first place.
With this patch we check if the mask given from user is 0 in case of FAN_MARK_ADD.
If so we return an error. Same for FAN_MARK_REMOVE since this does not have any
effect.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 
 fs/notify/fanotify/fanotify_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

This patch depends on patch "on group destroy allow all waiters to bypass permission 
check" i sent on Nov 19.

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 342d22e..207cdeb 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -780,8 +780,10 @@ SYSCALL_DEFINE(fanotify_mark)(int fanotify_fd, unsigned int flags,
 	if (flags & ~FAN_ALL_MARK_FLAGS)
 		return -EINVAL;
 	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
-	case FAN_MARK_ADD:
+	case FAN_MARK_ADD:		/* fallthrough */
 	case FAN_MARK_REMOVE:
+		if (!mask)
+			return -EINVAL;
 	case FAN_MARK_FLUSH:
 		break;
 	default:
-- 
1.5.6.5

