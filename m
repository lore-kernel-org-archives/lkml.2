Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291Ab1GMKkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:40:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53767 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab1GMKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:40:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: stable@kernel.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        helge.hafting@hist.no
Subject: [PATCH] cifs: lower default and max wsize to what 2.6.39 can handle
Date: Wed, 13 Jul 2011 06:40:37 -0400
Message-Id: <1310553637-26792-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is intended for 2.6.39-stable kernels only and is needed to
fix a regression introduced in 2.6.39. Prior to 2.6.39, when signing was
enabled on a socket the client only sent single-page writes. This
changed with commit ca83ce3, which made signed and unsigned connections
use the same codepaths for write calls.

This caused a regression when working with windows servers. Windows
machines will reject writes larger than the MaxBufferSize when signing
is active, but do not clear the CAP_LARGE_WRITE_X flag in the protocol
negotiation. The upshot is that when signing is active, windows servers
often reject large writes from the client in 2.6.39.

Because 3.0 adds support for larger wsize values, simply cherry picking
the upstream patches that fix the wsize negotiation isn't sufficient to
fix this issue. We also need to alter the maximum and default values to
something suitable for 2.6.39.

Cc: <stable@kernel.org> # .39.x: f7910cb: cifs: clean up wsize negotiation and allow for larger wsize
Cc: <stable@kernel.org> # .39.x: 1190f6a: cifs: fix wsize negotiation to respect max buffer size and active signing (try #4)
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 599f485..8e78710 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2648,16 +2648,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			   "mount option supported");
 }
 
-/*
- * When the server supports very large writes via POSIX extensions, we can
- * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not including
- * the RFC1001 length.
- *
- * Note that this might make for "interesting" allocation problems during
- * writeback however as we have to allocate an array of pointers for the
- * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
- */
-#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
+/* Prior to 3.0, cifs couldn't handle writes larger than this */
+#define CIFS_MAX_WSIZE (PAGEVEC_SIZE * PAGE_CACHE_SIZE)
 
 /*
  * When the server doesn't allow large posix writes, only allow a wsize of
@@ -2666,12 +2658,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
  */
 #define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
 
-/*
- * The default wsize is 1M. find_get_pages seems to return a maximum of 256
- * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
- * a single wsize request with a single call.
- */
-#define CIFS_DEFAULT_WSIZE (1024 * 1024)
+/* Make the default the same as the max */
+#define CIFS_DEFAULT_WSIZE CIFS_MAX_WSIZE
 
 static unsigned int
 cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvolume_info)
-- 
1.7.6

