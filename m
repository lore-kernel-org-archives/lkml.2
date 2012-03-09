Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2CINcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:32:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58794 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab2CINcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:32:03 -0500
Date: Fri, 9 Mar 2012 05:31:42 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-62db90681c0db8c76e5db006b929a2edd5d12ae6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-18-git-send-email-eranian@google.com>
References: <1328826068-11713-18-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf tools:
  Fix ABI compatibility bug in print_event_desc()
Git-Commit-ID: 62db90681c0db8c76e5db006b929a2edd5d12ae6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:31:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62db90681c0db8c76e5db006b929a2edd5d12ae6
Gitweb:     http://git.kernel.org/tip/62db90681c0db8c76e5db006b929a2edd5d12ae6
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:21:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:06 +0100

perf tools: Fix ABI compatibility bug in print_event_desc()

This patches cleans up local variable types for msz and ret.
They need to be size_t and ssize_t respectively.

It also fixes a bug whereby perf would not read attr struct
with a different size than what it knows about.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: robert.richter@amd.com
Cc: ming.m.lin@intel.com
Cc: andi@firstfloor.org
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1328826068-11713-18-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 666f189..6d58026 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1144,8 +1144,9 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	uint64_t id;
 	void *buf = NULL;
 	char *str;
-	u32 nre, sz, nr, i, j, msz;
-	int ret;
+	u32 nre, sz, nr, i, j;
+	ssize_t ret;
+	size_t msz;
 
 	/* number of events */
 	ret = read(fd, &nre, sizeof(nre));
@@ -1162,25 +1163,23 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	if (ph->needs_swap)
 		sz = bswap_32(sz);
 
-	/*
-	 * ensure it is at least to our ABI rev
-	 */
-	if (sz < (u32)sizeof(attr))
-		goto error;
-
 	memset(&attr, 0, sizeof(attr));
 
-	/* read entire region to sync up to next field */
+	/* buffer to hold on file attr struct */
 	buf = malloc(sz);
 	if (!buf)
 		goto error;
 
 	msz = sizeof(attr);
-	if (sz < msz)
+	if (sz < (ssize_t)msz)
 		msz = sz;
 
 	for (i = 0 ; i < nre; i++) {
 
+		/*
+		 * must read entire on-file attr struct to
+		 * sync up with layout.
+		 */
 		ret = read(fd, buf, sz);
 		if (ret != (ssize_t)sz)
 			goto error;
