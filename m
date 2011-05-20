Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935372Ab1ETFzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:55:18 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:46029 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933928Ab1ETFzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:55:16 -0400
X-Greylist: delayed 923 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 May 2011 01:55:16 EDT
X-ASG-Debug-ID: 1305870913-01c65a06b0169320001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
X-Barracuda-BWL-IP: 192.168.1.133
X-Barracuda-BBL-IP: 192.168.1.133
X-Barracuda-RBL-IP: 192.168.1.133
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
Content-Type: text/plain; charset=us-ascii
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
Date: Fri, 20 May 2011 01:55:12 -0400
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        mszeredi@suse.cz, Erez Zadok <ezk@fsl.cs.sunysb.edu>
Content-Transfer-Encoding: 8BIT
Message-Id: <B0729E4C-D581-4EAB-A175-A6B8B34692B5@fsl.cs.sunysb.edu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu> <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1305870913
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

On May 20, 2011, at 1:39 AM, Erez Zadok wrote:

> Miklos,
> 
> I tried your overlayfs.v9 git repo w/ racer, using two separate ext3 filesystems (one for lowerdir and another for upperdir).  I got the WARN_ON in ovl_permission to trigger within about 10 minutes of testing.  Looking at the code, I see a problem in returning w/o cleaning up an dput-ing the alias dentry.  Simple patch enclosed below.
> 
> Cheers,
> Erez.

Niklos, I forgot to mention that I had to apply a small fix to a VFS bug in fs/namei.c:1362, where a mix of symlinks and renames, using racer, triggers an BUG_ON at the VFS layer (very reproducible).  Without this fix, racer oopses in the VFS well before it gets to trigger overlayfs bugs.  It's a pity 2.6.39 was released with this very reproducible *VFS* level bug (doesn't anyone run racer+fsx+ltp before releasing a new kernel?)

Anyway, here's the small patch here.  Clearly viro/hch need to review this "fix" b/c I'm not sure it's really the right one

Cheers,
Erez.


VFS: move BUG_ON test for symlink nd->depth after current->link_count test

This solves a bug in nested_symlink (which was rewritten from
do_follow_link), and follows the order of depth tests that existed before.
The bug triggers a BUG_ON in fs/namei.c:1346, when running racer with
symlink and rename ops.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
diff --git a/fs/namei.c b/fs/namei.c
index 017c3fa..7a93387 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1343,12 +1343,12 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
 {
 	int res;
 
-	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
 	if (unlikely(current->link_count >= MAX_NESTED_LINKS)) {
 		path_put_conditional(path, nd);
 		path_put(&nd->path);
 		return -ELOOP;
 	}
+	BUG_ON(nd->depth >= MAX_NESTED_LINKS);
 
 	nd->depth++;
 	current->link_count++;


