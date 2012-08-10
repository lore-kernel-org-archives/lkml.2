Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324Ab2HJWZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:25:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48460 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760315Ab2HJWZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:25:04 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 08/16] perf symbol: only set vmlinux longname & mark loaded if really loaded
Date: Fri, 10 Aug 2012 15:22:54 -0700
Message-Id: <1344637382-22789-9-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-4242-0000-0000-00000290F4B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dso__load_vmlinux() uses the filename passed to it to directly set the
dso long_name, which resulted in a use after free due to
dso__load_vmlinux_path() treating 0 symbols as a load failure and
subsequently freeing the contents of dso->long_name.

Change dso__load_vmlinux() so that finding 0 symbols does not cause it
to consider itself loaded, and do not set long_name in such a case.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e5c3817..96dbf28 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1364,13 +1364,14 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	if (fd < 0)
 		return -1;
 
-	dso__set_long_name(dso, (char *)vmlinux);
-	dso__set_loaded(dso, map->type);
 	err = dso__load_sym(dso, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
 
-	if (err > 0)
+	if (err > 0) {
+		dso__set_long_name(dso, (char *)vmlinux);
+		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
+	}
 
 	return err;
 }
-- 
1.7.11.3

