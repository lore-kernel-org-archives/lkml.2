Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1HCXaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:30:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab1HCX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:29:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:51 2011
Message-Id: <20110803221251.685552460@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [076/102] nfsd4: remember to put RW access on stateid destruction
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 499f3edc23ca0431f3a0a6736b3a40944c81bf3b upstream.

Without this, for example,

	open read
	open read+write
	close

will result in a struct file leak.

Regression from 7d94784293096c0a46897acdb83be5abd9278ece "nfsd4: fix
downgrade/lock logic".

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -381,14 +381,6 @@ static int nfs4_access_to_omode(u32 acce
 	BUG();
 }
 
-static int nfs4_access_bmap_to_omode(struct nfs4_stateid *stp)
-{
-	unsigned int access;
-
-	set_access(&access, stp->st_access_bmap);
-	return nfs4_access_to_omode(access);
-}
-
 static void unhash_generic_stateid(struct nfs4_stateid *stp)
 {
 	list_del(&stp->st_hash);
@@ -398,11 +390,14 @@ static void unhash_generic_stateid(struc
 
 static void free_generic_stateid(struct nfs4_stateid *stp)
 {
-	int oflag;
+	int i;
 
 	if (stp->st_access_bmap) {
-		oflag = nfs4_access_bmap_to_omode(stp);
-		nfs4_file_put_access(stp->st_file, oflag);
+		for (i = 1; i < 4; i++) {
+			if (test_bit(i, &stp->st_access_bmap))
+				nfs4_file_put_access(stp->st_file,
+						nfs4_access_to_omode(i));
+		}
 	}
 	put_nfs4_file(stp->st_file);
 	kmem_cache_free(stateid_slab, stp);


