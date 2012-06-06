Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2FFV1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:27:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:52054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2FFV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:27:15 -0400
Message-Id: <20120606212334.578122889@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:27:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/6] x86: mce: Disable preemption when calling raise_local()
References: <20120606211746.693649684@linutronix.de>
Content-Disposition: inline;
 filename=x86-mce-disable-preemption-when-calling-raise-local.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raise_mce() has a code path which does not disable preemption when the
raise_local() is called. The per cpu variable access in raise_local()
depends on preemption being disabled to be functional. So that code
path was either never tested or never tested with CONFIG_DEBUG_PREEMPT
enabled.

Add the missing preempt_disable/enable() pair around the call.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: tip/arch/x86/kernel/cpu/mcheck/mce-inject.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -194,7 +194,11 @@ static void raise_mce(struct mce *m)
 		put_online_cpus();
 	} else
 #endif
+	{
+		preempt_disable();
 		raise_local();
+		preempt_enable();
+	}
 }
 
 /* Error injection interface */


