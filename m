Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab0DVUWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:22:41 -0400
Received: from kroah.org ([198.145.64.141]:59687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab0DVUAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:21 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:10 2010
Message-Id: <20100422195410.361876407@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Siddha <suresh.b.siddha@intel.com>, <jbarnes@virtuousgeek.org>,
       <david.woodhouse@intel.com>, <weidong.han@intel.com>,
       <youquan.song@intel.com>, <Jan.Grossmann@kielnet.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: [055/139] x86: Fix double enable_IR_x2apic() call on SMP kernel on !SMP boards
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 472a474c6630efd195d3738339fd1bdc8aa3b1aa upstream.

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
LKML-Reference: <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/apic.c |    2 ++
 1 file changed, 2 insertions(+)

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


