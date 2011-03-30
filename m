Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab1C3VS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:18:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:30854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965223Ab1C3VJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727134000"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: josef@redhat.com, viro@zeniv.linux.org.uk, ak@linux.intel.com,
        cebbert@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [241/275] fs: call security_d_instantiate in d_obtain_alias V2
Message-Id: <20110330210807.73A2C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Josef Bacik <josef@redhat.com>

commit 24ff6663ccfdaf088dfa7acae489cb11ed4f43c4 upstream.

While trying to track down some NFS problems with BTRFS, I kept noticing I was
getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
figure out that it was SELinux that was giving me grief, with the following
denial

type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=file

Turns out this is because in d_obtain_alias if we can't find an alias we create
one and do all the normal instantiation stuff, but we don't do the
security_d_instantiate.

Usually we are protected from getting a hashed dentry that hasn't yet run
security_d_instantiate() by the parent's i_mutex, but obviously this isn't an
option there, so in order to deal with the case that a second thread comes in
and finds our new dentry before we get to run security_d_instantiate(), we go
ahead and call it if we find a dentry already.  Eric assures me that this is ok
as the code checks to see if the dentry has been initialized already so calling
security_d_instantiate() against the same dentry multiple times is ok.  With
this patch I'm no longer getting errant -EACCESS values.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/fs/dcache.c
===================================================================
--- linux-2.6.35.y.orig/fs/dcache.c	2011-03-29 22:50:16.864826890 -0700
+++ linux-2.6.35.y/fs/dcache.c	2011-03-29 23:03:03.231217492 -0700
@@ -1186,9 +1186,12 @@
 	spin_unlock(&tmp->d_lock);
 
 	spin_unlock(&dcache_lock);
+	security_d_instantiate(tmp, inode);
 	return tmp;
 
  out_iput:
+	if (res && !IS_ERR(res))
+		security_d_instantiate(res, inode);
 	iput(inode);
 	return res;
 }
