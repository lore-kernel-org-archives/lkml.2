Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1ERFWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:22:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:37069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1ERFWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:22:10 -0400
Date: Wed, 18 May 2011 05:21:59 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-94692349c4fc1bc74c19a28f9379509361a06a3b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110517133619.GA6999@quad>
References: <20110517133619.GA6999@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix multi-event parsing bug
Git-Commit-ID: 94692349c4fc1bc74c19a28f9379509361a06a3b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 05:21:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94692349c4fc1bc74c19a28f9379509361a06a3b
Gitweb:     http://git.kernel.org/tip/94692349c4fc1bc74c19a28f9379509361a06a3b
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 17 May 2011 15:36:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 May 2011 20:45:36 +0200

perf: Fix multi-event parsing bug

This patch fixes an issue with event parsing.
The following commit appears to have broken the
ability to specify a comma separated list of events:

   commit ceb53fbf6dbb1df26d38379a262c6981fe73dd36
   Author: Ingo Molnar <mingo@elte.hu>
   Date:   Wed Apr 27 04:06:33 2011 +0200

       perf stat: Fail more clearly when an invalid modifier is specified

This patch fixes this while preserving the desired effect:

$ perf stat -e instructions:u,instructions:k ls /dev/null /dev/null

 Performance counter stats for 'ls /dev/null':

            365956 instructions:u           #    0.00  insns per cycle
            731806 instructions:k           #    0.00  insns per cycle

        0.001108862  seconds time elapsed

$ perf stat -e task-clock-msecs true
invalid event modifier: '-msecs'
Run 'perf list' for a list of valid events and modifiers

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com
Cc: peterz@infradead.org
Cc: fweisbec@gmail.com
Link: http://lkml.kernel.org/r/20110517133619.GA6999@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index ffa493a..41982c3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -734,6 +734,9 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 	if (!*str)
 		return 0;
 
+	if (*str == ',')
+		return 0;
+
 	if (*str++ != ':')
 		return -1;
 
