Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1CKAA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:00:26 -0500
Received: from kroah.org ([198.145.64.141]:46877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab1CJX5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.724922731@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 17/29] NFS: NFSv4 readdir loses entries
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit d1205f87bbb8040c1408bbd9e0a720310b2b0b9b upstream.

On recent 2.6.38-rc kernels, connectathon basic test 6 fails on
NFSv4 mounts of OpenSolaris with something like:

> ./test6: readdir
> 	./test6: (/mnt/klimt/matisse.test) didn't read expected 'file.12' dir entry, pass 0
> 	./test6: (/mnt/klimt/matisse.test) didn't read expected 'file.82' dir entry, pass 0
> 	./test6: (/mnt/klimt/matisse.test) didn't read expected 'file.164' dir entry, pass 0
> 	./test6: (/mnt/klimt/matisse.test) Test failed with 3 errors
> basic tests failed
> Tests failed, leaving /mnt/klimt mounted
> [cel@matisse cthon04]$

I narrowed the problem down to nfs4_decode_dirent() reporting that the
decode buffer had overflowed while decoding the entries for those
missing files.

verify_attr_len() assumes both it's pointer arguments reside on the
same page.  When these arguments point to locations on two different
pages, verify_attr_len() can report false errors.  This can happen now
that a large NFSv4 readdir result can span pages.

We have reasonably good checking in nfs4_decode_dirent() anyway, so
it should be safe to simply remove the extra checking.

At a guess, this was introduced by commit 6650239a, "NFS: Don't use
vm_map_ram() in readdir".

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4xdr.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -6212,9 +6212,6 @@ __be32 *nfs4_decode_dirent(struct xdr_st
 	if (entry->fattr->valid & NFS_ATTR_FATTR_TYPE)
 		entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);
 
-	if (verify_attr_len(xdr, p, len) < 0)
-		goto out_overflow;
-
 	return p;
 
 out_overflow:


