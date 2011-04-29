Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab1D2Pdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:33:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab1D2P27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UlWhpZMatpc8LhJH44S8PyxLeQXrv7QFEYZUiGjnetegMg9QwhwvTUkfXZ8ceryALC
         bsdl8azcUj9q1B4nn6KVlLQu7WJ1XHgc0u2Ts9TqnMC169L7DKllj+aeUR6Cj9RJCikG
         fO917jOzvUytRF82U3GwhEkQO0hTnNbwE/Rj8=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/25] x86-32, NUMA: Automatically set apicid -> node in setup_local_APIC()
Date: Fri, 29 Apr 2011 17:28:23 +0200
Message-Id: <1304090924-8197-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some x86-32 NUMA implementations (NUMAQ) don't initialize apicid ->
node mapping using set_apicid_to_node() during NUMA init but implement
custom apic->x86_32_numa_cpu_node() instead.

This patch automatically initializes the default apic -> node mapping
table from apic->x86_32_numa_cpu_node() from setup_local_APIC() such
that the mapping table is in sync with the actual mapping.

As the table isn't used by custom implementations, this doesn't make
any difference at this point.  This is in preparation of unifying
numa_cpu_node() between x86-32 and 64.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/apic/apic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2bc503b..a6cd02a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1237,6 +1237,16 @@ void __cpuinit setup_local_APIC(void)
 	/* always use the value from LDR */
 	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
 		logical_smp_processor_id();
+
+	/*
+	 * Some NUMA implementations (NUMAQ) don't initialize apicid to
+	 * node mapping during NUMA init.  Now that logical apicid is
+	 * guaranteed to be known, give it another chance.  This is already
+	 * a bit too late - percpu allocation has already happened without
+	 * proper NUMA affinity.
+	 */
+	set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
+			   apic->x86_32_numa_cpu_node(cpu));
 #endif
 
 	/*
-- 
1.7.1

