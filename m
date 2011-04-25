Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1DYUrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:47:10 -0400
Received: from 1wt.eu ([62.212.114.60]:34240 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993Ab1DYUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:39 -0400
Message-Id: <20110425200234.427595139@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Konstantin Khorenko <khorenko@openvz.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 033/173] NFSD: memory corruption due to writing beyond the stat array
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Konstantin Khorenko <khorenko@parallels.com>

commit 3aa6e0aa8ab3e64bbfba092c64d42fd1d006b124 upstream.

If nfsd fails to find an exported via NFS file in the readahead cache, it
should increment corresponding nfsdstats counter (ra_depth[10]), but due to a
bug it may instead write to ra_depth[11], corrupting the following field.

In a kernel with NFSDv4 compiled in the corruption takes the form of an
increment of a counter of the number of NFSv4 operation 0's received; since
there is no operation 0, this is harmless.

In a kernel with NFSDv4 disabled it corrupts whatever happens to be in the
memory beyond nfsdstats.

Signed-off-by: Konstantin Khorenko <khorenko@openvz.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -823,7 +823,7 @@ nfsd_get_raparms(dev_t dev, ino_t ino)
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;


