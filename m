Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1BVJO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:14:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55007 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1BVJOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:14:23 -0500
Date: Tue, 22 Feb 2011 01:14:16 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: npiggin@kernel.dk, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: OOPS in configfs when doing d_delete
Message-ID: <20110222091415.GD30966@noexit>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>
References: <4D623C62.8030509@suse.cz>
 <20110221104359.GA18538@noexit>
 <4D6242AD.2090600@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6242AD.2090600@suse.cz>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 11:47:09AM +0100, Jiri Slaby wrote:
> > 	I think you're right about the superfluous test, but I need more
> > investigation to see what's going on.  Thanks for the report.
> > 	What was causing attach_group() to fail?  Do you know?
> 
> Dunno, I just modprobe'd the configfs example from Doc dir
> (configfs_example_macros).

	I'm going to revisit the failed example (which shouldn't fail, I
would think).  Can you try the following patch to safely handle the
failure rather than crashing the kernel?

Joel

>From 68bbb327c48fdcdc48b71435d19b9e899745adf0 Mon Sep 17 00:00:00 2001
From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 01:09:49 -0800
Subject: [PATCH] configfs: Don't try to d_delete() negative dentries.

When configfs is faking mkdir() on its subsystem or default group
objects, it starts by adding a negative dentry.  It then tries to
instantiate the group.  If that should fail, it must clean up after
itself.

I was using d_delete() here, but configfs_attach_group() promises to
return an empty dentry on error.  d_delete() explodes with the entry
dentry.  Let's try d_drop() instead.  The unhashing is what we want for
our dentry.

Signed-off-by: Joel Becker <jlbec@evilplan.org>
---
 fs/configfs/dir.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 90ff3cb..2af26b8 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -689,7 +689,8 @@ static int create_default_group(struct config_group *parent_group,
 			sd = child->d_fsdata;
 			sd->s_type |= CONFIGFS_USET_DEFAULT;
 		} else {
-			d_delete(child);
+			BUG_ON(child->d_inode);
+			d_drop(child);
 			dput(child);
 		}
 	}
@@ -1683,7 +1684,8 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 		err = configfs_attach_group(sd->s_element, &group->cg_item,
 					    dentry);
 		if (err) {
-			d_delete(dentry);
+			BUG_ON(dentry->d_inode);
+			d_drop(dentry);
 			dput(dentry);
 		} else {
 			spin_lock(&configfs_dirent_lock);
-- 
1.7.3.1


-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

			http://www.jlbec.org/
			jlbec@evilplan.org
