Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2C1MkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:40:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64967 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2C1MkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:40:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203280023040.16201@chino.kir.corp.google.com>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
	<20120322003356.GT6589@ZenIV.linux.org.uk>
	<CAJd=RBC=ajApxw_+tfOoY9KpTNW2Y+_B5MxDOjBH3Y5-PDW2jg@mail.gmail.com>
	<alpine.DEB.2.00.1203280023040.16201@chino.kir.corp.google.com>
Date: Wed, 28 Mar 2012 20:40:17 +0800
Message-ID: <CAJd=RBDebqODA+unGkZK5TpdBjZyMVafuPR6uQzm7nA_F5HcxA@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
From: Hillf Danton <dhillf@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 3:24 PM, David Rientjes <rientjes@google.com> wrote:
>
> The patch is still in linux-next as of yesterday's tree, so please propose
> a follow-up patch that removes the unregister_filesystem() since the
> setting of "error" when kmem_cache_create() is still correct.

Ah the window is still open.

Thanks
-hd

===cut here===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] hugetlbfs: remove unregister_filesystem when
initializing module

It is introduced by

	commit	d1d5e05ffdc110021ae7937802e88ae0d223dcdc
	hugetlbfs: return error code when initializing module

but as Al pointed out, is an example of bad idea.

Quoted comments from Al.
Note that unregister_filesystem() in module init is *always* wrong; it's not
an issue here (it's done too early to care about and realistically the box
is not going anywhere - it'll panic when attempt to exec /sbin/init fails,
if not earlier), but it's a damn bad example.

Consider a normal fs module.  Somebody loads it and in parallel with that
we get a mount attempt on that fs type.  It comes between register and
failure exits that causes unregister; at that point we are screwed since
grabbing a reference to module as done by mount is enough to prevent
exit, but not to prevent the failure of init.  As the result, module will
get freed when init fails, mounted fs of that type be damned.
end of quote

So remove it.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/fs/hugetlbfs/inode.c	Wed Mar 28 20:15:24 2012
+++ b/fs/hugetlbfs/inode.c	Wed Mar 28 20:17:46 2012
@@ -1032,7 +1032,6 @@ static int __init init_hugetlbfs_fs(void
 	}

 	error = PTR_ERR(vfsmount);
-	unregister_filesystem(&hugetlbfs_fs_type);

  out:
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
--
