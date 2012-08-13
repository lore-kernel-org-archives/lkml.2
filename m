Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2HMSiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:38:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2HMShj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/38] perf symbols: Avoid segfault in elf_strptr
Date: Mon, 13 Aug 2012 15:37:11 -0300
Message-Id: <1344883039-13495-31-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

If we call elf_section_by_name() with a truncated elf image (ie: the
file header indicates that the section headers are placed past the end
of the file), elf_strptr() causes a segfault within libelf.

Avoid this by checking that we can access the section string table
properly.

Should really be fixed in libelf/elfutils.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-10-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

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
1.7.1

