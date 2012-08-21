Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2HUQEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab2HUQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:04:45 -0400
Date: Tue, 21 Aug 2012 09:04:16 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-492746546fe380da768c8496213e26aa91b9b3aa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-10-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-10-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Avoid segfault in elf_strptr
Git-Commit-ID: 492746546fe380da768c8496213e26aa91b9b3aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:04:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  492746546fe380da768c8496213e26aa91b9b3aa
Gitweb:     http://git.kernel.org/tip/492746546fe380da768c8496213e26aa91b9b3aa
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:55 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:25:23 -0300

perf symbols: Avoid segfault in elf_strptr

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
 
