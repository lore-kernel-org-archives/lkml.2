Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab0HEOih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:38:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:41162 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab0HEOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 02/17] gdbstub: Optimize kgdb's "thread:" response for the gdb serial protocol
Date: Thu,  5 Aug 2010 09:37:43 -0500
Message-Id: <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:12.0746 (UTC) FILETIME=[D4FAF6A0:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gdb debugger understands how to parse short versions of the thread
reference string as long as the bytes are paired in sets of two
characters.  The kgdb implementation was always sending 8 leading
zeros which could be omitted, and further optimized in the case of
non-negative thread numbers.  The negative numbers are used to
reference a specific cpu in the case of kgdb.

An example of the previous i386 stop packet looks like:
    T05thread:00000000000003bb;

New stop packet response:
    T05thread:03bb;

The previous ThreadInfo response looks like:
    m00000000fffffffe,0000000000000001,0000000000000002,0000000000000003,0000000000000004,0000000000000005,0000000000000006,0000000000000007,000000000000000c,0000000000000088,000000000000008a,000000000000008b,000000000000008c,000000000000008d,000000000000008e,00000000000000d4,00000000000000d5,00000000000000dd

New ThreadInfo response:
    mfffffffe,01,02,03,04,05,06,07,0c,88,8a,8b,8c,8d,8e,d4,d5,dd

A few bytes saved means better response time when using kgdb over a
serial line.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/gdbstub.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 3517fd7..e117cfd 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -367,28 +367,31 @@ static void error_packet(char *pkt, int error)
  * remapped to negative TIDs.
  */
 
-#define BUF_THREAD_ID_SIZE	16
+#define BUF_THREAD_ID_SIZE	8
 
 static char *pack_threadid(char *pkt, unsigned char *id)
 {
-	char *limit;
+	unsigned char *limit;
+	int lzero = 1;
+
+	limit = id + (BUF_THREAD_ID_SIZE / 2);
+	while (id < limit) {
+		if (!lzero || *id != 0) {
+			pkt = pack_hex_byte(pkt, *id);
+			lzero = 0;
+		}
+		id++;
+	}
 
-	limit = pkt + BUF_THREAD_ID_SIZE;
-	while (pkt < limit)
-		pkt = pack_hex_byte(pkt, *id++);
+	if (lzero)
+		pkt = pack_hex_byte(pkt, 0);
 
 	return pkt;
 }
 
 static void int_to_threadref(unsigned char *id, int value)
 {
-	unsigned char *scan;
-	int i = 4;
-
-	scan = (unsigned char *)id;
-	while (i--)
-		*scan++ = 0;
-	put_unaligned_be32(value, scan);
+	put_unaligned_be32(value, id);
 }
 
 static struct task_struct *getthread(struct pt_regs *regs, int tid)
@@ -601,7 +604,7 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 {
 	struct task_struct *g;
 	struct task_struct *p;
-	unsigned char thref[8];
+	unsigned char thref[BUF_THREAD_ID_SIZE];
 	char *ptr;
 	int i;
 	int cpu;
@@ -621,8 +624,7 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 			for_each_online_cpu(cpu) {
 				ks->thr_query = 0;
 				int_to_threadref(thref, -cpu - 2);
-				pack_threadid(ptr, thref);
-				ptr += BUF_THREAD_ID_SIZE;
+				ptr = pack_threadid(ptr, thref);
 				*(ptr++) = ',';
 				i++;
 			}
@@ -631,8 +633,7 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 		do_each_thread(g, p) {
 			if (i >= ks->thr_query && !finished) {
 				int_to_threadref(thref, p->pid);
-				pack_threadid(ptr, thref);
-				ptr += BUF_THREAD_ID_SIZE;
+				ptr = pack_threadid(ptr, thref);
 				*(ptr++) = ',';
 				ks->thr_query++;
 				if (ks->thr_query % KGDB_MAX_THREAD_QUERY == 0)
@@ -851,7 +852,7 @@ int gdb_serial_stub(struct kgdb_state *ks)
 	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
 
 	if (kgdb_connected) {
-		unsigned char thref[8];
+		unsigned char thref[BUF_THREAD_ID_SIZE];
 		char *ptr;
 
 		/* Reply to host that an exception has occurred */
-- 
1.6.3.3

