Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1CPHJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 03:09:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43441 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1CPHJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 03:09:33 -0400
Date: Wed, 16 Mar 2011 18:09:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (vfs tree
 related)
Message-Id: <20110316180927.701543d5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

fs/fcntl.c: In function 'fcntl_init':
fs/fcntl.c:838: error: size of array 'type name' is negative

This is:

        BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
                O_RDONLY        | O_WRONLY      | O_RDWR        |
                O_CREAT         | O_EXCL        | O_NOCTTY      |
                O_TRUNC         | O_APPEND      | /* O_NONBLOCK | */
                __O_SYNC        | O_DSYNC       | FASYNC        |
                O_DIRECT        | O_LARGEFILE   | O_DIRECTORY   |
                O_NOFOLLOW      | O_NOATIME     | O_CLOEXEC     |
                __FMODE_EXEC    | O_PATH
                ));

in fcntl_init().

Caused by commit 1abf0c718f15 ("New kind of open files - "location
only".") from the vfs tree.  The new O_PATH valuse clashes with O_NOATIME
on sparc and O_CLOEXEC on alpha and parisc.

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 Mar 2011 18:02:46 +1100
Subject: [PATCH] vfs: add nonconflicting values for O_PATH

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/alpha/include/asm/fcntl.h  |    2 ++
 arch/parisc/include/asm/fcntl.h |    2 ++
 arch/sparc/include/asm/fcntl.h  |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index 70145cb..1b71ca7 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -31,6 +31,8 @@
 #define __O_SYNC	020000000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 
+#define O_PATH		040000000
+
 #define F_GETLK		7
 #define F_SETLK		8
 #define F_SETLKW	9
diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
index f357fc6..0304b92 100644
--- a/arch/parisc/include/asm/fcntl.h
+++ b/arch/parisc/include/asm/fcntl.h
@@ -19,6 +19,8 @@
 #define O_NOFOLLOW	000000200 /* don't follow links */
 #define O_INVISIBLE	004000000 /* invisible I/O, for DMAPI/XDSM */
 
+#define O_PATH		020000000
+
 #define F_GETLK64	8
 #define F_SETLK64	9
 #define F_SETLKW64	10
diff --git a/arch/sparc/include/asm/fcntl.h b/arch/sparc/include/asm/fcntl.h
index 38f37b33..d0b83f6 100644
--- a/arch/sparc/include/asm/fcntl.h
+++ b/arch/sparc/include/asm/fcntl.h
@@ -34,6 +34,8 @@
 #define __O_SYNC	0x800000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 
+#define O_PATH		0x1000000
+
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
 #define F_GETLK		7
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
