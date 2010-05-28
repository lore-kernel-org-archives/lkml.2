Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0E1S3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:29:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:50540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0E1S3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:29:07 -0400
Date: Fri, 28 May 2010 18:27:40 GMT
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org,
       linuxppc-dev@lists.ozlabs.org, peterz@infradead.org,
       srostedt@redhat.com, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       peterz@infradead.org, linuxppc-dev@lists.ozlabs.org,
       srostedt@redhat.com, sfr@canb.auug.org.au, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100528150842.d5a751ba.sfr@canb.auug.org.au>
References: <20100528150842.d5a751ba.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing, powerpc: Fix for tracepoint API change
Message-ID: <tip-a578f4255763514dc9d0c4f2a60cf5b9323e0b6b@git.kernel.org>
Git-Commit-ID: a578f4255763514dc9d0c4f2a60cf5b9323e0b6b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 May 2010 18:27:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a578f4255763514dc9d0c4f2a60cf5b9323e0b6b
Gitweb:     http://git.kernel.org/tip/a578f4255763514dc9d0c4f2a60cf5b9323e0b6b
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Fri, 28 May 2010 15:08:42 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 May 2010 16:27:11 +0200

tracing, powerpc: Fix for tracepoint API change

Commit 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e "tracing: Let
tracepoints have data passed to tracepoint callbacks" requires
this fixup to the powerpc code.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Cc: Linus <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: paulus@samba.org
Cc: Anton Blanchard ZZ <anton@samba.org>
LKML-Reference: <20100528150842.d5a751ba.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/platforms/pseries/hvCall_inst.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hvCall_inst.c b/arch/powerpc/platforms/pseries/hvCall_inst.c
index 1fefae7..e19ff02 100644
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c
+++ b/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -102,7 +102,7 @@ static const struct file_operations hcall_inst_seq_fops = {
 #define CPU_NAME_BUF_SIZE	32
 
 
-static void probe_hcall_entry(unsigned long opcode, unsigned long *args)
+static void probe_hcall_entry(void *ignored, unsigned long opcode, unsigned long *args)
 {
 	struct hcall_stats *h;
 
@@ -114,7 +114,7 @@ static void probe_hcall_entry(unsigned long opcode, unsigned long *args)
 	h->purr_start = mfspr(SPRN_PURR);
 }
 
-static void probe_hcall_exit(unsigned long opcode, unsigned long retval,
+static void probe_hcall_exit(void *ignored, unsigned long opcode, unsigned long retval,
 			     unsigned long *retbuf)
 {
 	struct hcall_stats *h;
@@ -140,11 +140,11 @@ static int __init hcall_inst_init(void)
 	if (!firmware_has_feature(FW_FEATURE_LPAR))
 		return 0;
 
-	if (register_trace_hcall_entry(probe_hcall_entry))
+	if (register_trace_hcall_entry(probe_hcall_entry, NULL))
 		return -EINVAL;
 
-	if (register_trace_hcall_exit(probe_hcall_exit)) {
-		unregister_trace_hcall_entry(probe_hcall_entry);
+	if (register_trace_hcall_exit(probe_hcall_exit, NULL)) {
+		unregister_trace_hcall_entry(probe_hcall_entry, NULL);
 		return -EINVAL;
 	}
 
