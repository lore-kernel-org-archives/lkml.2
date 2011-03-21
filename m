Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1CURF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:05:27 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10647 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1CURFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:05:25 -0400
X-IronPort-AV: E=Sophos;i="4.63,220,1299484800"; 
   d="scan'208";a="532859707"
Subject: Re: [NFS BUG] Resoruces leak caused by commit - NFS: Don't use
 vm_map_ram() in readdir (55ea499d60aefa3d03a77fc8590c26b5881faa92)
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: mkl@pengutronix.de, gregkh@suse.de, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTik1jXk2qG6rKCtXMbVq6wFdz2oeXuZmAcfU_R8X@mail.gmail.com>
References: <AANLkTik1jXk2qG6rKCtXMbVq6wFdz2oeXuZmAcfU_R8X@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-Fu76TJBs1Qx/8Q9VtXoG"
Organization: NetApp Inc
Date: Mon, 21 Mar 2011 13:05:19 -0400
Message-ID: <1300727119.13307.3.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 21 Mar 2011 17:05:25.0122 (UTC) FILETIME=[2BAB9620:01CBE7EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fu76TJBs1Qx/8Q9VtXoG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-03-21 at 17:53 +0100, Jacek Luczak wrote:
> Hi,
>=20
> *BRIEF*: Reading lot of files from nfs mounted on directory lead to a
> resources leak. Affected Kernels: 2.6.37.1-2.6.37.4, did not tested on
> 2.6.38 (assume that issue is also there).
>=20
> Steps to reproduce:
>  1) cd /some/nfs/mounted/dir
>  2) find . =E2=80=93type f | wc =E2=80=93l
> On healthy system this will give a number of files below the dir - in
> my test env. this gives 692 files. On broken system after a while when
> whole memory will be consumed this will throw:
> find: memory exhausted
>=20
> Reproduced same with rsync to local storage:
> sending incremental file list
> [sender] expand file_list pointer array to 524288 bytes, did move
> [sender] expand file_list pointer array to 1048576 bytes, did move
> [sender] expand file_list pointer array to 2097152 bytes, did move
> [sender] expand file_list pointer array to 4194304 bytes, did move
> [sender] expand file_list pointer array to 8388608 bytes, did move
> [sender] expand file_list pointer array to 16777216 bytes, did move
> [sender] expand file_list pointer array to 33554432 bytes, did move
> [sender] expand file_list pointer array to 67108864 bytes, did move
> [sender] expand file_list pointer array to 134217728 bytes, did move
> [sender] expand file_list pointer array to 268435456 bytes, did move
> [sender] expand file_list pointer array to 402653184 bytes, did move
> [sender] expand file_list pointer array to 536870912 bytes, did move
> [sender] expand file_list pointer array to 671088640 bytes, did move
> [sender] expand file_list pointer array to 805306368 bytes, did move
> [sender] expand file_list pointer array to 939524096 bytes, did move
> [sender] expand file_list pointer array to 1073741824 bytes, did move
> Same results as with find =E2=80=93 memory consumption bumps to all avail=
able space.
>=20
> Bisected this down to commit:
> 55ea499d60aefa3d03a77fc8590c26b5881faa92 is the first bad commit
> commit 55ea499d60aefa3d03a77fc8590c26b5881faa92
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Sat Jan 8 17:45:38 2011 -0500
>=20
>     NFS: Don't use vm_map_ram() in readdir
>=20
>     commit 6650239a4b01077e80d5a4468562756d77afaa59 upstream.
>=20
>     vm_map_ram() is not available on NOMMU platforms, and causes trouble
>     on incoherrent architectures such as ARM when we access the page data
>     through both the direct and the virtual mapping.
>=20
>     The alternative is to use the direct mapping to access page data
>     for the case when we are not crossing a page boundary, but to copy
>     the data into a linear scratch buffer when we are accessing data
>     that spans page boundaries.
>=20
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>     Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> :040000 040000 b8416029d026cd8e43d6517bcce32ea86180d31a
> 49dd8041519101ab68075b502ad18127f6ab86d4 M      fs
> :040000 040000 9332a8f43f88b80dd11d76da0e35bfdfe345798f
> 71b519dd4ce6fe70a9ecaa1e068bc56ea7c0cd4e M      include
> :040000 040000 d4f45b70708f5d238eacececb9459c7a88d8ec77
> f70bedd7247a37e14972448f5f1803edc1440fc4 M      net
>=20
> Reverting this commit fixes this issue.

