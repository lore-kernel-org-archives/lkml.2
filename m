Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1GHFFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab1GHFFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.017140478@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seth Forshee <seth.forshee@canonical.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [085/107] hfsplus: add missing call to bio_put()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit 50176ddefa4a942419cb693dd2d8345bfdcde67c upstream.

hfsplus leaks bio objects by failing to call bio_put() on the bios
it allocates. Add the missing call to fix the leak.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfsplus/wrapper.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -36,6 +36,7 @@ int hfsplus_submit_bio(struct block_devi
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
+	int ret = 0;
 
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_sector = sector;
@@ -54,8 +55,10 @@ int hfsplus_submit_bio(struct block_devi
 	wait_for_completion(&wait);
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
-		return -EIO;
-	return 0;
+		ret = -EIO;
+
+	bio_put(bio);
+	return ret;
 }
 
 static int hfsplus_read_mdb(void *bufptr, struct hfsplus_wd *wd)


