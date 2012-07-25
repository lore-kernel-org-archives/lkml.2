Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab2GYRqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:46:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55591 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2GYRlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/19] perf kvm: Guest userspace samples should not be lumped with host uspace
Date: Wed, 25 Jul 2012 14:41:18 -0300
Message-Id: <1343238094-12481-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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

Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1342826756-64663-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

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
1.7.1

