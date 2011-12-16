Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab1LPT4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:56:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923Ab1LPTxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:53:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:13 2011
Message-Id: <20111216194213.144852349@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <mszeredi@suse.cz>
Subject: [39/45] fuse: fix fuse_retrieve
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 48706d0a91583d08c56e7ef2a7602d99c8d4133f upstream.

Fix two bugs in fuse_retrieve():

 - retrieving more than one page would yield repeated instances of the
   first page

 - if more than FUSE_MAX_PAGES_PER_REQ pages were requested than the
   request page array would overflow

fuse_retrieve() was added in 2.6.36 and these bugs had been there since the
beginning.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1512,7 +1512,7 @@ static int fuse_retrieve(struct fuse_con
 	else if (outarg->offset + num > file_size)
 		num = file_size - outarg->offset;
 
-	while (num) {
+	while (num && req->num_pages < FUSE_MAX_PAGES_PER_REQ) {
 		struct page *page;
 		unsigned int this_num;
 
@@ -1526,6 +1526,7 @@ static int fuse_retrieve(struct fuse_con
 
 		num -= this_num;
 		total_len += this_num;
+		index++;
 	}
 	req->misc.retrieve_in.offset = outarg->offset;
 	req->misc.retrieve_in.size = total_len;


