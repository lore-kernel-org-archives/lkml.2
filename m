Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2IGGIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:08:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2IGGIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:08:40 -0400
Date: Thu, 6 Sep 2012 23:08:17 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-be4a2dedf6816871349fbddd018f266e93e3c22d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, robert.richter@amd.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1346821373-31621-4-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Swap pmu mapping numbers if needed
Git-Commit-ID: be4a2dedf6816871349fbddd018f266e93e3c22d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:08:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be4a2dedf6816871349fbddd018f266e93e3c22d
Gitweb:     http://git.kernel.org/tip/be4a2dedf6816871349fbddd018f266e93e3c22d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 5 Sep 2012 14:02:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:47:11 -0300

perf header: Swap pmu mapping numbers if needed

Like others, the numbers can be saved in a different endian format than
a host machine.  Swap them if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1346821373-31621-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 05c9310..43425b7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1440,6 +1440,9 @@ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 	if (ret != sizeof(pmu_num))
 		goto error;
 
+	if (ph->needs_swap)
+		pmu_num = bswap_32(pmu_num);
+
 	if (!pmu_num) {
 		fprintf(fp, "# pmu mappings: not available\n");
 		return;
@@ -1448,6 +1451,9 @@ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
 	while (pmu_num) {
 		if (read(fd, &type, sizeof(type)) != sizeof(type))
 			break;
+		if (ph->needs_swap)
+			type = bswap_32(type);
+
 		name = do_read_string(fd, ph);
 		if (!name)
 			break;
