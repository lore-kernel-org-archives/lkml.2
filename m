Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2FKNV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab2FKNV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:21:26 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/19] perf, tool: Add '.note' check into search for NOTE section
Date: Mon, 11 Jun 2012 15:20:06 +0200
Message-Id: <1339420814-7379-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
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
index 425bea5..59012fc 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1503,14 +1503,31 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
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
1.7.7.6