Does the attached patch help? It fixes an old readdir decoding bug that
the above commit happened to expose.

Trond
--=20
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


--=-Fu76TJBs1Qx/8Q9VtXoG
Content-Disposition: inline
Content-Description: Attached message - [PATCH] NFS: Fix a decoding problem
 in nfs3_decode_dirent
Content-Type: message/rfc822

Received: from sacrsexc1-prd.hq.netapp.com ([10.99.115.27]) by
 SACMVEXC2-PRD.hq.netapp.com with Microsoft SMTPSVC(6.0.3790.3959); Thu, 17
 Mar 2011 18:54:46 -0700
Received: from smtp1.corp.netapp.com ([10.57.156.124]) by
 sacrsexc1-prd.hq.netapp.com with Microsoft SMTPSVC(6.0.3790.3959); Thu, 17
 Mar 2011 18:54:46 -0700
Received: from lade.trondhjem.org.com (henryv2-lxp.hq.netapp.com
 [10.58.56.129] (may be forged)) by smtp1.corp.netapp.com
 (8.13.1/8.13.1/NTAP-1.6) with ESMTP id p2I1sjvD009572; Thu, 17 Mar 2011
 18:54:45 -0700 (PDT)
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: stable@kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] NFS: Fix a decoding problem in nfs3_decode_dirent
Date: Thu, 17 Mar 2011 21:54:39 -0400
Message-Id: <1300413279-12570-1-git-send-email-Trond.Myklebust@netapp.com>
X-Mailer: git-send-email 1.7.4
Return-Path: Trond.Myklebust@netapp.com
X-OriginalArrivalTime: 18 Mar 2011 01:54:46.0303 (UTC)
 FILETIME=[752832F0:01CBE50F]
X-Evolution-Source: exchange://trond@SACMVEXC2-PRD.hq.netapp.com/
Mime-Version: 1.0

When we decode a filename followed by an 8-byte cookie, we need to
consider the fact that the filename and cookie are 32-bit word aligned.
Presently, we may end up copying insufficient amounts of data when
xdr_inline_decode() needs to invoke xdr_copy_to_scratch to deal
with a page boundary.

The following patch fixes the issue by first decoding the filename, and
then decoding the cookie.

Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: NeilBrown <neilb@suse.de>
---
Hi Greg,

This needs to be applied to 2.6.37 only. The bug in question was
inadvertently fixed by a series of cleanups in 2.6.38, but the patches
in question are too large to be backported. This patch is a minimal fix
that serves the same purpose.


 fs/nfs/nfs2xdr.c |    6 ++++--
 fs/nfs/nfs3xdr.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index b382a1b..33a038d 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -477,11 +477,13 @@ nfs_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry, struct nfs_se
 	entry->ino	  = ntohl(*p++);
 	entry->len	  = ntohl(*p++);
 
-	p = xdr_inline_decode(xdr, entry->len + 4);
+	p = xdr_inline_decode(xdr, entry->len);
 	if (unlikely(!p))
 		goto out_overflow;
 	entry->name	  = (const char *) p;
-	p		 += XDR_QUADLEN(entry->len);
+	p = xdr_inline_decode(xdr, 4);
+	if (unlikely(!p))
+		goto out_overflow;
 	entry->prev_cookie	  = entry->cookie;
 	entry->cookie	  = ntohl(*p++);
 
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index ba91236..dcd934f 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -614,11 +614,13 @@ nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry, struct nfs_s
 	p = xdr_decode_hyper(p, &entry->ino);
 	entry->len  = ntohl(*p++);
 
-	p = xdr_inline_decode(xdr, entry->len + 8);
+	p = xdr_inline_decode(xdr, entry->len);
 	if (unlikely(!p))
 		goto out_overflow;
 	entry->name = (const char *) p;
-	p += XDR_QUADLEN(entry->len);
+	p = xdr_inline_decode(xdr, 8);
+	if (unlikely(!p))
+		goto out_overflow;
 	entry->prev_cookie = entry->cookie;
 	p = xdr_decode_hyper(p, &entry->cookie);
 
-- 
1.7.4


--=-Fu76TJBs1Qx/8Q9VtXoG--
