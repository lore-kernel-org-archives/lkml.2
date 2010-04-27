Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0D0Uu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:50:59 -0400
Received: from www.tglx.de ([62.245.132.106]:39623 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab0D0Uu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:50:57 -0400
Date: Tue, 27 Apr 2010 22:50:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@gmail.com>
cc: Nick Piggin <npiggin@suse.de>, jstultz@gmail.com,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: 2.6.33.3-rt16 compile failure in fs/ecryptfs/inode.o
In-Reply-To: <alpine.LFD.2.00.1004272202250.3318@localhost>
Message-ID: <alpine.LFD.2.00.1004272249400.2951@localhost.localdomain>
References: <alpine.LFD.2.00.1004272202250.3318@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1968843256-1272401447=:2951"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1968843256-1272401447=:2951
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Tue, 27 Apr 2010, John Kacur wrote:
> make O=/bld/2.6.33.3-rt16/ fs/ecryptfs/inode.o
>   Using /home/jkacur/jk-2.6 as source for kernel
>   GEN     /bld/2.6.33.3-rt16/Makefile
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    /home/jkacur/jk-2.6/scripts/checksyscalls.sh
>   CC [M]  fs/ecryptfs/inode.o
> /home/jkacur/jk-2.6/fs/ecryptfs/inode.c: In function 
> ¡ecryptfs_lookup_and_interpose_lower¢:
> /home/jkacur/jk-2.6/fs/ecryptfs/inode.c:266: error: wrong type argument to 
> unary exclamation mark
> make[2]: *** [fs/ecryptfs/inode.o] Error 1
> make[1]: *** [fs/ecryptfs/inode.o] Error 2
> make: *** [sub-make] Error 2
> 
> The above comes from: 
> commit 5c0eb5cec064ce26ffcd0cdd684c9b6dd7c9074e
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Fri Jan 29 15:38:21 2010 -0800

Half the truth :) It got not fixed up in a later patch which made
d_count atomic_t again. Fix below.

Thanks,

	tglx
---
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 2fb8fd1..23dc2af 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -263,7 +263,7 @@ int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
 				   ecryptfs_dentry->d_parent));
 	lower_inode = lower_dentry->d_inode;
 	fsstack_copy_attr_atime(ecryptfs_dir_inode, lower_dir_dentry->d_inode);
-	BUG_ON(!lower_dentry->d_count);
+	BUG_ON(!atomic_read(&lower_dentry->d_count));
 	ecryptfs_set_dentry_private(ecryptfs_dentry,
 				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
 						     GFP_KERNEL));
--8323328-1968843256-1272401447=:2951--
