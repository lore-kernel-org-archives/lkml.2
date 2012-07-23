Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2GWPUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:20:42 -0400
Received: from fieldses.org ([174.143.236.118]:48561 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab2GWPUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:20:40 -0400
Date: Mon, 23 Jul 2012 11:20:39 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: Remove easily user-triggerable BUG from generic_setlease
Message-ID: <20120723152038.GB623@fieldses.org>
References: <20120713173536.GB25432@redhat.com>
 <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyg7Cs5KF4HGQKAUi29+RpXJdUyEm6uy57rwVBB_jyN3Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:47:43AM -0700, Linus Torvalds wrote:
> On Fri, Jul 13, 2012 at 10:35 AM, Dave Jones <davej@redhat.com> wrote:
> > This can be trivially triggered from userspace by passing in something unexpected.
> 
> Argh. It looks like it would be harmless (apart from the noise),
> except we hold file_lock_lock. Which turns the BUG_ON() into not just
> "noise and kill the process", but "noise and kill the process and
> leave a nasty lock held".
> 
> This seems to go back to 3.2, so stable should be cc'd, no?

Thanks!  Yes, this fixes the bug for >=3.2, but before the addition of
this BUG() we could get memory corruption in this case.  And that
problem existed since the original introduction of the lease code, as
far as I can tell.

So we need something like the following, backported to 2.6.anything.

--b.

commit 76fca57d7f4e408fc758a42f798c2ebef54be60f
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Wed Jul 18 17:45:42 2012 -0600

    locks: fix checking of fcntl_setlease argument
    
    The only checks of the long argument passed to fcntl(fd,F_SETLEASE,.)
    are done after converting the long to an int.  Thus some illegal values
    may be let through and cause problems in later code.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

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
