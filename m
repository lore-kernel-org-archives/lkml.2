Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2BBM4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:56:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2BBM4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:56:36 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v5 17/18] perf: fix bug print_event_desc()
Date: Thu,  2 Feb 2012 13:54:47 +0100
Message-Id: <1328187288-24395-18-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328187288-24395-1-git-send-email-eranian@google.com>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches cleans up local variable types for msz and ret.
They need to be size_t and ssize_t respectively.

It also fixes a bug whereby perf would not read attr struct
with a different size than what it knows about.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/header.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8d6c18d..1fb365d 100644
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
-- 
1.7.4.1

