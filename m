Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1FPLTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:19:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:45225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1FPLTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:19:17 -0400
Date: Thu, 16 Jun 2011 11:19:08 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-3a97fc34130326da87b20de5d0259c35406707ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED74B.20502@jp.fujitsu.com>
References: <4DEED74B.20502@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Check the result of ancient_init()
Git-Commit-ID: 3a97fc34130326da87b20de5d0259c35406707ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a97fc34130326da87b20de5d0259c35406707ce
Gitweb:     http://git.kernel.org/tip/3a97fc34130326da87b20de5d0259c35406707ce
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:58:35 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:12 +0200

x86, mce: Check the result of ancient_init()

Because "ancient CPUs" like p5 and winchip don't have X86_FEATURE_MCA
(I suppose so), mcheck_cpu_init() on such CPUs will return at check of
mce_available() after __mcheck_cpu_ancient_init().

It is hard to know this implicit behavior without knowing the CPUs
well. So make it clear that we leave mcheck_cpu_init() when the CPU is
initialized in __mcheck_cpu_ancient_init().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED74B.20502@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a182875..2cc98d5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1332,18 +1332,23 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 	return 0;
 }
 
-static void __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
+static int __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
 	if (c->x86 != 5)
-		return;
+		return 0;
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
+		return 1;
 		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
+		return 1;
 		break;
 	}
+
+	return 0;
 }
 
 static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
@@ -1397,7 +1402,8 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	if (mce_disabled)
 		return;
 
-	__mcheck_cpu_ancient_init(c);
+	if (__mcheck_cpu_ancient_init(c))
+		return;
 
 	if (!mce_available(c))
 		return;
