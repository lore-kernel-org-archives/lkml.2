Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1ASQpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:45:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33155 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753839Ab1ASQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:45:54 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/R8tIGHy7REv77Nvtldp4DDWUcbHZLuhiiKEo4b8
	R1zMMkMEkiVIZi
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/14] fsnotify: simplify locking
Date: Wed, 19 Jan 2011 17:42:03 +0100
Message-Id: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset simplifies some of the locking that is needed to handle the addition and 
removal of marks from groups and vfs objects (inodes, mounts). It applies against
commit ef9bf3b7144bee6ce1da5616015cabc8771206af of branch 
'origin/for-next' from git.infradead.org/users/eparis/notify.git


The recent locking order used in fsnotify is 

mark->lock
group->mark_lock
inode->i_lock

The problem is that we cant use the group->mark_lock to synchronize addition and 
removal of marks to/from a group, so we have to use an additional mutex, namely the 
group->mutex, for this purpose. 
We also need a dedicated kernel thread for mark destruction since we cant call 
synchronize() for the mark_srcu with a spinlock held (at least i assume that this 
is the main reason this thread exists).

The main goal of these patches is to change the locking order to 

group->mark_lock
inode->i_lock
mark->lock

and by this simplify the concerning code:
- use the group->mark_lock for group list iteration and addition/removal of marks
- call synchronize() for mark_srcu as soon as a mark is removed from its 
  fsobject and thus avoid the need for the "fsnotify_mark" thread
- avoid temporary lists for mark traversal 

 

