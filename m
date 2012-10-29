Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139Ab2J2WWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:22:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:47043 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092Ab2J2Vgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nick Bowler <nbowler@elliptictech.com>,
        Holger Kiehl <Holger.Kiehl@dwd.de>, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Theodore Tso <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 005/101] VFS: dont do protected {sym,hard}links by default
Date: Mon, 29 Oct 2012 14:34:18 -0700
Message-Id: <20121029213240.753499989@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 561ec64ae67ef25cac8d72bb9c4bfc955edfd415 upstream.

In commit 800179c9b8a1 ("This adds symlink and hardlink restrictions to
the Linux VFS"), the new link protections were enabled by default, in
the hope that no actual application would care, despite it being
technically against legacy UNIX (and documented POSIX) behavior.

However, it does turn out to break some applications.  It's rare, and
it's unfortunate, but it's unacceptable to break existing systems, so
we'll have to default to legacy behavior.

In particular, it has broken the way AFD distributes files, see

  http://www.dwd.de/AFD/

along with some legacy scripts.

Distributions can end up setting this at initrd time or in system
scripts: if you have security problems due to link attacks during your
early boot sequence, you have bigger problems than some kernel sysctl
setting. Do:

	echo 1 > /proc/sys/fs/protected_symlinks
	echo 1 > /proc/sys/fs/protected_hardlinks

to re-enable the link protections.

Alternatively, we may at some point introduce a kernel config option
that sets these kinds of "more secure but not traditional" behavioural
options automatically.

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -651,8 +651,8 @@ static inline void put_link(struct namei
 	path_put(link);
 }
 
-int sysctl_protected_symlinks __read_mostly = 1;
-int sysctl_protected_hardlinks __read_mostly = 1;
+int sysctl_protected_symlinks __read_mostly = 0;
+int sysctl_protected_hardlinks __read_mostly = 0;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations


