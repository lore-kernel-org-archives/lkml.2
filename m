Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab1EZSNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810Ab1EZSNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:13:33 -0400
Date: Thu, 26 May 2011 18:13:16 GMT
From: tip-bot for Boris Ostrovsky <ostr@amd64.org>
Message-ID: <tip-e9cdd343a5e42c43bcda01e609fa23089e026470@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        Andreas.Herrmann3@amd.com, cebbert@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, ostr@amd64.org, borislav.petkov@amd.com,
        Hans.Rosenfeld@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andreas.Herrmann3@amd.com, cebbert@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, ostr@amd64.org, Hans.Rosenfeld@amd.com,
        borislav.petkov@amd.com
In-Reply-To: <1306423192-19774-1-git-send-email-ostr@amd64.org>
References: <1306423192-19774-1-git-send-email-ostr@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd: Do not enable ARAT feature on AMD processors below family 0x12
Git-Commit-ID: e9cdd343a5e42c43bcda01e609fa23089e026470
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 18:13:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9cdd343a5e42c43bcda01e609fa23089e026470
Gitweb:     http://git.kernel.org/tip/e9cdd343a5e42c43bcda01e609fa23089e026470
Author:     Boris Ostrovsky <ostr@amd64.org>
AuthorDate: Thu, 26 May 2011 11:19:52 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 May 2011 10:38:30 -0700

x86, amd: Do not enable ARAT feature on AMD processors below family 0x12

Commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 added support for
ARAT (Always Running APIC timer) on AMD processors that are not
affected by erratum 400. This erratum is present on certain processor
families and prevents APIC timer from waking up the CPU when it
is in a deep C state, including C1E state.

Determining whether a processor is affected by this erratum may
have some corner cases and handling these cases is somewhat
complicated. In the interest of simplicity we won't claim ARAT
support on processor families below 0x12 and will go back to
broadcasting timer when going idle.

Signed-off-by: Boris Ostrovsky <ostr@amd64.org>
Link: http://lkml.kernel.org/r/1306423192-19774-1-git-send-email-ostr@amd64.org
Tested-by: Boris Petkov <borislav.petkov@amd.com>
Cc: Hans Rosenfeld <Hans.Rosenfeld@amd.com>
Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: stable@kernel.org # 32.x, 38.x, 39.x
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8f5cabb..b13ed39 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -612,8 +612,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	/*
+	 * Family 0x12 and above processors have APIC timer
+	 * running in deep C states.
+	 */
+	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
