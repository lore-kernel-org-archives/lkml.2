Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1BKKkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:40:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34768 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751127Ab1BKKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:36 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+XK050NDWXJ25m345Z7hSgmdc/O90Mqk3Q3akqKV
	YxGeHJNyOQc7Yz
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/7] fsnotify: use a groups mark_mutex to synchronize access to its mark list
Date: Fri, 11 Feb 2011 11:36:36 +0100
Message-Id: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series eliminates the need for the fsnotify group mutex which is
currently needed to ensure race free addition and removal to groups mark lists.
For this reason the locking order required to add or remove marks is turned from

1. mark lock
2. group mark_lock
3. inode/vfsmount lock

to

1. group mark_lock
2. mark lock
3. inode/vfsmount lock

Furthermore the group mark lock is turned from a spin lock to a mutex.
The patches apply against commit ef9bf3b7144bee6ce1da5616015cabc8771206af of
branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git


[PATCH 1/7] fsnotify: take groups mark_lock before mark lock
Change locking order (see above).

[PATCH 2/7] fanotify: add an extra flag to mark_remove_from_mask that indicates wheather a mark could be destroyed
Add an extra flag to mark_remove_from_mask that indicates whether a mark could
be destroyed. This is in preparation for the next patches.

[PATCH 3/7] fsnotify: introduce fsnotify_remove_mark()
Introduce a new function fsnotify_remove_mark() which is a counterpart to
fsnotify_add_mark().

[PATCH 4/7] fsnotify: replace most calls of fsnotify_destroy_mark() with fsnotify_remove_mark()
Replace calls to fsnotify_destroy_mark() with calls to fsnotify_remove_mark().
This concerns all calls to destroy_mark() with exception of the ones called from
a disappearing fsobject.
  
[PATCH 5/7] fsnotify: use a mutex instead of a spinlock to protect a groups mark list
Turn the mark_list spinlock into a mutex.

[PATCH 6/7] fsnotify: introduce locked versions of fsnotify_add_mark() and fsnotify_remove_mark()
Introduced _locked versions of fsnotify_[add|remove]_mark that assume that the
mark list mutex is already held. This enables the caller to do custom tasks
while the mark list is protected.

[PATCH 7/7] fsnotify: replace the groups mutex with the groups mark list mutex
Replace the group mutex with the mark_list mutex and call the _locked() version of
fsnotify_[add|remove]_mark() while the mutex is held.


