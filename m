Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1H2OEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:04:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60161 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1H2OE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:04:27 -0400
Date: Mon, 29 Aug 2011 16:04:18 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state setting
 bug in freezer_change_state()
Message-ID: <20110829140418.GB18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d02f52811d0e "cgroup_freezer: prepare for removal of TIF_FREEZE" moved
setting of freezer->state into freezer_change_state(); unfortunately,
while doing so, when it's beginning to freeze tasks, it sets the state
to CGROUP_FROZEN instead of CGROUP_FREEZING ending up skipping the
whole freezing state.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
Rafael, these four patches fix the issues spotted by Oleg during
review of the freezer patchset.  Please apply them on pm-freezer once
Oleg acks them.  Thanks.

 kernel/cgroup_freezer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/kernel/cgroup_freezer.c
===================================================================
--- work.orig/kernel/cgroup_freezer.c
+++ work/kernel/cgroup_freezer.c
@@ -311,14 +311,14 @@ static int freezer_change_state(struct c
 	if (goal_state == freezer->state)
 		goto out;
 
-	freezer->state = goal_state;
-
 	switch (goal_state) {
 	case CGROUP_THAWED:
+		freezer->state = CGROUP_THAWED;
 		atomic_dec(&system_freezing_cnt);
 		unfreeze_cgroup(cgroup, freezer);
 		break;
 	case CGROUP_FROZEN:
+		freezer->state = CGROUP_FREEZING;
 		atomic_inc(&system_freezing_cnt);
 		retval = try_to_freeze_cgroup(cgroup, freezer);
 		break;
