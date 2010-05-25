Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab0EYSTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:19:38 -0400
Received: from kroah.org ([198.145.64.141]:44391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423Ab0EYSRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:31 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:13 2010
Message-Id: <20100525181213.472355553@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [14/25] nfsd4: bug in read_buf
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Brown <neilb@suse.de>

commit 2bc3c1179c781b359d4f2f3439cb3df72afc17fc upstream.

When read_buf is called to move over to the next page in the pagelist
of an NFSv4 request, it sets argp->end to essentially a random
number, certainly not an address within the page which argp->p now
points to.  So subsequent calls to READ_BUF will think there is much
more than a page of spare space (the cast to u32 ensures an unsigned
comparison) so we can expect to fall off the end of the second
page.

We never encountered thsi in testing because typically the only
operations which use more than two pages are write-like operations,
which have their own decoding logic.  Something like a getattr after a
write may cross a page boundary, but it would be very unusual for it to
cross another boundary after that.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -179,10 +179,10 @@ static __be32 *read_buf(struct nfsd4_com
 	argp->p = page_address(argp->pagelist[0]);
 	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
-		argp->end = p + (argp->pagelen>>2);
+		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
 	} else {
-		argp->end = p + (PAGE_SIZE>>2);
+		argp->end = argp->p + (PAGE_SIZE>>2);
 		argp->pagelen -= PAGE_SIZE;
 	}
 	memcpy(((char*)p)+avail, argp->p, (nbytes - avail));
@@ -1115,10 +1115,10 @@ nfsd4_decode_compound(struct nfsd4_compo
 			argp->p = page_address(argp->pagelist[0]);
 			argp->pagelist++;
 			if (argp->pagelen < PAGE_SIZE) {
-				argp->end = p + (argp->pagelen>>2);
+				argp->end = argp->p + (argp->pagelen>>2);
 				argp->pagelen = 0;
 			} else {
-				argp->end = p + (PAGE_SIZE>>2);
+				argp->end = argp->p + (PAGE_SIZE>>2);
 				argp->pagelen -= PAGE_SIZE;
 			}
 		}


