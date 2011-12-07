Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1LGObZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:31:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973Ab1LGObX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:31:23 -0500
Message-ID: <1323268258.18450.11.camel@deadeye>
Subject: [PATCH] lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock
 debugging
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Greg KH <greg@kroah.com>,
        Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Wed, 07 Dec 2011 14:30:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do want to allow lock debugging for GPL-compatible modules that are
not (yet) built in-tree.  This was disabled as a side-effect of commit
2449b8ba0745327c5fa49a8d9acffe03b2eded69 ('module,bug: Add
TAINT_OOT_MODULE flag for modules not built in-tree').  Lock debug
warnings now include taint flags, so kernel developers should still
be able to deflect warnings caused by out-of-tree modules.

The TAINT_PROPRIETARY_MODULE flag for non-GPL-compatible modules will
still disable lock debugging.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/panic.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 1b83fd8..3458469 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -237,11 +237,12 @@ void add_taint(unsigned flag)
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
 	 * is not necessarily serious enough to set oops_in_progress to 1
-	 * Also we want to keep up lockdep for staging development and
-	 * post-warning case.
+	 * Also we want to keep up lockdep for staging/out-of-tree
+	 * development and post-warning case.
 	 */
 	switch (flag) {
 	case TAINT_CRAP:
+	case TAINT_OOT_MODULE:
 	case TAINT_WARN:
 	case TAINT_FIRMWARE_WORKAROUND:
 		break;
-- 
1.7.7.3


