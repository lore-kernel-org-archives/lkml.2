Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab0HLAcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:32:55 -0400
Received: from kroah.org ([198.145.64.141]:43559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759211Ab0HKX7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:02 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:03 2010
Message-Id: <20100811235502.992426280@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [081/111] Btrfs: kfree correct pointer during mount option parsing
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit da495ecc0fb096b383754952a1c152147bc95b52 upstream.

We kstrdup the options string, but then strsep screws with the pointer,
so when we kfree() it, we're not giving it the right pointer.

Tested-by: Andy Lutomirski <luto@mit.edu>

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -126,7 +126,7 @@ int btrfs_parse_options(struct btrfs_roo
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num;
+	char *p, *num, *orig;
 	int intarg;
 	int ret = 0;
 
@@ -141,6 +141,7 @@ int btrfs_parse_options(struct btrfs_roo
 	if (!options)
 		return -ENOMEM;
 
+	orig = options;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -273,7 +274,7 @@ int btrfs_parse_options(struct btrfs_roo
 		}
 	}
 out:
-	kfree(options);
+	kfree(orig);
 	return ret;
 }
 


