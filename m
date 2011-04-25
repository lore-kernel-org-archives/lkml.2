Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab1DYUrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:47:47 -0400
Received: from 1wt.eu ([62.212.114.60]:34236 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab1DYUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:39 -0400
Message-Id: <20110425200234.944227421@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        maximilian attems <max@stro.at>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 045/173] sunrpc/cache: fix module refcnt leak in a failure path
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit a5990ea1254cd186b38744507aeec3136a0c1c95 upstream.

Don't forget to release the module refcnt if seq_open() returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/cache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1234,8 +1234,10 @@ static int content_open(struct inode *in
 	if (!cd || !try_module_get(cd->owner))
 		return -EACCES;
 	han = __seq_open_private(file, &cache_content_op, sizeof(*han));
-	if (han == NULL)
+	if (han == NULL) {
+		module_put(cd->owner);
 		return -ENOMEM;
+	}
 
 	han->cd = cd;
 	return 0;


