Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab1KRXFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:05:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab1KRXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:05:09 -0500
Date: Fri, 18 Nov 2011 15:04:45 -0800
From: tip-bot for Ilya Dryomov <idryomov@gmail.com>
Message-ID: <tip-d631097577f6fe027f4903f62eabced6445d19bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        idryomov@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        idryomov@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1320052062-7846-1-git-send-email-idryomov@gmail.com>
References: <1320052062-7846-1-git-send-email-idryomov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: fix event_subsystem ref counting
Git-Commit-ID: d631097577f6fe027f4903f62eabced6445d19bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:04:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d631097577f6fe027f4903f62eabced6445d19bf
Gitweb:     http://git.kernel.org/tip/d631097577f6fe027f4903f62eabced6445d19bf
Author:     Ilya Dryomov <idryomov@gmail.com>
AuthorDate: Mon, 31 Oct 2011 11:07:42 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 31 Oct 2011 13:59:23 -0400

tracing: fix event_subsystem ref counting

Fix a bug introduced by e9dbfae5, which prevents event_subsystem from
ever being released.

Ref_count was added to keep track of subsystem users, not for counting
events.  Subsystem is created with ref_count = 1, so there is no need to
increment it for every event, we have nr_events for that.  Fix this by
touching ref_count only when we actually have a new user -
subsystem_open().

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Link: http://lkml.kernel.org/r/1320052062-7846-1-git-send-email-idryomov@gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 581876f..c212a7f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1078,7 +1078,6 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
-			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
