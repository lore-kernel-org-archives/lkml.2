Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab2FFVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:54:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:52280 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab2FFVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:53:24 -0400
Message-Id: <20120606215116.546087209@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:53:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/5] x86: mce: Serialize mce injection
References: <20120606214941.104735929@linutronix.de>
Content-Disposition: inline; filename=x86-mce-serialize-mce-injection.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raise_mce() fiddles with global state, but lacks any kind of
serialization.

Add a mutex around the raise_mce() call, so concurrent writers do not
stomp on each other toes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: tip/arch/x86/kernel/cpu/mcheck/mce-inject.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ tip/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -78,6 +78,7 @@ static void raise_exception(struct mce *
 }
 
 static cpumask_var_t mce_inject_cpumask;
+static DEFINE_MUTEX(mce_inject_mutex);
 
 static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
@@ -229,7 +230,10 @@ static ssize_t mce_write(struct file *fi
 	 * so do it a jiffie or two later everywhere.
 	 */
 	schedule_timeout(2);
+
+	mutex_lock(&mce_inject_mutex);
 	raise_mce(&m);
+	mutex_unlock(&mce_inject_mutex);
 	return usize;
 }
 


