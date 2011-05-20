Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452Ab1ETNkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:40:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933911Ab1ETNkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:40:35 -0400
Date: Fri, 20 May 2011 13:40:28 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-8f18c9711ed31c257d4f00a094b2fdbe72a741da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233158.089978277@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233158.089978277@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Consolidate mp_ioapic_routing[] into 'struct ioapic'
Git-Commit-ID: 8f18c9711ed31c257d4f00a094b2fdbe72a741da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:40:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f18c9711ed31c257d4f00a094b2fdbe72a741da
Gitweb:     http://git.kernel.org/tip/8f18c9711ed31c257d4f00a094b2fdbe72a741da
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 18 May 2011 16:31:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:41:02 +0200

x86, ioapic: Consolidate mp_ioapic_routing[] into 'struct ioapic'

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: daniel.blueman@gmail.com
Link: http://lkml.kernel.org/r/20110518233158.089978277@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b7dd233..9488dcf 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -89,6 +89,7 @@ static struct ioapic {
 	struct mpc_ioapic mp_config;
 	/* IO APIC gsi routing info */
 	struct mp_ioapic_gsi  gsi_config;
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
@@ -1356,10 +1357,6 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
 static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
 {
 	if (idx != -1)
@@ -3540,14 +3537,14 @@ int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 	int ret;
 
 	/* Avoid redundant programming */
-	if (test_bit(pin, mp_ioapic_routing[id].pin_programmed)) {
+	if (test_bit(pin, ioapics[id].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
 			 mpc_ioapic_id(id), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-		set_bit(pin, mp_ioapic_routing[id].pin_programmed);
+		set_bit(pin, ioapics[id].pin_programmed);
 	return ret;
 }
 
