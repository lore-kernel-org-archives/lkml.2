Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2BVQPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:15:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2BVQPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:15:02 -0500
Date: Wed, 22 Feb 2012 08:13:56 -0800
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-3f806e50981825fa56a7f1938f24c0680816be45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, nbowler@elliptictech.com, hpa@zytor.com,
        mingo@redhat.com, rdunlap@xenotime.net, bp@alien8.de,
        kjwinchester@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, nbowler@elliptictech.com,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
        kjwinchester@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120203191801.GA2846@x1.osrc.amd.com>
References: <20120203191801.GA2846@x1.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce/AMD: Fix UP build error
Git-Commit-ID: 3f806e50981825fa56a7f1938f24c0680816be45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:14:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f806e50981825fa56a7f1938f24c0680816be45
Gitweb:     http://git.kernel.org/tip/3f806e50981825fa56a7f1938f24c0680816be45
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Fri, 3 Feb 2012 20:18:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 13:36:30 +0100

x86/mce/AMD: Fix UP build error

141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs
from 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs
around code touching struct cpuinfo_x86 members but also caused
the following build error with Randy's randconfigs:

mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'

Restore the #ifdef in threshold_create_bank() which creates
symlinks on the non-BSP CPUs.

There's a better patch series being worked on by Kevin Winchester
which will solve this in a cleaner fashion, but that series is
too ambitious for v3.3 merging - so we first queue up this trivial
fix and then do the rest for v3.4.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Acked-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Nick Bowler <nbowler@elliptictech.com>
Link: http://lkml.kernel.org/r/20120203191801.GA2846@x1.osrc.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 786e76a..e4eeaaf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -528,6 +528,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	sprintf(name, "threshold_bank%i", bank);
 
+#ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
 		i = cpumask_first(cpu_llc_shared_mask(cpu));
 
@@ -553,6 +554,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 		goto out;
 	}
+#endif
 
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
