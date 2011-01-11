Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1AKA2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:28:32 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40136 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab1AKA20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:28:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 6/6] perf session: Fix infinite loop in __perf_session__process_events
Date: Mon, 10 Jan 2011 22:28:12 -0200
Message-Id: <1294705692-9537-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294705692-9537-1-git-send-email-acme@infradead.org>
References: <1294705692-9537-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In this if statement:

        if (head + event->header.size >= mmap_size) {
                if (mmaps[map_idx]) {
                        munmap(mmaps[map_idx], mmap_size);
                        mmaps[map_idx] = NULL;
                }

                page_offset = page_size * (head / page_size);
                file_offset += page_offset;
                head -= page_offset;
                goto remap;
        }

With, for instance, these values:

head=2992
event->header.size=48
mmap_size=3040

We end up endlessly looping back to remap. Off by one.

Problem introduced in 55b4462.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: David Ahern <daahern@cisco.com>
Bisected-by: David Ahern <daahern@cisco.com>
Tested-by: David Ahern <daahern@cisco.com>
Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6fb4694..313dac2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1007,7 +1007,7 @@ more:
 	if (size == 0)
 		size = 8;
 
-	if (head + event->header.size >= mmap_size) {
+	if (head + event->header.size > mmap_size) {
 		if (mmaps[map_idx]) {
 			munmap(mmaps[map_idx], mmap_size);
 			mmaps[map_idx] = NULL;
-- 
1.6.2.5

