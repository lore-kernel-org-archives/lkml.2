Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1DFU2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:28:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:57715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab1DFU2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:28:33 -0400
Date: Wed, 6 Apr 2011 20:28:00 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <201104020154.57136.rjw@sisk.pl>
References: <201104020154.57136.rjw@sisk.pl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hibernate: Initialize mmu_cr4_features during boot
Message-ID: <tip-4da9484bdece39ab0b098fa711e095e3e9fc8684@git.kernel.org>
Git-Commit-ID: 4da9484bdece39ab0b098fa711e095e3e9fc8684
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 20:28:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4da9484bdece39ab0b098fa711e095e3e9fc8684
Gitweb:     http://git.kernel.org/tip/4da9484bdece39ab0b098fa711e095e3e9fc8684
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 6 Apr 2011 13:10:02 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Apr 2011 13:10:02 -0700

x86, hibernate: Initialize mmu_cr4_features during boot

Restore the initialization of mmu_cr4_features during boot, which was
removed without comment in checkin e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e

x86: Cleanup highmap after brk is concluded

thereby breaking resume from hibernate.  This restores previous
functionality in approximately the same place, and corrects the
reading of %cr4 on pre-CPUID hardware (%cr4 exists if and only if
CPUID is supported.)

However, part of the problem is that the hibernate suspend/resume
sequence should manage the save/restore of %cr4 explicitly.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <201104020154.57136.rjw@sisk.pl>
---
 arch/x86/kernel/setup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5a0484a..4be9b39 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -976,6 +976,11 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
+	if (boot_cpu_data.cpuid_level >= 0) {
+		/* A CPU has %cr4 if and only if it has CPUID */
+		mmu_cr4_features = read_cr4();
+	}
+
 #ifdef CONFIG_X86_32
 	/* sync back kernel address range */
 	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
