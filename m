Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1C1SIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:08:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1C1SII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:08:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf symbols: Fix vsyscall symbol lookup
Date: Mon, 28 Mar 2011 15:07:51 -0300
Message-Id: <1301335671-22897-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301335671-22897-1-git-send-email-acme@infradead.org>
References: <1301335671-22897-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lutomirski <luto@mit.edu>

Perf can't currently trace into the vsyscall page.  It looks like it was
meant to work.

Tested on 2.6.38 and today's -git.

The bug is easy to reproduce.  Compile this:

int main()
{
	int i;
	struct timespec t;
	for(i = 0; i < 10000000; i++)
		clock_gettime(CLOCK_MONOTONIC, &t);
	return 0;
}

and run it through perf record; perf report.  The top entry shows
"[unknown]" and you can't zoom in.

It looks like there are two issues.  The first is a that a test for user
mode executing in kernel space is backwards.  (That's the first hunk
below).  The second (I think) is that something's wrong with the code
that generates lots of little struct dso objects for different sections
-- when it runs on vmlinux it results in bogus long_name values which
cause objdump to fail.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LPU-Reference: <AANLkTikxSw5+wJZUWNz++nL7mgivCh_Zf=2Kq6=f9Ce_@mail.gmail.com>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    2 +-
 tools/perf/util/symbol.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2b15c36..1023f67 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -710,7 +710,7 @@ try_again:
 		 * in the whole kernel symbol list.
 		 */
 		if ((long long)al->addr < 0 &&
-		    cpumode == PERF_RECORD_MISC_KERNEL &&
+		    cpumode == PERF_RECORD_MISC_USER &&
 		    machine && mg != &machine->kmaps) {
 			mg = &machine->kmaps;
 			goto try_again;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 17df793..8f73907 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1196,6 +1196,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				if (curr_dso == NULL)
 					goto out_elf_end;
 				curr_dso->kernel = self->kernel;
+				curr_dso->long_name = self->long_name;
+				curr_dso->long_name_len = self->long_name_len;
 				curr_map = map__new2(start, curr_dso,
 						     map->type);
 				if (curr_map == NULL) {
@@ -1842,6 +1844,7 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	if (fd < 0)
 		return -1;
 
+	dso__set_long_name(self, (char *)vmlinux);
 	dso__set_loaded(self, map->type);
 	err = dso__load_sym(self, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
-- 
1.6.2.5

