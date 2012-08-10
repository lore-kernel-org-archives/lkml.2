Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab2HJWYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:24:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38219 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2HJWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:43 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 09/16] perf symbol: avoid segfault in elf_strptr
Date: Fri, 10 Aug 2012 15:22:55 -0700
Message-Id: <1344637382-22789-10-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-9360-0000-0000-000009512915
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we call elf_section_by_name() with a truncated elf image (ie: the file
header indicates that the section headers are placed past the end of the
file), elf_strptr() causes a segfault within libelf.

Avoid this by checking that we can access the section string table
properly.

Should really be fixed in libelf/elfutils.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a2e994e..a9a194d 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -129,6 +129,10 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	Elf_Scn *sec = NULL;
 	size_t cnt = 1;
 
+	/* Elf is corrupted/truncated, avoid calling elf_strptr. */
+	if (!elf_rawdata(elf_getscn(elf, ep->e_shstrndx), NULL))
+		return NULL;
+
 	while ((sec = elf_nextscn(elf, sec)) != NULL) {
 		char *str;
 
-- 
1.7.11.3

