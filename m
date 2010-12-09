Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0LIU41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:56:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:34978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab0LIU4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:56:25 -0500
Date: Thu, 9 Dec 2010 20:56:10 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        ebiederm@xmission.com
In-Reply-To: <4CFDF69C.9070501@kernel.org>
References: <4CFDF69C.9070501@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86, x2apic: Don't map lapic addr for preenabled x2apic systems
Message-ID: <tip-0450193bffed6e4b6160c4a5ccb0df158eba7d2a@git.kernel.org>
Git-Commit-ID: 0450193bffed6e4b6160c4a5ccb0df158eba7d2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:56:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0450193bffed6e4b6160c4a5ccb0df158eba7d2a
Gitweb:     http://git.kernel.org/tip/0450193bffed6e4b6160c4a5ccb0df158eba7d2a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 7 Dec 2010 00:55:56 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:05 +0100

x86, x2apic: Don't map lapic addr for preenabled x2apic systems

If x2apic is preenabled and used by the kernel, we don't need to map
the lapic address. That mapping will never be used.

So just skip that in register_lapic_address()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
LKML-Reference: <4CFDF69C.9070501@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 9303364..8933936 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1681,9 +1681,11 @@ void __init register_lapic_address(unsigned long address)
 {
 	mp_lapic_addr = address;
 
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, mp_lapic_addr);
+	if (!x2apic_mode) {
+		set_fixmap_nocache(FIX_APIC_BASE, address);
+		apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+			    APIC_BASE, mp_lapic_addr);
+	}
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
 		apic_version[boot_cpu_physical_apicid] =
