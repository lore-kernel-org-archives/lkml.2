Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1JaJGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:06:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:06:51 -0400
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, idryomov@gmail.com
Subject: [PATCH] tracing: fix event_subsystem ref counting
Date: Mon, 31 Oct 2011 11:07:42 +0200
Message-Id: <1320052062-7846-1-git-send-email-idryomov@gmail.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug introduced by e9dbfae5, which prevents event_subsystem from
ever being released.

Ref_count was added to keep track of subsystem users, not for counting
events.  Subsystem is created with ref_count = 1, so there is no need to
increment it for every event, we have nr_events for that.  Fix this by
touching ref_count only when we actually have a new user -
subsystem_open().

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
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
-- 
1.7.6.3

