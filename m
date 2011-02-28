Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1B1Qha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:30 -0500
Received: from kroah.org ([198.145.64.141]:48030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab1B1Qh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.519850279@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizf@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        maximilian attems <max@stro.at>
Subject: [28/68] sunrpc/cache: fix module refcnt leak in a failure path
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


