Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0KWOuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:50:23 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53725 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0KWOuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Hq/zrSM27O72xDZClZu2svB8araC06yyP7mp8sRCZn20OWdz+fM0w3aA8Y0hOTgdPx
         2WQ6eoltqKe5yCWeqjXlrP2vr69hmhdZ7uqEzzMrmCV/ymfGlE2PEFd8bseU2iIHycQl
         A4U4ovVrMN00CF7U66D65PEo3bw13LwYI51vE=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, rsync@lists.samba.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Ben Gamari <bgamari.foss@gmail.com>
Subject: [PATCH 1/3] Add fadvise interface wrapper
Date: Tue, 23 Nov 2010 09:49:50 -0500
Message-Id: <1290523792-6170-2-git-send-email-bgamari.foss@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101122103756.E236.A69D9226@jp.fujitsu.com>
References: <20101122103756.E236.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent discussion on the LKML[1], it seems likely that Linux will
finally support posix_fadvise in a useful way with the FADV_DONTNEED
flag. This should allow us to minimize the effect of rsync on the
system's working set. Add the necessary wrapper to syscall.c.

[1] http://lkml.org/lkml/2010/11/21/59
---
 syscall.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/syscall.c b/syscall.c
index cfabc3e..9f5b1c3 100644
--- a/syscall.c
+++ b/syscall.c
@@ -28,6 +28,7 @@
 #ifdef HAVE_SYS_ATTR_H
 #include <sys/attr.h>
 #endif
+#include <fcntl.h>
 
 extern int dry_run;
 extern int am_root;
@@ -282,3 +283,13 @@ OFF_T do_lseek(int fd, OFF_T offset, int whence)
 	return lseek(fd, offset, whence);
 #endif
 }
+
+#if _XOPEN_SOURCE >= 600
+int do_fadvise(int fd, OFF_T offset, OFF_T len, int advise)
+{
+        return posix_fadvise(fd, offset, len, advise);
+}
+#else
+#define do_fadvise() 
+#endif
+
-- 
1.7.1

