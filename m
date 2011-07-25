Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1GYUF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:05:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47834 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1GYUFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:05:55 -0400
From: Will Drewry <wad@chromium.org>
To: akpm@linux-foundation.org
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, Jens Axboe <jaxboe@fusionio.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] init: clean up devt_from_partuuid syntax checking and logging
Date: Mon, 25 Jul 2011 14:55:26 -0500
Message-Id: <1311623726-32581-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <CABqD9hY7xLWLeeFiKGdMT8VveXQAv3PgC-ZGPdd4qO1AfgDZWw@mail.gmail.com>
References: <CABqD9hY7xLWLeeFiKGdMT8VveXQAv3PgC-ZGPdd4qO1AfgDZWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two changes:
- check for trailing characters after parsing PARTNROFF=%d
- disable root_wait if a syntax error is seen

The former assures that bad input like
  root=PARTUUID=<validuuid>/PARTNROFF=5abc
properly fails by attempting to parse an extra character after the
integer.  If the integer is missing, sscanf will fail, but if it is
present, and there is a trailing non-nul character, then the extra
field will be parsed and the error case will be hit.

The latter assures that if rootwait has been specified, the error
message isn't flooded to the screen during rootwait's loop.  Instead of
adding printk ratelimiting, root_wait was disabled.  This stays true to
the rootwait goal of support asynchronous device arrival while still
providing users with helpful messages.  With ratelimiting or disabling
logging on rootwait, a range of edge cases turn up where the user would
not be informed of an error properly.

This patch is meant to be applied on top of:
  http://userweb.kernel.org/~akpm/mmotm/broken-out/init-add-root=partuuid=uuid-partnroff=%25d-support.patch

Please let me know if you'd prefer a new patch series with this
integrated into the above patch (or as 3rd in the series).

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/do_mounts.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 13cddea..bcbeca7 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -110,10 +110,16 @@ static dev_t devt_from_partuuid(char *uuid_str)
 
 	/* Check for optional partition number offset attributes. */
 	if (uuid_str[36]) {
+		char c = 0;
 		/* Explicitly fail on poor PARTUUID syntax. */
-		if (sscanf(&uuid_str[36], "/PARTNROFF=%d", &offset) != 1) {
+		if (sscanf(&uuid_str[36],
+			   "/PARTNROFF=%d%c", &offset, &c) != 1) {
 			printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
 			 "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
+			if (root_wait)
+				printk(KERN_ERR
+				     "Disabling rootwait; root= is invalid.\n");
+			root_wait = 0;
 			goto done;
 		}
 	}
-- 
1.7.0.4

