Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2GFLBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:01:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51531 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2GFLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:01:00 -0400
Date: Fri, 6 Jul 2012 03:59:52 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-1388d715dd7d0f494c93dfdef6ab26719218b868@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1340120894-9465-15-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-15-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add '.note'
  check into search for NOTE section
Git-Commit-ID: 1388d715dd7d0f494c93dfdef6ab26719218b868
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:59:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1388d715dd7d0f494c93dfdef6ab26719218b868
Gitweb:     http://git.kernel.org/tip/1388d715dd7d0f494c93dfdef6ab26719218b868
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 19 Jun 2012 17:48:05 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:37:57 -0300

perf symbols: Add '.note' check into search for NOTE section

Adding '.note' section name to be check when looking for notes section.
The '.note' name is used by kernel VDSO.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1340120894-9465-15-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 994f4ff..50958bb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1478,14 +1478,31 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
 		goto out;
 	}
 
-	sec = elf_section_by_name(elf, &ehdr, &shdr,
-				  ".note.gnu.build-id", NULL);
-	if (sec == NULL) {
+	/*
+	 * Check following sections for notes:
+	 *   '.note.gnu.build-id'
+	 *   '.notes'
+	 *   '.note' (VDSO specific)
+	 */
+	do {
+		sec = elf_section_by_name(elf, &ehdr, &shdr,
+					  ".note.gnu.build-id", NULL);
+		if (sec)
+			break;
+
 		sec = elf_section_by_name(elf, &ehdr, &shdr,
 					  ".notes", NULL);
-		if (sec == NULL)
-			goto out;
-	}
+		if (sec)
+			break;
+
+		sec = elf_section_by_name(elf, &ehdr, &shdr,
+					  ".note", NULL);
+		if (sec)
+			break;
+
+		return err;
+
+	} while (0);
 
 	data = elf_getdata(sec, NULL);
 	if (data == NULL)
