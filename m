Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0L0XDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:03:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:49141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab0L0XDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:03:18 -0500
Date: Mon, 27 Dec 2010 23:00:51 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <E1PSBcz-0001g1-FM@eag09.americas.sgi.com>
References: <E1PSBcz-0001g1-FM@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86, paravirt: Use native_halt on a halt, not native_safe_halt
Message-ID: <tip-c8217b8305e5e75c23617f2f4cd262527d952c0a@git.kernel.org>
Git-Commit-ID: c8217b8305e5e75c23617f2f4cd262527d952c0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 27 Dec 2010 23:00:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8217b8305e5e75c23617f2f4cd262527d952c0a
Gitweb:     http://git.kernel.org/tip/c8217b8305e5e75c23617f2f4cd262527d952c0a
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Mon, 13 Dec 2010 10:51:57 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 27 Dec 2010 14:02:11 -0800

x86, paravirt: Use native_halt on a halt, not native_safe_halt

halt() should use native_halt()
safe_halt() uses native_safe_halt()

If CONFIG_PARAVIRT=y, halt() is defined in arch/x86/include/asm/paravirt.h as

static inline void halt(void)
{
        PVOP_VCALL0(pv_irq_ops.safe_halt);
}

Otherwise (no CONFIG_PARAVIRT) halt() in arch/x86/include/asm/irqflags.h is

static inline void halt(void)
{
        native_halt();
}

So it looks to me like the CONFIG_PARAVIRT case of using native_safe_halt()
for a halt() is an oversight.
Am I missing something?

It probably hasn't shown up as a problem because the local apic is disabled
on a shutdown or restart.  But if we disable interrupts and call halt()
we shouldn't expect that the halt() will re-enable interrupts.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1PSBcz-0001g1-FM@eag09.americas.sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ef99758..7709c12 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -112,7 +112,7 @@ static inline void arch_safe_halt(void)
 
 static inline void halt(void)
 {
-	PVOP_VCALL0(pv_irq_ops.safe_halt);
+	PVOP_VCALL0(pv_irq_ops.halt);
 }
 
 static inline void wbinvd(void)
