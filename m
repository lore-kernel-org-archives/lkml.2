Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2GWTRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:17:20 -0400
Received: from fieldses.org ([174.143.236.118]:45627 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab2GWTRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:17:18 -0400
Date: Mon, 23 Jul 2012 15:17:17 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH] locks: fix checking of fcntl_setlease argument
Message-ID: <20120723191717.GB2703@fieldses.org>
References: <20120713173536.GB25432@redhat.com>
 <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
 <20120723152038.GB623@fieldses.org>
 <CA+55aFxGuoxbdxy3uKX063vZ1xSRhshRyWf_UhMnDL_by7j9Sg@mail.gmail.com>
 <20120723190422.GA2703@fieldses.org>
 <CA+55aFwteHEnWm9ejmPoWZXTqjum1pC9fM6sKV_mRHGo2oorpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwteHEnWm9ejmPoWZXTqjum1pC9fM6sKV_mRHGo2oorpA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only checks of the long argument passed to fcntl(fd,F_SETLEASE,.)
are done after converting the long to an int.  Thus some illegal values
may be let through and cause problems in later code.

(They actually *don't* cause problems in mainline, as of Dave Jones's
8d657eb3b43861064d36241e88d9d61c709f33f0 "Remove easily user-triggerable
BUG from generic_setlease", but we should fix this anyway.  And this
patch will be necessary to fix real bugs on earlier kernels.)

Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/locks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

On Mon, Jul 23, 2012 at 12:09:21PM -0700, Linus Torvalds wrote:
> NEVER EVER add BUG() as a "well, that was unexpected". That way lies
> exactly the kinds of denial-of-service attacks that that BUG() caused.

OK, makes sense.  Resending the patch to make it clear it's intended for
mainline as well.--b.

diff --git a/fs/locks.c b/fs/locks.c
index 43797a9..ad1de47 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -311,7 +311,7 @@ static int flock_make_lock(struct file *filp, struct file_lock **lock,
 	return 0;
 }
 
-static int assign_type(struct file_lock *fl, int type)
+static int assign_type(struct file_lock *fl, long type)
 {
 	switch (type) {
 	case F_RDLCK:
@@ -448,7 +448,7 @@ static const struct lock_manager_operations lease_manager_ops = {
 /*
  * Initialize a lease, use the default lock manager operations
  */
-static int lease_init(struct file *filp, int type, struct file_lock *fl)
+static int lease_init(struct file *filp, long type, struct file_lock *fl)
  {
 	if (assign_type(fl, type) != 0)
 		return -EINVAL;
@@ -466,7 +466,7 @@ static int lease_init(struct file *filp, int type, struct file_lock *fl)
 }
 
 /* Allocate a file_lock initialised to this type of lease */
-static struct file_lock *lease_alloc(struct file *filp, int type)
+static struct file_lock *lease_alloc(struct file *filp, long type)
 {
 	struct file_lock *fl = locks_alloc_lock();
 	int error = -ENOMEM;
-- 
1.7.9.5

