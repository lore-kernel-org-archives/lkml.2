Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1BBV4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:56:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:32822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab1BBV4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:56:50 -0500
Date: Wed, 2 Feb 2011 21:56:37 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134417.938447839@linutronix.de>
References: <20110201134417.938447839@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Introduce clockid_to_kclock()
Message-ID: <tip-cc785ac22b17ed53e8ff5c1501e422be6d10be3c@git.kernel.org>
Git-Commit-ID: cc785ac22b17ed53e8ff5c1501e422be6d10be3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:56:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc785ac22b17ed53e8ff5c1501e422be6d10be3c
Gitweb:     http://git.kernel.org/tip/cc785ac22b17ed53e8ff5c1501e422be6d10be3c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:09 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:12 +0100

posix-timers: Introduce clockid_to_kclock()

New function to find the kclock for a given clockid.

Returns a pointer to clock_posix_cpu if clockid < 0. If clockid >=
MAXCLOCK or if the clock_getres pointer is not set it returns
NULL. For valid clocks it returns a pointer to the matching
posix_clock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Acked-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134417.938447839@linutronix.de>
---
 kernel/posix-timers.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index e7d26af..14b0a70 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -531,6 +531,16 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
+static struct k_clock *clockid_to_kclock(const clockid_t id)
+{
+	if (id < 0)
+		return &clock_posix_cpu;
+
+	if (id >= MAX_CLOCKS || !posix_clocks[id].clock_getres)
+		return NULL;
+	return &posix_clocks[id];
+}
+
 /* Create a POSIX.1b interval timer. */
 
 SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
