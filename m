Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2BOSkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:40:53 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41507 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754280Ab2BOSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:40:52 -0500
Date: Wed, 15 Feb 2012 13:40:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] char random: fix boot id uniqueness race (v3)
Message-ID: <20120215184044.GB19182@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:39:33 up 448 days, 23:42,  5 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proc file /proc/sys/kernel/random/boot_id can be read concurrently
by user-space processes. If two (or more) user-space processes
concurrently read boot_id when sysctl_bootid is not yet assigned, a race
can occur making boot_id differ between the reads. Because the whole
point of the boot id is to be unique across a kernel execution, fix this
by protecting this operation with a spinlock.

Given that this operation is not frequently used, hitting the spinlock
on each call should not be an issue.

* Changelog since v1:
- boot_id_mutex is now declared within the proc_do_uuid scope.
- added explanation for memory barriers.

* Changelog since v2:
- simplify: use spinlock on all paths, suggested by Eric Dumazet.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Matt Mackall <mpm@selenic.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/char/random.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/drivers/char/random.c
===================================================================
--- linux-2.6-lttng.orig/drivers/char/random.c
+++ linux-2.6-lttng/drivers/char/random.c
@@ -1250,10 +1250,15 @@ static int proc_do_uuid(ctl_table *table
 	uuid = table->data;
 	if (!uuid) {
 		uuid = tmp_uuid;
-		uuid[8] = 0;
-	}
-	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
+	} else {
+		static DEFINE_SPINLOCK(bootid_spinlock);
+
+		spin_lock(&bootid_spinlock);
+		if (!uuid[8])
+			generate_random_uuid(uuid);
+		spin_unlock(&bootid_spinlock);
+	}
 
 	sprintf(buf, "%pU", uuid);
 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
