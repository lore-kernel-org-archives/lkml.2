Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0IIOsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:48:24 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:44921 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753286Ab0IIOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:48:21 -0400
Subject: [PATCH] perf: Fix crash when vmlinux_path__exit().
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: a.p.zijlstra@chello.nl, acme@redhat.com, mingo@elte.hu
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 10:48:10 -0400
Message-ID: <1284043690.2000.8.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] perf: Fix crash when vmlinux_path__exit()

When running perf {timechart,sched} record an incorrect freeing occurs after Ctrl-C'ing to
exit the application, the following is seen:

*** glibc detected *** ./perf: free(): invalid pointer: 0x00000000016459e0 ***
======= Backtrace: =========
/lib/libc.so.6(+0x775b6)[0x7f2333e935b6]
/lib/libc.so.6(cfree+0x73)[0x7f2333e99e53]
./perf[0x42a58f]
./perf[0x40f791]
./perf[0x40c7f0]
./perf[0x405da1]
./perf[0x4067c3]
/lib/libc.so.6(__libc_start_main+0xfd)[0x7f2333e3ac4d]
./perf[0x405b49]
======= Memory map: ========
00400000-0046b000 r-xp 00000000 08:01 8804505                            /home/dave/projects/linux-git/tools/perf/perf
0066a000-0066b000 r--p 0006a000 08:01 8804505                            /home/dave/projects/linux-git/tools/perf/perf
0066b000-00672000 rw-p 0006b000 08:01 8804505                            /home/dave/projects/linux-git/tools/perf/perf
00672000-00947000 rw-p 00000000 00:00 0
01645000-01892000 rw-p 00000000 00:00 0                                  [heap]
7f232c000000-7f232c021000 rw-p 00000000 00:00 0
7f232c021000-7f2330000000 ---p 00000000 00:00 0
7f23331d8000-7f23331ee000 r-xp 00000000 08:01 7602255                    /lib/libgcc_s.so.1
...

By doing some debugging I found that the vmlinux_path__nr_entries getting bigger than 5 (max amount of entries), usually 10.
This does not happen when not combining commands (using sched, timechart, record, etc. alone). It would seem that the the amount is always being duplicated when
combining commands. I do not have much experience in perf, but here is a patch that would seem to solve the problem.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 tools/perf/util/symbol.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1a36773..4a9ebc0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -26,6 +26,8 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
+#define VMLINUX_PATH_MAX_ENTRIES 5
+
 static bool dso__build_id_equal(const struct dso *self, u8 *build_id);
 static int elf_read_build_id(Elf *elf, void *bf, size_t size);
 static void dsos__add(struct list_head *head, struct dso *dso);
@@ -2197,7 +2199,10 @@ static int vmlinux_path__init(void)
 	if (uname(&uts) < 0)
 		return -1;
 
-	vmlinux_path = malloc(sizeof(char *) * 5);
+	if (vmlinux_path__nr_entries == VMLINUX_PATH_MAX_ENTRIES)
+		return 0; /* array already populated, do nothing */
+
+	vmlinux_path = malloc(sizeof(char *) * VMLINUX_PATH_MAX_ENTRIES);
 	if (vmlinux_path == NULL)
 		return -1;
 
-- 
1.7.0.4



