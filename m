Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2BOEKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 23:10:21 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41414 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754752Ab2BOEKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 23:10:18 -0500
Date: Tue, 14 Feb 2012 23:10:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH] char random: fix boot id uniqueness race (v2)
Message-ID: <20120215041014.GA15846@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:06:40 up 448 days,  9:09,  5 users,  load average: 0.22, 0.19,
	0.12
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


Q: Why are these memory barriers required ? Aren't the mutexes already
   dealing with ordering ?

The need for memory barriers is a consequence of letting the fast-path
run without holding this mutex.

Here is the race dealt with by the smp_rmb()/smp_wmb(). I'm showing the
result of reversed write order here:

CPU A                             CPU B

Load boot_id_generated            
  (test -> false)
mutex_lock(&boot_id_mutex)
  (implied memory barrier
   with acquire semantic)
Load boot_id_generated again
   (test -> false)
boot_id_generated = 1
  (both the compiler and
   CPU are free to reorder
   the boot_id_generated
   store before uuid stores)
                                  Load boot_id_generated
                                    (test -> true)
                                  Load uuid content
                                    (races with generate_random_uuid:
                                     result either 0 or corrupted)
                                  Return corrupted uuid.
generate_random_uuid(uuid)
mutex_unlock(&boot_id_mutex)

I prefer not requiring the fast-path to take a mutex, because this
would transform a read-mostly operation into an operation that
requires cache-line exchanges (the mutex). However, if we want the
fast-path to be mutex-free, we need to enforce order with
memory barriers: smp_rmb on the read-side, smp_wmb on the
update-side. Failure to do so leads to the race shown above, where
a corrupted boot_id can be returned.


* Changelog since v1:
- boot_id_mutex is now declared within the proc_do_uuid scope.
- added explanation for memory barriers.

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
@@ -1244,16 +1244,30 @@ static char sysctl_bootid[16];
 static int proc_do_uuid(ctl_table *table, int write,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
+	static int boot_id_generated;
+	static DEFINE_MUTEX(boot_id_mutex);
 	ctl_table fake_table;
 	unsigned char buf[64], tmp_uuid[16], *uuid;
 
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
