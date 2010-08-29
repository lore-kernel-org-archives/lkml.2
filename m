Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0H2PFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:05:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41250 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0H2PFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OE+od2G42hS+yjdCK0KjrLxBC4u74HHUhnRcBH7tzN8Ue7aQZBbddS0BMFBeJPiVbF
         QaM2XNwH3LsYML57MUVXkiaDsjrtS/csovPyB1e6DUh8/sYbb/AcNDPVsCbRku5sde1W
         8JLx9hoEY9gCM5+6lN6XBn5hjxmNKsDzkT81w=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCH 1/6] timer: expliciyly call timer_stats_timer_set_start_info() in add_timer()
Date: Sun, 29 Aug 2010 23:05:04 +0800
Message-Id: <1283094309-6635-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Now /proc/timer_stats will show add_timer() as the start_site:
   23,     0 swapper          add_timer (peer_check_expire)
   23,     0 swapper          add_timer (addrconf_verify)

This is because add_timer() -> mod_timer() -> __mod_timer(),
but mod_timer() is not inlined. So add_timer() is showed.
Call timer_stats_timer_set_start_info() explicitly to record the
real start_site.

After this change, timer_stats_timer_set_start_info() in workqueue.c
can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/timer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..2a443cc 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -864,6 +864,7 @@ EXPORT_SYMBOL(mod_timer_pinned);
 void add_timer(struct timer_list *timer)
 {
 	BUG_ON(timer_pending(timer));
+	timer_stats_timer_set_start_info(timer);
 	mod_timer(timer, timer->expires);
 }
 EXPORT_SYMBOL(add_timer);
-- 
1.7.0.4

