Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab2DSTix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:38:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab2DSTiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:38:51 -0400
Date: Thu, 19 Apr 2012 12:38:39 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-a6371f80230eaaafd7eef7efeedaa9509bdc982d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        santosh.shilimkar@ti.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, santosh.shilimkar@ti.com,
        tglx@linutronix.de
In-Reply-To: <1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com>
References: <1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick:
  Fix the spurious broadcast timer ticks after resume
Git-Commit-ID: a6371f80230eaaafd7eef7efeedaa9509bdc982d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 12:38:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6371f80230eaaafd7eef7efeedaa9509bdc982d
Gitweb:     http://git.kernel.org/tip/a6371f80230eaaafd7eef7efeedaa9509bdc982d
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 Apr 2012 19:27:39 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 19 Apr 2012 21:27:50 +0200

tick: Fix the spurious broadcast timer ticks after resume

During resume, tick_resume_broadcast() programs the broadcast timer in
oneshot mode unconditionally. On the platforms where broadcast timer
is not really required, this will generate spurious broadcast timer
ticks upon resume. For example, on the always running apic timer
platforms with HPET, I see spurious hpet tick once every ~5minutes
(which is the 32-bit hpet counter wraparound time).

Similar to boot time, during resume make the oneshot mode setting of
the broadcast clock event device conditional on the state of active
broadcast users.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: svenjoac@gmx.de
Cc: torvalds@linux-foundation.org
Cc: rjw@sisk.pl
Link: http://lkml.kernel.org/r/1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 029531f..f113755 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -346,7 +346,8 @@ int tick_resume_broadcast(void)
 						     tick_get_broadcast_mask());
 			break;
 		case TICKDEV_MODE_ONESHOT:
-			broadcast = tick_resume_broadcast_oneshot(bc);
+			if (!cpumask_empty(tick_get_broadcast_mask()))
+				broadcast = tick_resume_broadcast_oneshot(bc);
 			break;
 		}
 	}
