Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0HPWsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:48:01 -0400
Received: from mx2.netapp.com ([216.240.18.37]:50485 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab0HPWsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:48:00 -0400
X-IronPort-AV: E=Sophos;i="4.55,378,1278313200"; 
   d="scan'208";a="430101690"
Subject: Re: nfs regression 2.6.35+
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl
In-Reply-To: <20100816070626.GA10503@sli10-desk.sh.intel.com>
References: <20100816070626.GA10503@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Mon, 16 Aug 2010 18:47:34 -0400
Message-ID: <1281998854.3577.84.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
X-OriginalArrivalTime: 16 Aug 2010 22:47:44.0331 (UTC) FILETIME=[0A5A69B0:01CB3D95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 15:06 +0800, Shaohua Li wrote:
> NFS client runs latest git. At client side, use vim to edit a file located at
> NFS server. If I save the file, vim always reports 'E667: Fsync failed'. If I
> revert f7fa16506bf9b6323e862a61e14c20555152bb3, vim works. No kernel errors
> reported.
> 
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

There is already a fix for this in the linux-next tree and in the
'bugfixes' branch of
git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git: see commit
0702099bd86c33c2dcdbd3963433a61f3f503901 (NFS: fix the return value of
nfs_file_fsync()).

I haven't pushed it to Linus yet due to excessive travel this past week.
Will do so soon.

Cheers
  Trond

----------------------------------------------------------------------------------------
commit 0702099bd86c33c2dcdbd3963433a61f3f503901
Author: J. R. Okajima <hooanon05@yahoo.co.jp>
Date:   Wed Aug 11 13:10:16 2010 -0400

    NFS: fix the return value of nfs_file_fsync()
    
    By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
    close(2) became returning the non-zero value even if it went well.
    nfs_file_fsync() should return 0 when "status" is positive.
    
    Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 2d141a7..eb51bd6 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -323,7 +323,7 @@ nfs_file_fsync(struct file *file, int datasync)
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }

