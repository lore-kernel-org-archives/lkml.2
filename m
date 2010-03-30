Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0CaAbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:31:35 -0400
Received: from kroah.org ([198.145.64.141]:48823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab0C3XMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:07 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:19 2010
Message-Id: <20100330225818.747869908@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [17/89] inotify: do not reuse watch descriptors
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 9e572cc9877ee6c43af60778f6b8d5ba0692d935 upstream.

Since commit 7e790dd5fc937bc8d2400c30a05e32a9e9eef276 ("inotify: fix
error paths in inotify_update_watch") inotify changed the manor in which
it gave watch descriptors back to userspace.  Previous to this commit
inotify acted like the following:

  inotify_add_watch(X, Y, Z) = 1
  inotify_rm_watch(X, 1);
  inotify_add_watch(X, Y, Z) = 2

but after this patch inotify would return watch descriptors like so:

  inotify_add_watch(X, Y, Z) = 1
  inotify_rm_watch(X, 1);
  inotify_add_watch(X, Y, Z) = 1

which I saw as equivalent to opening an fd where

  open(file) = 1;
  close(1);
  open(file) = 1;

seemed perfectly reasonable.  The issue is that quite a bit of userspace
apparently relies on the behavior in which watch descriptors will not be
quickly reused.  KDE relies on it, I know some selinux packages rely on
it, and I have heard complaints from other random sources such as debian
bug 558981.

Although the man page implies what we do is ok, we broke userspace so
this patch almost reverts us to the old behavior.  It is still slightly
racey and I have patches that would fix that, but they are rather large
and this will fix it for all real world cases.  The race is as follows:

 - task1 creates a watch and blocks in idr_new_watch() before it updates
   the hint.
 - task2 creates a watch and updates the hint.
 - task1 updates the hint with it's older wd
 - task removes the watch created by task2
 - task adds a new watch and will reuse the wd originally given to task2

it requires moving some locking around the hint (last_wd) but this should
solve it for the real world and be -stable safe.

As a side effect this patch papers over a bug in the lib/idr code which
is causing a large number WARN's to pop on people's system and many
reports in kerneloops.org.  I'm working on the root cause of that idr
bug seperately but this should make inotify immune to that issue.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -558,7 +558,7 @@ retry:
 
 	spin_lock(&group->inotify_data.idr_lock);
 	ret = idr_get_new_above(&group->inotify_data.idr, &tmp_ientry->fsn_entry,
-				group->inotify_data.last_wd,
+				group->inotify_data.last_wd+1,
 				&tmp_ientry->wd);
 	spin_unlock(&group->inotify_data.idr_lock);
 	if (ret) {
@@ -638,7 +638,7 @@ static struct fsnotify_group *inotify_ne
 
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
-	group->inotify_data.last_wd = 1;
+	group->inotify_data.last_wd = 0;
 	group->inotify_data.user = user;
 	group->inotify_data.fa = NULL;
 


