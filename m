Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0FQUkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:40:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab0FQUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andy Isaacson <adi@hexapodia.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf session: fix error message on failure to open perf.data
Date: Thu, 17 Jun 2010 17:40:04 -0300
Message-Id: <1276807204-22512-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Isaacson <adi@hexapodia.org>

If we cannot open our data file, print strerror(errno) for a more
comprehensible error message; and only suggest 'perf record' on ENOENT.

In particular, this fixes the nonsensical advice when:

    % sudo perf record sleep 1
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.009 MB perf.data (~381 samples) ]
    % perf trace
    failed to open file: perf.data  (try 'perf record' first)
    %

Cc: Ingo Molnar <mingo@elte.hu>
LPU-Reference: <20100612033615.GA24731@hexapodia.org>
Signed-off-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8f83a18..0564a5c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -27,8 +27,10 @@ static int perf_session__open(struct perf_session *self, bool force)
 
 	self->fd = open(self->filename, O_RDONLY);
 	if (self->fd < 0) {
-		pr_err("failed to open file: %s", self->filename);
-		if (!strcmp(self->filename, "perf.data"))
+		int err = errno;
+
+		pr_err("failed to open %s: %s", self->filename, strerror(err));
+		if (err == ENOENT && !strcmp(self->filename, "perf.data"))
 			pr_err("  (try 'perf record' first)");
 		pr_err("\n");
 		return -errno;
-- 
1.6.2.5

