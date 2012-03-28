Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2C1MhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:37:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2C1MhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:37:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/15] perf, tool: Add '.note' check into search for NOTE section
Date: Wed, 28 Mar 2012 14:35:52 +0200
Message-Id: <1332938158-5244-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding '.note' section name to be check when looking for notes
section. The '.note' name is used by kernel VDSO.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2b8fa4b..4a0b1fa 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1473,14 +1473,31 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
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
-- 
1.7.1

