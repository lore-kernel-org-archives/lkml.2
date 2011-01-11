Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1AKLMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:12:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:48686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab1AKLMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:12:44 -0500
Date: Tue, 11 Jan 2011 11:11:46 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, daahern@cisco.com,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Fix infinite loop in __perf_session__process_events
Message-ID: <tip-3d03e2ea74103a50c23d6ab1906cf73399c0dafb@git.kernel.org>
Git-Commit-ID: 3d03e2ea74103a50c23d6ab1906cf73399c0dafb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 11:11:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d03e2ea74103a50c23d6ab1906cf73399c0dafb
Gitweb:     http://git.kernel.org/tip/3d03e2ea74103a50c23d6ab1906cf73399c0dafb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Jan 2011 21:37:57 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Jan 2011 22:23:08 -0200

perf session: Fix infinite loop in __perf_session__process_events

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
