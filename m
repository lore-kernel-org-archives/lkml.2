Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2GEKqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:46:06 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:49871 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2GEKqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:46:03 -0400
X-AuditID: 0ac90646-978c2ba000003485-98-4ff56fe61550
X-AuditID: 0ac90646-978c2ba000003485-98-4ff56fe61550
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 3/5] fuse: make default global limit minimum value
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2012 19:51:00 +0900
Message-ID: <20120705105059.17812.31903.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default global limits for congestion threshold and backgrounded
requests are calculated using size of fuse_req structure, which is
variable due to the tunable read/write request size. This patch sets
them to their minimum values by default in order to avoid the variable
and unstable limits per mount.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---

 fs/fuse/fuse_i.h |    5 +++++
 fs/fuse/inode.c  |    2 +-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c96dc5f..72210a8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -29,6 +29,11 @@
 /** Default number of pages that can be used in a single read/write request */
 #define FUSE_DEFAULT_MAX_PAGES_PER_REQ 32
 
+/** Maximum size of struct fuse_req */
+#define FUSE_MAX_FUSE_REQ_SIZE	(sizeof(struct fuse_req) + \
+				 FUSE_MAX_PAGES_PER_REQ * \
+				 sizeof(struct page *))
+
 /** Bias for fi->writectr, meaning new writepages must not be sent */
 #define FUSE_NOWRITE INT_MIN
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index aadf157..d8d302a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -758,7 +758,7 @@ static void sanitize_global_limit(unsigned *limit)
 {
 	if (*limit == 0)
 		*limit = ((num_physpages << PAGE_SHIFT) >> 13) /
-			 sizeof(struct fuse_req);
+			 FUSE_MAX_FUSE_REQ_SIZE;
 
 	if (*limit >= 1 << 16)
 		*limit = (1 << 16) - 1;

