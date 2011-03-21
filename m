Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1CUSY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:24:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:64488 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1CUSY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,220,1299484800"; 
   d="scan'208";a="615783429"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC] pstore: Don't use persistent store for normal shutdown
Date: Mon, 21 Mar 2011 11:24:23 -0700
Message-Id: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 04c6862c055fb687c90d9652f32c11a063df15cf
kmsg_dump: add kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart paths

Seiji Aguchi added kmsg_dump options for all the "normal" ways
that a system can be shut down (KEXEC, RESTART, HALT and POWEROFF).
It doesn't seem useful to save the kernel log to persistent store
in these cases.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

My /dev/pstore changes have been merged - and I immediately noticed that they
now save a record on every shutdown.  Some simple detective work with git found
that kmsg_dump now has some new "reasons" for calling its subscribers.

This patch excludes the four "normal shutdown" cases from being logged
to persistent store, on the assumption that we don't want to clutter up
a limited amount of storage space with routine data.  My presumption is
that there is some other subscriber to kmsg_dump that is doing something
with these reason codes ... is that right?  Or do you think that we should
save the tail of kernel log into persistent store for every shutdown?

Perhaps we could save less data for these new reasons? Other ideas?

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index ce9ad84..4ca44c6 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -61,15 +61,34 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	s1_start, s2_start;
 	unsigned long	l1_cpy, l2_cpy;
 	unsigned long	size, total = 0;
-	char		*dst;
+	char		*dst, *why;
 	u64		id;
 	int		hsize, part = 1;
 
+	switch (reason) {
+	case KMSG_DUMP_KEXEC:
+	case KMSG_DUMP_RESTART:
+	case KMSG_DUMP_HALT:
+	case KMSG_DUMP_POWEROFF:
+		return;
+	case KMSG_DUMP_OOPS:
+		why = "oops";
+		break;
+	case KMSG_DUMP_PANIC:
+		why = "panic";
+		break;
+	case KMSG_DUMP_EMERG:
+		why = "emergency";
+		break;
+	default:
+		why = "unknown";
+		break;
+	}
 	mutex_lock(&psinfo->buf_mutex);
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
-		hsize = sprintf(dst, "Oops#%d Part%d\n", oopscount, part++);
+		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part++);
 		size = psinfo->bufsize - hsize;
 		dst += hsize;
 
