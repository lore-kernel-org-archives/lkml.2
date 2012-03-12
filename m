Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2CLMBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:01:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62895 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2CLMBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203111322550.20299@chino.kir.corp.google.com>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
	<CAJd=RBB3202WV4zJratpp8c8VjkipNEbB_p9bGjLKrxr7qL-RA@mail.gmail.com>
	<alpine.DEB.2.00.1203111322550.20299@chino.kir.corp.google.com>
Date: Mon, 12 Mar 2012 20:01:43 +0800
Message-ID: <CAJd=RBBn35FU99qoXwmPx+FK6=Vt-DXsCje3bAXYB+GrvR9hPg@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
From: Hillf Danton <dhillf@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 4:25 AM, David Rientjes <rientjes@google.com> wrote:
>
> The patch looks good, however, we typically do things like
>
>        error = -ENOMEM;
>        hugetlbfs_inode_cachep = kmem_cache_create(...);
>        if (!hugetlbfs_inode_cachep)
>                ...
>
> instead.  Sometimes people grep to see if a call a function that can fail,
> such as kmem_cache_create(), is followed up by a check for NULL and this
> would otherwise fail.
>
>
It is updated, thanks David.

-hd
===cut here===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] hugetlbfs: add err code in initilizing module

Error code is added if fail to create inode kmem cache, and newly registered
hugetlb FS is unregistered if fail to mount, both for unlikely corner cases.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/fs/hugetlbfs/inode.c	Sun Mar 11 12:46:38 2012
+++ b/fs/hugetlbfs/inode.c	Mon Mar 12 19:52:16 2012
@@ -997,6 +997,7 @@ static int __init init_hugetlbfs_fs(void
 	if (error)
 		return error;

+	error = -ENOMEM;
 	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
 					sizeof(struct hugetlbfs_inode_info),
 					0, 0, init_once);
@@ -1015,6 +1016,7 @@ static int __init init_hugetlbfs_fs(void
 	}

 	error = PTR_ERR(vfsmount);
+	unregister_filesystem(&hugetlbfs_fs_type);

  out:
 	if (error)
--
