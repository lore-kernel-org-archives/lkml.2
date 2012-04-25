Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2DYPwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:52:20 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50993 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2DYPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:52:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/3] x86, MCE, AMD: Hide interrupt_enable sysfs node
Date: Wed, 25 Apr 2012 17:52:02 +0200
Message-Id: <1335369123-23196-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1335369123-23196-1-git-send-email-bp@amd64.org>
References: <1335369123-23196-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Depending on whether the box supports the APIC LVT interrupt for
thresholding, we want to show the 'interrupt_enable' sysfs node or not.
Make that the case by adding it to the default sysfs attributes only if
it is supported.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 2c1d178be46e..f4873a64f46d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -421,10 +421,10 @@ RW_ATTR(threshold_limit);
 RW_ATTR(error_count);
 
 static struct attribute *default_attrs[] = {
-	&interrupt_enable.attr,
 	&threshold_limit.attr,
 	&error_count.attr,
-	NULL
+	NULL,	/* possibly interrupt_enable if supported, see below */
+	NULL,
 };
 
 #define to_block(k)	container_of(k, struct threshold_block, kobj)
@@ -501,6 +501,11 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	b->interrupt_capable	= lvt_interrupt_supported(bank, high);
 	b->threshold_limit	= THRESHOLD_MAX;
 
+	if (b->interrupt_capable)
+		threshold_ktype.default_attrs[2] = &interrupt_enable.attr;
+	else
+		threshold_ktype.default_attrs[2] = NULL;
+
 	INIT_LIST_HEAD(&b->miscj);
 
 	if (per_cpu(threshold_banks, cpu)[bank]->blocks) {
-- 
1.7.9.3.362.g71319

