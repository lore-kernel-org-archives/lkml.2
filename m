Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031166Ab2HGW4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:56:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031106Ab2HGWqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 14/49] locks: fix checking of fcntl_setlease argument
Date: Tue,  7 Aug 2012 15:44:32 -0700
Message-Id: <20120807222028.144240974@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -315,7 +315,7 @@ static int flock_make_lock(struct file *
 	return 0;
 }
 
-static int assign_type(struct file_lock *fl, int type)
+static int assign_type(struct file_lock *fl, long type)
 {
 	switch (type) {
 	case F_RDLCK:
@@ -452,7 +452,7 @@ static const struct lock_manager_operati
 /*
  * Initialize a lease, use the default lock manager operations
  */
-static int lease_init(struct file *filp, int type, struct file_lock *fl)
+static int lease_init(struct file *filp, long type, struct file_lock *fl)
  {
 	if (assign_type(fl, type) != 0)
 		return -EINVAL;
@@ -470,7 +470,7 @@ static int lease_init(struct file *filp,
 }
 
 /* Allocate a file_lock initialised to this type of lease */
-static struct file_lock *lease_alloc(struct file *filp, int type)
+static struct file_lock *lease_alloc(struct file *filp, long type)
 {
 	struct file_lock *fl = locks_alloc_lock();
 	int error = -ENOMEM;


