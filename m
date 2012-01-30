Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2A3EkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:40:17 -0500
Received: from mail.openrapids.net ([64.15.138.104]:54252 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753328Ab2A3EkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:40:15 -0500
Date: Sun, 29 Jan 2012 23:40:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] char random: fix boot id uniqueness race
Message-ID: <20120130044012.GA31966@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:35:58 up 432 days,  9:39,  2 users,  load average: 0.03, 0.05,
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
by protecting this operation with a mutex, and introduce a
boot_id_generated flag, along with appropriate memory barriers, to let
the fast-path know if the boot ID has been generated without having to
hold the mutex.

I propose this approach rather than setting it up within an initcall(),
because letting execution randomness add to entropy before populating
the boot id seems to be a wanted property. Also, populating it lazily
rather than at boot time only makes the performance hit be taken when
boot_id is being read.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Matt Mackall <mpm@selenic.com>
CC: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/char/random.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/drivers/char/random.c
===================================================================
--- linux-2.6-lttng.orig/drivers/char/random.c
+++ linux-2.6-lttng/drivers/char/random.c
@@ -1231,6 +1231,8 @@ static int min_read_thresh = 8, min_writ
 static int max_read_thresh = INPUT_POOL_WORDS * 32;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
+static int boot_id_generated;
+static DEFINE_MUTEX(boot_id_mutex);
 
 /*
  * These functions is used to return both the bootid UUID, and random
@@ -1250,10 +1252,22 @@ static int proc_do_uuid(ctl_table *table
 	uuid = table->data;
 	if (!uuid) {
 		uuid = tmp_uuid;
-		uuid[8] = 0;
-	}
-	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
+	} else {
+		if (unlikely(!ACCESS_ONCE(boot_id_generated))) {
+			mutex_lock(&boot_id_mutex);
+			if (!boot_id_generated) {
+				generate_random_uuid(uuid);
+				/* Store uuid before boot_id_generated. */
+				smp_wmb();
+				boot_id_generated = 1;
+			}
+			mutex_unlock(&boot_id_mutex);
+		} else {
+			/* Load boot_id_generated before uuid */
+			smp_rmb();
+		}
+	}
 
 	sprintf(buf, "%pU", uuid);
 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
