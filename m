Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2L2C4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 21:56:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64547 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2L2C4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 21:56:22 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] perf x86: revert 20b279 - require exclude_guest to use PEBS - kernel side
Date: Fri, 28 Dec 2012 19:56:07 -0700
Message-Id: <1356749767-17322-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is brought to you by the letter 'H'.

Commit 20b279 breaks compatiblity with older perf binaries when run with
precise modifier (:p or :pp) by requiring the exclude_guest attribute to be
set. Older binaries default exclude_guest to 0 (ie., wanting guest-based
samples) unless host only profiling is requested (:H modifier). The workaround
for older binaries is to add H to the modifier list (e.g., -e cycles:ppH -
toggles exclude_guest to 1). This was deemed unacceptable by Linus:

https://lkml.org/lkml/2012/12/12/570

Between family in town and the fresh snow in Breckenridge there is no time left
to be working on the proper fix for this over the holidays. In the New Year I
have more pressing problems to resolve -- like some memory leaks in perf which
are proving to be elusive -- although the aforementioned snow is probably why
they are proving to be elusive. Either way I do not have any spare time to work
on this and from the time I have managed to spend on it the solution is more
difficult than just moving to a new exclude_guest flag (does not work) or
flipping the logic to include_guest (which is not as trivial as one would
think).

So, two options: silently force exclude_guest on as suggested by Gleb which
means no impact to older perf binaries or revert the original patch which
caused the breakage.

This patch does the latter -- reverts the original patch that introduced the
regression. The problem can be revisited in the future as time allows.

Signed-off-By: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..6774c17 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -340,9 +340,6 @@ int x86_setup_perfctr(struct perf_event *event)
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
-
-		if (!attr->exclude_guest)
-			return -EOPNOTSUPP;
 	}
 
 	hwc->config |= config;
@@ -385,9 +382,6 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
-		if (!event->attr.exclude_guest)
-			return -EOPNOTSUPP;
-
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
-- 
1.7.10.1

