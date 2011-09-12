Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1ILHhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:37:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1ILHhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:37:13 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fuse: fix flock breakage
References: <877h5ez07p.fsf@tucsk.pomaz.szeredi.hu>
Date: Mon, 12 Sep 2011 09:31:49 +0200
In-Reply-To: <877h5ez07p.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Mon, 12 Sep 2011 09:30:50 +0200")
Message-ID: <8739g2z062.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Commit 37fb3a30b4 "fuse: fix flock" added in 3.1-rc4 caused flock() to
fail with ENOSYS with the kernel ABI version 7.16 or earlier.

Fix by falling back to testing FUSE_POSIX_LOCKS for ABI versions 7.16
and earlier.

Reported-by: Martin Ziegler <ziegler@email.mathematik.uni-freiburg.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Martin Ziegler <ziegler@email.mathematik.uni-freiburg.de>
---
 fs/fuse/inode.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2011-09-07 11:40:36.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2011-09-09 12:02:29.000000000 +0200
@@ -812,6 +812,9 @@ static void process_init_reply(struct fu
 			if (arg->minor >= 17) {
 				if (!(arg->flags & FUSE_FLOCK_LOCKS))
 					fc->no_flock = 1;
+			} else {
+				if (!(arg->flags & FUSE_POSIX_LOCKS))
+					fc->no_flock = 1;
 			}
 			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
 				fc->atomic_o_trunc = 1;
