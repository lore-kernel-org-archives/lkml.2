Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab2FGWAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:00:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab2FGWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:00:43 -0400
Date: Thu, 7 Jun 2012 15:00:30 -0700
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Message-ID: <tip-169e9cbd77db23fe50bc8ba68bf081adb67b4220@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, andreas.herrmann3@amd.com,
        andre.przywara@amd.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, andreas.herrmann3@amd.com,
        andre.przywara@amd.com, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1338562358-28182-4-git-send-email-bp@amd64.org>
References: <1338562358-28182-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu, amd:
  Fix crash as Xen Dom0 on AMD Trinity systems
Git-Commit-ID: 169e9cbd77db23fe50bc8ba68bf081adb67b4220
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 07 Jun 2012 15:00:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  169e9cbd77db23fe50bc8ba68bf081adb67b4220
Gitweb:     http://git.kernel.org/tip/169e9cbd77db23fe50bc8ba68bf081adb67b4220
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Fri, 1 Jun 2012 16:52:37 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Jun 2012 11:43:30 -0700

x86, cpu, amd: Fix crash as Xen Dom0 on AMD Trinity systems

f7f286a910221 ("x86/amd: Re-enable CPU topology extensions in case BIOS
has disabled it") wrongfully added code which used the AMD-specific
{rd,wr}msr variants for no real reason.

This caused boot panics on xen which wasn't initializing the
{rd,wr}msr_safe_regs pv_ops members properly.

This, in turn, caused a heated discussion leading to us reviewing all
uses of the AMD-specific variants and removing them where unneeded
(almost everywhere except an obscure K8 BIOS fix, see 6b0f43ddfa358).

Finally, this patch switches to the standard {rd,wr}msr*_safe* variants
which should've been used in the first place anyway and avoided unneeded
excitation with xen.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Link: http://lkml.kernel.org/r/1338562358-28182-4-git-send-email-bp@amd64.org
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: <http://lkml.kernel.org/r/1338383402-3838-1-git-send-email-andre.przywara@amd.com>
[Boris: correct and expand commit message]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 146bb62..80ccd99 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -586,9 +586,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
 		u64 val;
 
-		if (!rdmsrl_amd_safe(0xc0011005, &val)) {
+		if (!rdmsrl_safe(0xc0011005, &val)) {
 			val |= 1ULL << 54;
-			wrmsrl_amd_safe(0xc0011005, val);
+			checking_wrmsrl(0xc0011005, val);
 			rdmsrl(0xc0011005, val);
 			if (val & (1ULL << 54)) {
 				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
