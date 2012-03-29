Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2C2FYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:24:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:40306 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2C2FYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=MBOWfnaO+SV3Yk0OTJGjXhWRa
	Qobhpn8tQ1GIpE7fu31jMPPaxWFCav4Tq93MzQuC32ASQv0fHCrvZin5MCpn0qKR
	R0pk3SSgoSS4MKk0OVp2UyqE43FmIHMAKxWv40B7Y2/P2JI+aEtRo6jFEhpLrU7b
	TeLYHdnCrkaCmoNaV4=
Date: Wed, 28 Mar 2012 22:23:56 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, ericvh@gmail.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 13/16] ceph: implement i_op->atomic_open() and
 i_op->atomic_create()
In-Reply-To: <1332966285-30358-14-git-send-email-miklos@szeredi.hu>
Message-ID: <Pine.LNX.4.64.1203282211360.9468@cobra.newdream.net>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
 <1332966285-30358-14-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

I was pleasantly surprised to find that this works as-is.  I simplified 
this to call ceph_lookup_open for the atomic O_CREAT case as well, and it 
passes my basic battery of tests.  An incremental patch is below.

I haven't looked closely at the vfs bits, but from an fs perspective this 
series looks good to me!

Thanks-
sage




diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 75df600..9d679dd 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -642,37 +642,17 @@ struct file *ceph_atomic_open(struct inode *dir, struct dentry *dentry,
        struct dentry *res = NULL;
        struct file *filp;
 
-       if (!(flags & O_CREAT)) {
-               if (dentry->d_name.len > NAME_MAX)
-                       return ERR_PTR(-ENAMETOOLONG);
-
-               err = ceph_init_dentry(dentry);
-               if (err < 0)
-                       return ERR_PTR(err);
-
-               return ceph_lookup_open(dir, dentry, od, flags, mode);
-       }
-
-       if (d_unhashed(dentry)) {
-               res = ceph_lookup(dir, dentry, NULL);
-               if (IS_ERR(res))
-                       return ERR_CAST(res);
-
-               if (res)
-                       dentry = res;
-       }
+       dout("atomic_open %p dentry %p '%.*s'\n",
+            dir, dentry, dentry->d_name.len, dentry->d_name.name);
 
-       /* We don't deal with positive dentries here */
-       if (dentry->d_inode) {
-               finish_no_open(od, res);
-               return NULL;
-       }
+       if (dentry->d_name.len > NAME_MAX)
+               return ERR_PTR(-ENAMETOOLONG);
 
-       *created = true;
-       filp = ceph_lookup_open(dir, dentry, od, flags, mode);
-       dput(res);
+       err = ceph_init_dentry(dentry);
+       if (err < 0)
+               return ERR_PTR(err);
 
-       return filp;
+       return ceph_lookup_open(dir, dentry, od, flags, mode);
 }
 
 /*
