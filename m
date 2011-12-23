Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1LWUK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:10:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab1LWUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:10:56 -0500
Date: Fri, 23 Dec 2011 12:10:42 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-e8524b2f43ab6747518aef81c709d104c478b1cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20111222014632.484984298@sbsiddha-desk.sc.intel.com>
References: <20111222014632.484984298@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Add probe() for apic_flat
Git-Commit-ID: e8524b2f43ab6747518aef81c709d104c478b1cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 12:10:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8524b2f43ab6747518aef81c709d104c478b1cd
Gitweb:     http://git.kernel.org/tip/e8524b2f43ab6747518aef81c709d104c478b1cd
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 21 Dec 2011 17:45:15 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 23 Dec 2011 11:00:45 -0800

x86, apic: Add probe() for apic_flat

Currently we start with the default apic_flat mode and switch to some other
apic model depending on the apic drivers acpi_madt_oem_check() routines and
later followed by the apic drivers probe() routines.

Once we selected non flat mode there was no case where we fall back to
flat mode again.

Upcoming changes allow bios-enabled x2apic mode to be disabled by the OS
if interrupt-remapping etc is not setup properly by the bios.

We now has a case for the apic to fall back to legacy flat mode during
apic driver probe() seqeuence. Add a simple flat_probe() which allows
the apic_flat mode to be the last fallback option.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20111222014632.484984298@sbsiddha-desk.sc.intel.com
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/apic_flat_64.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 57c1f41..8c3cdde 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -171,9 +171,14 @@ static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
+static int flat_probe(void)
+{
+	return 1;
+}
+
 static struct apic apic_flat =  {
 	.name				= "flat",
-	.probe				= NULL,
+	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
