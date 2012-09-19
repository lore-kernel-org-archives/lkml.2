Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2ISRFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:05:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2ISRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:05:16 -0400
Date: Wed, 19 Sep 2012 10:05:03 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-924e101a7ab6f884047f4344e5f1154a4bcd63a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1347640666-13638-1-git-send-email-bp@amd64.org>
References: <1347640666-13638-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/debug: Dump family, model,
  stepping of the boot CPU
Git-Commit-ID: 924e101a7ab6f884047f4344e5f1154a4bcd63a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 10:05:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  924e101a7ab6f884047f4344e5f1154a4bcd63a6
Gitweb:     http://git.kernel.org/tip/924e101a7ab6f884047f4344e5f1154a4bcd63a6
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 14 Sep 2012 18:37:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Sep 2012 17:12:01 +0200

x86/debug: Dump family, model, stepping of the boot CPU

When acting on a user bug report, we find ourselves constantly
asking for /proc/cpuinfo in order to know the exact family,
model, stepping of the CPU in question.

Instead of having to ask this, add this to dmesg so that it is
visible and no ambiguities can ensue from looking at the
official name string of the CPU coming from CPUID and trying
to map it to f/m/s.

Output then looks like this:

[    0.146041] smpboot: CPU0: AMD FX(tm)-8100 Eight-Core Processor (fam: 15, model: 01, stepping: 02)

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/1347640666-13638-1-git-send-email-bp@amd64.org
[ tweaked it minimally to add commas. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/common.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a5fbc3c..1cc48ff 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1023,14 +1023,16 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 		printk(KERN_CONT "%s ", vendor);
 
 	if (c->x86_model_id[0])
-		printk(KERN_CONT "%s", c->x86_model_id);
+		printk(KERN_CONT "%s", strim(c->x86_model_id));
 	else
 		printk(KERN_CONT "%d86", c->x86);
 
+	printk(KERN_CONT " (fam: %02x, model: %02x", c->x86, c->x86_model);
+
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
+		printk(KERN_CONT ", stepping: %02x)\n", c->x86_mask);
 	else
-		printk(KERN_CONT "\n");
+		printk(KERN_CONT ")\n");
 
 	print_cpu_msr(c);
 }
