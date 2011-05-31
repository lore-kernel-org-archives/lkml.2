Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1EaNuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1EaNuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:50:11 -0400
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 31 May 2011 14:51:36 +0100
Message-ID: <1306849896.2816.22.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2011-05-28 at 08:25 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Some recent benchmarking on btrfs showed that a major scaling bottleneck
> on large systems on btrfs is currently the xattr lookup on every write.
> 
> Why xattr lookup on every write I hear you ask?
> 
> write wants to drop suid and security related xattrs that could set o
> capabilities for executables.  To do that it currently looks up
> security.capability on EVERY write (even for non executables) to decide
> whether to drop it or not.
> 
It sounds like a good idea, but cluster filesystems will need to clear
the flag when they update their in-core inodes. Without that we could
have:

 Node A looks up inode and sets S_NOSEC since its not suid
 Node B does chmod +s on the inode
 Node A now has S_NOSEC set, but inode is suid, so writes don't clear
suid

For GFS2 it should simply be a case of adjusting gfs2_set_inode_flags()
to update S_NOSEC appropriately, something like this (untested):

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index a9f5cbe..3d856e4 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -174,7 +174,9 @@ void gfs2_set_inode_flags(struct inode *inode)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int flags = inode->i_flags;
 
-	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_NOSEC);
+	if (!is_sxid(inode->i_mode))
+		flags |= S_NOSEC;
 	if (ip->i_diskflags & GFS2_DIF_IMMUTABLE)
 		flags |= S_IMMUTABLE;
 	if (ip->i_diskflags & GFS2_DIF_APPENDONLY)


Note that this also serves the dual purpose of setting the flag for
newly created inodes as well, as per the patches for the other
filesystems,

Steve.


