Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1AQTjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:39:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62403 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1AQTjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=A1lWTe/ZsAA51YZSwVAwkWdyLBcNGxq08WGRMnaiElveMA+/aR0z7siXyVTOL02gLx
         zwYdFYs7fzSoguAK3Thaj9HuKuE1/jj8G8F81icDU4QclArn0bG3bJ3o9YWsXRsYIAcY
         ScawMZM8Lj49plm2u7v6P7xoBdpjmS0UwF0Lk=
Date: Mon, 17 Jan 2011 21:39:10 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: fix memory leak in btrfs_parse_early_options()
Message-ID: <20110117193910.GA26094@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strsep() modifies the string pointer, therefore freeing it instead of
original one results in a small memory leak.  Fixes kmemleak warning.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 883c6fa..291b630 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -277,7 +277,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
-	char *opts, *p;
+	char *opts, *opts_orig, *p;
 	int error = 0;
 	int intarg;
 
@@ -288,7 +288,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	 * strsep changes the string, duplicate it because parse_options
 	 * gets called twice
 	 */
-	opts = kstrdup(options, GFP_KERNEL);
+	opts = opts_orig = kstrdup(options, GFP_KERNEL);
 	if (!opts)
 		return -ENOMEM;
 
@@ -326,7 +326,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	}
 
  out_free_opts:
-	kfree(opts);
+	kfree(opts_orig);
  out:
 	/*
 	 * If no subvolume name is specified we use the default one.  Allocate
-- 
1.7.2.3

