Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1LHEjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:39:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1LHEjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:39:00 -0500
Date: Wed, 7 Dec 2011 20:37:11 -0800
From: tip-bot for Ben Hutchings <ben@decadent.org.uk>
Message-ID: <tip-9ec84acee1e221d99dc33237bff5e82839d10cc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        debian-kernel@lists.debian.org, nbowler@elliptictech.com,
        hpa@zytor.com, mingo@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, greg@kroah.com, rdunlap@xenotime.net,
        davej@redhat.com, ben@decadent.org.uk, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, nbowler@elliptictech.com,
        debian-kernel@lists.debian.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, greg@kroah.com,
        peterz@infradead.org, davej@redhat.com, rdunlap@xenotime.net,
        ben@decadent.org.uk, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323268258.18450.11.camel@deadeye>
References: <1323268258.18450.11.camel@deadeye>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock debugging
Git-Commit-ID: 9ec84acee1e221d99dc33237bff5e82839d10cc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 20:37:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ec84acee1e221d99dc33237bff5e82839d10cc0
Gitweb:     http://git.kernel.org/tip/9ec84acee1e221d99dc33237bff5e82839d10cc0
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Wed, 7 Dec 2011 14:30:58 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Dec 2011 23:32:10 +0100

lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock debugging

We do want to allow lock debugging for GPL-compatible modules
that are not (yet) built in-tree.  This was disabled as a
side-effect of commit 2449b8ba0745327c5fa49a8d9acffe03b2eded69
('module,bug: Add TAINT_OOT_MODULE flag for modules not built
in-tree').  Lock debug warnings now include taint flags, so
kernel developers should still be able to deflect warnings
caused by out-of-tree modules.

The TAINT_PROPRIETARY_MODULE flag for non-GPL-compatible modules
will still disable lock debugging.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Greg KH <greg@kroah.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Debian kernel maintainers <debian-kernel@lists.debian.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/1323268258.18450.11.camel@deadeye
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
