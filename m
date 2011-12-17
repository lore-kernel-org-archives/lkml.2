Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1LQNft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:35:49 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47474 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab1LQNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:35:46 -0500
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [RFC 2/2] perf: duct tape a crash on perf kvm --guestmount=$(pwd) report
Date: Sat, 17 Dec 2011 14:35:38 +0100
Message-Id: <1324128938-17553-2-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1324128938-17553-1-git-send-email-sebastian@breakpoint.cc>
References: <1324128938-17553-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data was collected with
|perf kvm --guestmount=$(pwd) record -a -R -g -s -d -T

After executing
|kvm --guestmount=$(pwd) report

I ended up with two segfaults. This patch duct tapes both of them.
Most likely there is some infomration missing.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 tools/perf/util/map.c    |    2 +-
 tools/perf/util/symbol.c |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 316aa0a..a57f897 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -693,7 +693,7 @@ char *machine__mmap_name(struct machine *self, char *bf, size_t size)
 	else if (machine__is_default_guest(self))
 		snprintf(bf, size, "[%s]", "guest.kernel.kallsyms");
 	else
-		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
+		snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self ? self->pid : -1);
 
 	return bf;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f2dd916..2760ab1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1876,8 +1876,12 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 				const char *filename)
 {
 	struct map *map;
-	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
+	struct dso *dso;
+
+	if (!machine)
+		return NULL;
 
+	dso = __dsos__findnew(&machine->kernel_dsos, filename);
 	if (dso == NULL)
 		return NULL;
 
-- 
1.7.7.3

