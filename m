Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1DQPD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 11:03:59 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:56593 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1DQPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 11:03:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: [105/105] nfsd4: fix oops on lock failure
References: <20110412143559.186613198@clark.kroah.org>
Date: Mon, 18 Apr 2011 00:03:44 +0900
In-Reply-To: <20110412143559.186613198@clark.kroah.org> (Greg KH's message of
	"Tue, 12 Apr 2011 07:35:34 -0700")
Message-ID: <87pqokx6lr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: J. Bruce Fields <bfields@redhat.com>
>
> commit 23fcf2ec93fb8573a653408316af599939ff9a8e upstream.
>
> Lock stateid's can have access_bmap 0 if they were only partially
> initialized (due to a failed lock request); handle that case in
> free_generic_stateid.

I'm looking filp leak on recent kernel. Well, anyway,
23fcf2ec93fb8573a653408316af599939ff9a8e is strange, and I think it can
be one of causes.


[PATCH] nfsd4: Fix filp leak

23fcf2ec93fb8573a653408316af599939ff9a8e (nfsd4: fix oops on lock failure)

The above patch breaks free path for stp->st_file. If stp was inserted
into sop->so_stateids, we have to free stp->st_file refcount. Because
stp->st_file refcount itself is taken unrelated to stp->st_file->fi_fds[].

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~nfsd4-filp-leak-fix fs/nfsd/nfs4state.c
--- linux-2.6/fs/nfsd/nfs4state.c~nfsd4-filp-leak-fix	2011-04-17 20:45:45.000000000 +0900
+++ linux-2.6-hirofumi/fs/nfsd/nfs4state.c	2011-04-17 20:59:53.000000000 +0900
@@ -402,8 +402,8 @@ static void free_generic_stateid(struct
 	if (stp->st_access_bmap) {
 		oflag = nfs4_access_bmap_to_omode(stp);
 		nfs4_file_put_access(stp->st_file, oflag);
-		put_nfs4_file(stp->st_file);
 	}
+	put_nfs4_file(stp->st_file);
 	kmem_cache_free(stateid_slab, stp);
 }
 
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
