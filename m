Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1ETF7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:59:03 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:46063 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab1ETF7A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:59:00 -0400
X-ASG-Debug-ID: 1305871138-01c65a06b0169360001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 5/7] overlay filesystem (negative dentries cause OOPS on NULL inode)
X-Barracuda-BWL-IP: 192.168.1.133
X-Barracuda-BBL-IP: 192.168.1.133
X-Barracuda-RBL-IP: 192.168.1.133
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 5/7] overlay filesystem (negative dentries cause OOPS on NULL inode)
Content-Type: text/plain; charset=windows-1252
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
Date: Fri, 20 May 2011 01:58:57 -0400
Cc: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>, "neilb@suse.de" <neilb@suse.de>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Transfer-Encoding: 8BIT
Message-Id: <C72E7C64-5283-4707-9623-A372710115AD@fsl.cs.sunysb.edu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1305871138
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64258
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

I  continued to test your overlayfs.v9 git repo w/ racer, using two separate empty ext3 filesystems (one for lowerdir and another for upperdir).  I got a couple of NULL derefs in different places.  Both appear to be due to negative dentries being passed around, where the code using them assumes a positive dentry.

The first is in ovl_getattr().  The realpath.dentry->d_inode can apparently be NULL after calling ovl_path_real, and when  that's passed to vfs_getattr, the NULL inode is deref'ed in security_inode_getattr (calling IS_PRIVATE on the inode).  I verified it by sticking the BUG_ON(!inode), seeing it triggered, and then replaced it with "if (!inode) return -ENOENT".  After that, racer didn't trigger this bug, but I don't know if returning ENOENT is correct there.  There may be a more fundamental problem in that the lower dentry in ovl_getattr should never be negative.

The second instance of a similar problem is in ovl_follow_link.  Again, here realinode can be NULL, causing the WARN_ON(!realinode->…) to oops.  I verified this by placing a BUG_ON, triggering it, and then adding some code to return NULL if the realinode is NULL.  As with the first instance, I don't know if this is correct either.  But I include a simple patch below.

With these two fixes, the error-path bug in ovl_permission, and the fs/namei.c:1362 bug, racer ran for 60 minutes without triggering an OOPS.

Cheers,
Erez.


diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3c15d54..6c70f57 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -42,6 +42,8 @@ static int ovl_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct path realpath;
 
 	ovl_path_real(dentry, &realpath);
+	if (!realpath.dentry->d_inode)
+		return -ENOENT;
 	return vfs_getattr(realpath.mnt, realpath.dentry, stat);
 }
 
@@ -127,6 +130,9 @@ static void *ovl_follow_link(struct dentry *dentry, struct nameidata *nd)
 
 	realdentry = ovl_dentry_real(dentry);
 	realinode = realdentry->d_inode;
+	if (!realinode)
+		return NULL;
 
 	if (WARN_ON(!realinode->i_op->follow_link))
 		return ERR_PTR(-EPERM);

