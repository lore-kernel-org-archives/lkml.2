Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2HGDK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:10:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab2HGDKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:10:55 -0400
Date: Mon, 6 Aug 2012 20:10:43 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-057237bb35a605d795fd787868a1088705f26ee5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1344272439-29080-5-git-send-email-bp@amd64.org>
References: <1344272439-29080-5-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, cpu: Preset default tlb_flushall_shift on AMD
Git-Commit-ID: 057237bb35a605d795fd787868a1088705f26ee5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 06 Aug 2012 20:10:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  057237bb35a605d795fd787868a1088705f26ee5
Gitweb:     http://git.kernel.org/tip/057237bb35a605d795fd787868a1088705f26ee5
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 6 Aug 2012 19:00:39 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 6 Aug 2012 19:18:39 -0700

x86, cpu: Preset default tlb_flushall_shift on AMD

Run the mprotect.c microbenchmark on all our families >= K8 and preset
the flushall shift variable accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344272439-29080-5-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bcd2008..f7e98a2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -737,6 +737,17 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 }
 #endif
 
+static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
+{
+	if (!cpu_has_invlpg)
+		return;
+
+	tlb_flushall_shift = 5;
+
+	if (c->x86 <= 0x11)
+		tlb_flushall_shift = 4;
+}
+
 static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 {
 	u32 ebx, eax, ecx, edx;
@@ -788,6 +799,8 @@ static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 		tlb_lli_2m[ENTRIES] = eax & mask;
 
 	tlb_lli_4m[ENTRIES] = tlb_lli_2m[ENTRIES] >> 1;
+
+	cpu_set_tlb_flushall_shift(c);
 }
 
 static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
