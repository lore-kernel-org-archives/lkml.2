Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab1IERCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:02:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43062 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1IERCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:02:08 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        autofs@linux.kernel.org
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
	<17416.1315240659@redhat.com>
Date: Mon, 05 Sep 2011 19:02:00 +0200
In-Reply-To: <17416.1315240659@redhat.com> (David Howells's message of "Mon,
	05 Sep 2011 17:37:39 +0100")
Message-ID: <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> After 2.6.38, with the introduction of the ->d_automount()
>> infrastructure, stat(2) and others would start triggering automount
>> while lstat(2), etc. still would not.  This is a regression and a
>> userspace ABI change.
>
> It doesn't necessarily mean it's wrong.  The main class of program that needs
> to be prevented from automounting are things that do bulk stat'ing (e.g. ls) -
> and they should probably be doing lstat() anyway.

Yeah, some of those uses are probably minor bugs in userspace, but there are
probably many of them (Leonardo reported that for example Nautilus also
triggers all child automounts in a directory).  So I don't think it's OK to
just change the behavior here.

If automounting on lstat(2) is the correct behavior (is it?  why?)  then at
least it should be enabled by a global switch or mount option, IMO.

>
>> +	/* We don't want to mount if someone's just doing a stat -
>> +	 * unless they're stat'ing a directory and appended a '/' to
>> +	 * the name.
>
> Btw, line length is 80 chars.  This comment could easily use one fewer line.
>
> If you use emacs you can do:
>
> 	ESC 7 9 C-x f
>
> to set the right margin and then:
>
> 	M-q
>
> whilst the cursor is in the comment paragraph to be rearranged and it will
> 'fill' the paragraph to 79 characters.

Cool.  Updated patch below.

Thanks,
Miklos
----


Subject: vfs: automount should ignore LOOKUP_FOLLOW

From: Miklos Szeredi <mszeredi@suse.cz>

Prior to 2.6.38 automount would not trigger on either stat(2) or
lstat(2) on the automount point.

After 2.6.38, with the introduction of the ->d_automount()
infrastructure, stat(2) and others would start triggering automount
while lstat(2), etc. still would not.  This is a regression and a
userspace ABI change.

Problem originally reported here:

  http://thread.gmane.org/gmane.linux.kernel.autofs/6098

It appears that there was an attempt at fixing various userspace tools
to not trigger the automount.  But since the stat system call is
rather common it is impossible to "fix" all userspace.

This patch reverts the original behavior, which is to not trigger on
stat(2) and other symlink following syscalls.

Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: David Howells <dhowells@redhat.com>
CC: Ian Kent <raven@themaw.net>
CC: stable@kernel.org
---
 fs/namei.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2011-09-05 18:01:59.000000000 +0200
+++ linux-2.6/fs/namei.c	2011-09-05 18:51:25.000000000 +0200
@@ -727,25 +727,21 @@ static int follow_automount(struct path
 	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_PARENT))
 		return -EISDIR; /* we actually want to stop here */
 
-	/*
-	 * We don't want to mount if someone's just doing a stat and they've
-	 * set AT_SYMLINK_NOFOLLOW - unless they're stat'ing a directory and
-	 * appended a '/' to the name.
+	/* We don't want to mount if someone's just doing a stat - unless
+	 * they're stat'ing a directory and appended a '/' to the name.
+	 *
+	 * We do, however, want to mount if someone wants to open or create a
+	 * file of any type under the mountpoint, wants to traverse through the
+	 * mountpoint or wants to open the mounted directory.  Also, autofs may
+	 * mark negative dentries as being automount points.  These will need
+	 * the attentions of the daemon to instantiate them before they can be
+	 * used.
 	 */
-	if (!(flags & LOOKUP_FOLLOW)) {
-		/* We do, however, want to mount if someone wants to open or
-		 * create a file of any type under the mountpoint, wants to
-		 * traverse through the mountpoint or wants to open the mounted
-		 * directory.
-		 * Also, autofs may mark negative dentries as being automount
-		 * points.  These will need the attentions of the daemon to
-		 * instantiate them before they can be used.
-		 */
-		if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
-			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
-		    path->dentry->d_inode)
-			return -EISDIR;
-	}
+	if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
+		     LOOKUP_OPEN | LOOKUP_CREATE)) &&
+	    path->dentry->d_inode)
+		return -EISDIR;
+
 	current->total_link_count++;
 	if (current->total_link_count >= 40)
 		return -ELOOP;
