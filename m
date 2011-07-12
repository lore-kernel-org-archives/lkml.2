Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1GLPT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:19:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36297 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1GLPT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:19:26 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: fix endian conversion reading event attr from header
Date: Tue, 12 Jul 2011 09:19:19 -0600
Message-Id: <1310483959-23621-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_attr struct has 2 __u32's at the top and need to
be swapped individually. With this change I was able to analyze
a perf.data collected in a 32-bit PPC VM on an x86 system. I
tested both 32-bit and 64-bit binaries for the Intel analysis
side; both read the PPC perf.data file correctly.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index afb0849..8044c6f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -877,9 +877,16 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		struct perf_evsel *evsel;
 		off_t tmp;
 
-		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
+		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
 			goto out_errno;
 
+		if (header->needs_swap) {
+			f_attr.attr.type = bswap_32(f_attr.attr.type);
+			f_attr.attr.size = bswap_32(f_attr.attr.size);
+			mem_bswap_64(&f_attr.attr.config,
+				     sizeof(struct perf_event_attr) - 8);
+		}
+
 		tmp = lseek(fd, 0, SEEK_CUR);
 		evsel = perf_evsel__new(&f_attr.attr, i);
 
-- 
1.7.6

