Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0CaAOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:14:52 -0400
Received: from kroah.org ([198.145.64.141]:51849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783Ab0C3XRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:42 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:14 2010
Message-Id: <20100330225613.865124516@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
       Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, maximilian attems <max@stro.at>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [025/116] coredump: suppress uid comparison test if core output files are pipes
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 76595f79d76fbe6267a51b3a866a028d150f06d4 upstream.

Modify uid check in do_coredump so as to not apply it in the case of
pipes.

This just got noticed in testing.  The end of do_coredump validates the
uid of the inode for the created file against the uid of the crashing
process to ensure that no one can pre-create a core file with different
ownership and grab the information contained in the core when they
shouldn' tbe able to.  This causes failures when using pipes for a core
dumps if the crashing process is not root, which is the uid of the pipe
when it is created.

The fix is simple.  Since the check for matching uid's isn't relevant for
pipes (a process can't create a pipe that the uermodehelper code will open
anyway), we can just just skip it in the event ispipe is non-zero

Reverts a pipe-affecting change which was accidentally made in

: commit c46f739dd39db3b07ab5deb4e3ec81e1c04a91af
: Author:     Ingo Molnar <mingo@elte.hu>
: AuthorDate: Wed Nov 28 13:59:18 2007 +0100
: Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
: CommitDate: Wed Nov 28 10:58:01 2007 -0800
:
:     vfs: coredumping fix

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1913,8 +1913,9 @@ void do_coredump(long signr, int exit_co
 	/*
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
+	 * Note, this is not relevant for pipes
 	 */
-	if (inode->i_uid != current_fsuid())
+	if (!ispipe && (inode->i_uid != current_fsuid()))
 		goto close_fail;
 	if (!file->f_op)
 		goto close_fail;


