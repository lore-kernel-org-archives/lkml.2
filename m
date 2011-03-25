Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1CYX4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:56:04 -0400
Received: from kroah.org ([198.145.64.141]:41995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab1CYXxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:44 2011
Message-Id: <20110325234844.575654158@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>
Subject: [53/55] fs: call security_d_instantiate in d_obtain_alias V2
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1201,9 +1201,12 @@ struct dentry *d_obtain_alias(struct ino
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


