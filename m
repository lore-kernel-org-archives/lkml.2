Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2GTX0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:26:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2GTX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:26:14 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 03/11] perf kvm: guest userspace samples should not be lumped with host uspace
Date: Fri, 20 Jul 2012 17:25:48 -0600
Message-Id: <1342826756-64663-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e.g., perf kvm --host  --guest report -i perf.data --stdio -D
shows:

1 599127912065356 0x143b8 [0x48]: PERF_RECORD_SAMPLE(IP, 5): 5671/5676: 0x7fdf95a061c0 period: 1 addr: 0
... chain: nr:2
.....  0: ffffffffffffff80
.....  1: fffffffffffffe00
 ... thread: qemu-kvm:5671
 ...... dso: <not found>

(IP, 5) means sample in guest userspace. Those samples should not be lumped
into the VMM's host thread. i.e, the report output:

    56.86%  qemu-kvm  [unknown]         [u] 0x00007fdf95a061c0

With this patch the output emphasizes it is a guest userspace hit:

    56.86%  [guest/5671]  [unknown]         [u] 0x00007fdf95a061c0

Looking at 3 VMs (2 64-bit, 1 32-bit) with each running a CPU bound
process (openssl speed), perf report currently shows:

  93.84%  117726   qemu-kvm  [unknown]   [u] 0x00007fd7dcaea8e5

which is wrong. With this patch you get:

  31.50%   39258   [guest/18772]  [unknown]   [u] 0x00007fd7dcaea8e5
  31.50%   39236   [guest/11230]  [unknown]   [u] 0x0000000000a57340
  30.84%   39232   [guest/18395]  [unknown]   [u] 0x00007f66f641e107

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/session.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8e48559..90ee39d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -918,7 +918,9 @@ static struct machine *
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
+	if (perf_guest &&
+	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
+	     (cpumode == PERF_RECORD_MISC_GUEST_USER))) {
 		u32 pid;
 
 		if (event->header.type == PERF_RECORD_MMAP)
-- 
1.7.10.1

