Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab2GaFD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:03:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436Ab2GaEuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:17 -0400
Message-Id: <20120731044321.935043336@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@fieldses.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 66/73] locks: fix checking of fcntl_setlease argument
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@fieldses.org>

commit 0ec4f431eb56d633da3a55da67d5c4b88886ccc7 upstream.

The only checks of the long argument passed to fcntl(fd,F_SETLEASE,.)
are done after converting the long to an int.  Thus some illegal values
may be let through and cause problems in later code.

[ They actually *don't* cause problems in mainline, as of Dave Jones's
  commit 8d657eb3b438 "Remove easily user-triggerable BUG from
  generic_setlease", but we should fix this anyway.  And this patch will
  be necessary to fix real bugs on earlier kernels. ]

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/locks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index fce6238..82c3533 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -308,7 +308,7 @@ static int flock_make_lock(struct file *filp, struct file_lock **lock,
 	return 0;
 }
 
-static int assign_type(struct file_lock *fl, int type)
+static int assign_type(struct file_lock *fl, long type)
 {
 	switch (type) {
 	case F_RDLCK:
@@ -445,7 +445,7 @@ static const struct lock_manager_operations lease_manager_ops = {
 /*
  * Initialize a lease, use the default lock manager operations
  */
-static int lease_init(struct file *filp, int type, struct file_lock *fl)
+static int lease_init(struct file *filp, long type, struct file_lock *fl)
  {
 	if (assign_type(fl, type) != 0)
 		return -EINVAL;
@@ -463,7 +463,7 @@ static int lease_init(struct file *filp, int type, struct file_lock *fl)
 }
 
 /* Allocate a file_lock initialised to this type of lease */
-static struct file_lock *lease_alloc(struct file *filp, int type)
+static struct file_lock *lease_alloc(struct file *filp, long type)
 {
 	struct file_lock *fl = locks_alloc_lock();
 	int error = -ENOMEM;


