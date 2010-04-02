Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0DBTPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:15:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:46771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab0DBTOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:14:54 -0400
Date: Fri, 2 Apr 2010 19:14:31 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, youquan.song@intel.com, jbarnes@virtuousgeek.org,
       david.woodhouse@intel.com, suresh.b.siddha@intel.com,
       Jan.Grossmann@kielnet.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, youquan.song@intel.com, jbarnes@virtuousgeek.org,
       david.woodhouse@intel.com, Jan.Grossmann@kielnet.net,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
References: <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix double enable_IR_x2apic() call on SMP kernel on !SMP boards
Message-ID: <tip-472a474c6630efd195d3738339fd1bdc8aa3b1aa@git.kernel.org>
Git-Commit-ID: 472a474c6630efd195d3738339fd1bdc8aa3b1aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:14:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  472a474c6630efd195d3738339fd1bdc8aa3b1aa
Gitweb:     http://git.kernel.org/tip/472a474c6630efd195d3738339fd1bdc8aa3b1aa
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 31 Mar 2010 18:04:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:48:47 +0200

x86: Fix double enable_IR_x2apic() call on SMP kernel on !SMP boards

Jan Grossmann reported kernel boot panic while booting SMP
kernel on his system with a single core cpu. SMP kernels call
enable_IR_x2apic() from native_smp_prepare_cpus() and on
platforms where the kernel doesn't find SMP configuration we
ended up again calling enable_IR_x2apic() from the
APIC_init_uniprocessor() call in the smp_sanity_check(). Thus
leading to kernel panic.

Don't call enable_IR_x2apic() and default_setup_apic_routing()
from APIC_init_uniprocessor() in CONFIG_SMP case.

NOTE: this kind of non-idempotent and assymetric initialization
sequence is rather fragile and unclean, we'll clean that up
in v2.6.35. This is the minimal fix for v2.6.34.

Reported-by: Jan.Grossmann@kielnet.net
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <jbarnes@virtuousgeek.org>
Cc: <david.woodhouse@intel.com>
Cc: <weidong.han@intel.com>
Cc: <youquan.song@intel.com>
Cc: <Jan.Grossmann@kielnet.net>
Cc: <stable@kernel.org> # [v2.6.32.x, v2.6.33.x]
LKML-Reference: <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 00187f1..e5a4a1e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1640,8 +1640,10 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
+#ifndef CONFIG_SMP
 	enable_IR_x2apic();
 	default_setup_apic_routing();
+#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
