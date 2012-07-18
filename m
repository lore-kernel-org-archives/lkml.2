Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2GRH7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:59:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:25251 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab2GRH6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:58:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="167823885"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 1/5] x86: mce: Disable preemption when calling raise_local()
Date: Wed, 18 Jul 2012 15:59:30 -0400
Message-Id: <1342641574-32126-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
References: <1342641574-32126-1-git-send-email-gong.chen@linux.intel.com>
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

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index fc4beb3..753746f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
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
-- 
1.7.10.4

