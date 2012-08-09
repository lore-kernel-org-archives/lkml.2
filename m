Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292Ab2HIWXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:23:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38807 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab2HIWXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:23:06 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 07/16] perf symbol: symplify out_fixup in kernel syms loading
Date: Thu,  9 Aug 2012 15:18:32 -0700
Message-Id: <1344550721-21024-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080922-5930-0000-0000-00000AB4D1CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only site that jumps to out_fixup has (kallsyms_filename == NULL).
And all paths that reach 'if (err > 0)' without 'goto out_fixup' have
kallsyms_filename != NULL.

So skip over both the check & dso__set_long_name(), and remove the
check.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index caab61a..90d2760 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2303,9 +2303,8 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0) {
+		dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
 out_fixup:
-		if (kallsyms_filename != NULL)
-			dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
-- 
1.7.11.3

