Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab1BIPTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:19:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:48332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1BIPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:19:15 -0500
Date: Wed, 9 Feb 2011 15:18:53 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhowells@redhat.com, torbenh@gmx.de, tglx@linutronix.de,
        yasutake.koichi@jp.panasonic.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, dhowells@redhat.com, tglx@linutronix.de,
        yasutake.koichi@jp.panasonic.com
In-Reply-To: <20110127150011.23248.62040.stgit@localhost>
References: <20110127150011.23248.62040.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] mn10300: Switch do_timer() to xtimer_update()
Message-ID: <tip-22b7fcdae562b6792b3f5517e89fd7e0337180ae@git.kernel.org>
Git-Commit-ID: 22b7fcdae562b6792b3f5517e89fd7e0337180ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Feb 2011 15:18:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22b7fcdae562b6792b3f5517e89fd7e0337180ae
Gitweb:     http://git.kernel.org/tip/22b7fcdae562b6792b3f5517e89fd7e0337180ae
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:12 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 9 Feb 2011 16:17:24 +0100

mn10300: Switch do_timer() to xtimer_update()

Only one CPU gets the timer interrupt so mn10300_last_tsc does not
need to be protected by xtime lock. Remove xtime lovking and use
xtime_update() which does the locking itself.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
LKML-Reference: <20110127150011.23248.62040.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 75da468..5b95500 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -104,8 +104,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	unsigned tsc, elapse;
 	irqreturn_t ret;
 
-	write_seqlock(&xtime_lock);
-
 	while (tsc = get_cycles(),
 	       elapse = tsc - mn10300_last_tsc, /* time elapsed since last
 						 * tick */
@@ -114,11 +112,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		mn10300_last_tsc += MN10300_TSC_PER_HZ;
 
 		/* advance the kernel's time tracking system */
-		do_timer(1);
+		xtime_update(1);
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	ret = local_timer_interrupt();
 #ifdef CONFIG_SMP
 	send_IPI_allbutself(LOCAL_TIMER_IPI);
