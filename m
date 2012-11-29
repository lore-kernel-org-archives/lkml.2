Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2K2VdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:33:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56648 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2K2VdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:33:17 -0500
Date: Thu, 29 Nov 2012 21:33:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Patrick McLean <patrickm@gaikai.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression with initramfs and nfsroot (appears to be in the
 dcache)
Message-ID: <20121129213316.GU4939@ZenIV.linux.org.uk>
References: <CAE2NFgU+4QDcLaVE5dKDvZCxey7qEf7FAbYNjNmcjVU=HLhF=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE2NFgU+4QDcLaVE5dKDvZCxey7qEf7FAbYNjNmcjVU=HLhF=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:16:59AM -0800, Patrick McLean wrote:
> With 3.6-rc1 and up, when using a (dracut) initramfs with a read-only
> nfs root, all accesses to /proc. /sys and /dev return EBUSY.

See "[PATCH] Revert "__d_unalias() should refuse to move mountpoints"
thread.  If you have a convenient reproducer, could you check if
the fixes the breakage?  If so, we'll need to look into false negatives
from nfs_same_file() in there...

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ce8cb92..55436f5 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -450,7 +450,10 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry)
 			nfs_refresh_inode(dentry->d_inode, entry->fattr);
 			goto out;
 		} else {
-			d_drop(dentry);
+			if (d_invalidate(dentry) != 0) {
+				WARN_ON(1);
+				goto out;
+			}
 			dput(dentry);
 		}
 	}
