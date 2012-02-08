Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2BHOcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:32:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab2BHOcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:32:15 -0500
Date: Wed, 8 Feb 2012 15:32:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org, Raymund Will <rw@suse.de>,
        linux-ia64@vger.kernel.org
Subject: [PATCH] [IA64] disable interrupts when exiting from
 ia64_mca_cmc_int_handler()
Message-ID: <alpine.LNX.2.00.1202081530510.24127@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SAL specification mandates that ia64_mca_log_sal_error_record() gets 
called with interrupts enabled, and that's why ia64_mca_cmc_int_handler() 
is enabling them. It however forgets to re-disable them when exiting, 
which triggers WARN_ON() in generic IRQ handler.

Disable the interrupts again before exiting. This is analogous to 
a3967685745 ("[IA64] disable interrupts at end of 
ia64_mca_cpe_int_handler()").

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/ia64/kernel/mca.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 84fb405..8192009 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1447,6 +1447,8 @@ out:
 	/* Get the CMC error record and log it */
 	ia64_mca_log_sal_error_record(SAL_INFO_TYPE_CMC);
 
+	local_irq_disable();
+
 	return IRQ_HANDLED;
 }
 
-- 
Jiri Kosina
SUSE Labs
