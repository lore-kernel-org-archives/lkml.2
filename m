Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1I0Wan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 18:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1I0Wam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 18:30:42 -0400
From: Doug Ledford <dledford@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com
Subject: Various cleanups and a couple fixes to ipc/mqueue
Date: Tue, 27 Sep 2011 18:30:09 -0400
Message-Id: <1317162613-11060-1-git-send-email-dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a customer come up with a problem while trying to upgrade from
our 2.6.18 kernel to our 2.6.32 kernel.  In diagnosing their problem,
it was determined that when commit b231cca4 changed the msg size max
from INT_MAX to 8192*128, that's what broke their setup.  While fixing
this problem, testing showed that if you increase the max values of a
msg queue, then attempt to create one without an attr struct passed in
to the open call, it could fail because it sets the queue size to the
max of both the msg size and queue size.  If these are large enough,
they over run the default RLIMIT_MSGQUEUE.  This change was also
introduced in the b231cca4 commit.  We then found that the msg queue
limits were not all being enforced on CAP_SYS_RESOURCE apps.  Finally,
we found that commit 9cf18e1d fiddled with HARD_MSGMAX without
realizing that the reason it was set to what it was, was to avoid
trying to kmalloc a chunk larger than 128K.  So, this series of
patches cleans up the various defines, takes us back to having a
larger HARD_MSGSIZEMAX, goes back to using a separate define for the
case where a user doesn't pass in an attr struct in case the maxes
have been raised too large for RLIMIT_MSGQUEUE, enforces the maximums
on CAP_SYS_RESOURCE apps, uses vmalloc instead of kmalloc when the
msg pointer array is too large, and documents all of this so it
shouldn't happen again.

Authors of the two original commits have been Cc:ed in case they want
to have any input.

Patches are also available via git at:

git://github.com/dledford/linux.git upstream/mqueue

[PATCH 1/4] ipc/mqueue: cleanup definition names and locations
[PATCH 2/4] ipc/mqueue: switch back to using non-max values on
[PATCH 3/4] ipc/mqueue: enforce hard limits
[PATCH 4/4] ipc/mqueue: update maximums for the mqueue subsystem

 include/linux/ipc_namespace.h |   40 +++++++++++++++++++++++++++++++++++-----
 ipc/mq_sysctl.c               |   31 ++++++++-----------------------
 ipc/mqueue.c                  |   23 ++++++++++++++++-------
 3 files changed, 59 insertions(+), 35 deletions(-)

--
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

