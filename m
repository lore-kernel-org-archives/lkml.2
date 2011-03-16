Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1CPN5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:57:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1CPN5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:57:31 -0400
Date: Wed, 16 Mar 2011 13:57:04 GMT
From: tip-bot for Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, boris.ostrovsky@amd.com,
        mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, boris.ostrovsky@amd.com,
        mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu,
        borislav.petkov@amd.com
In-Reply-To: <1300205624-4813-1-git-send-email-ostr@amd64.org>
References: <1300205624-4813-1-git-send-email-ostr@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD: Set ARAT feature on AMD processors
Message-ID: <tip-b87cf80af3ba4b4c008b4face3c68d604e1715c6@git.kernel.org>
Git-Commit-ID: b87cf80af3ba4b4c008b4face3c68d604e1715c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:57:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b87cf80af3ba4b4c008b4face3c68d604e1715c6
Gitweb:     http://git.kernel.org/tip/b87cf80af3ba4b4c008b4face3c68d604e1715c6
Author:     Boris Ostrovsky <boris.ostrovsky@amd.com>
AuthorDate: Tue, 15 Mar 2011 12:13:44 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:03:33 +0100

x86, AMD: Set ARAT feature on AMD processors

Support for Always Running APIC timer (ARAT) was introduced in
commit db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature
allows us to avoid switching timers from LAPIC to something else
(e.g. HPET) and go into timer broadcasts when entering deep
C-states.

AMD processors don't provide a CPUID bit for that feature but
they also keep APIC timers running in deep C-states (except for
cases when the processor is affected by erratum 400). Therefore
we should set ARAT feature bit on AMD CPUs.

Tested-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
LKML-Reference: <1300205624-4813-1-git-send-email-ostr@amd64.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/amd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c7bedb..48eaa1b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -594,6 +594,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32
