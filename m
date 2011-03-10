Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1CJTNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:13:14 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:48845 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1CJTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:13:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: TEXT/PLAIN
From: Corey Minyard <minyard@acm.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        YiCheng Doe <yicheng.doe@hp.com>,
        Tom Mingarelli <thomas.mingarelli@hp.com>,
        Andy Cress <andy.cress@us.kontron.com>,
        Mika Lansirine <Mika.Lansirinne@stonesoft.com>,
        Brian De Wolf <bldewolf@csupomona.edu>,
        Jean Michel Audet <Jean-Michel.Audet@ca.Kontron.com>,
        Jozef Sudelsky <jozef.sudolsky@elbiahosting.sk>,
        Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] ipmi: Fix IPMI errors due to timing problems
Date: Thu, 10 Mar 2011 13:12:50 -0600
Message-id: <1299784370-18061-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doe, YiCheng <yicheng.doe@hp.com>

This patch fixes an issue in OpenIPMI module where sometimes an ABORT command
is sent after sending an IPMI request to BMC causing the IPMI request to fail.

Signed-off-by: YiCheng Doe <yicheng.doe@hp.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Tom Mingarelli <thomas.mingarelli@hp.com>
Tested-by: Andy Cress <andy.cress@us.kontron.com>
Tested-by: Mika Lansirine <Mika.Lansirinne@stonesoft.com>
Tested-by: Brian De Wolf <bldewolf@csupomona.edu>
Cc: Jean Michel Audet <Jean-Michel.Audet@ca.Kontron.com>
Cc: Jozef Sudelsky <jozef.sudolsky@elbiahosting.sk>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 7855f9f..5b88096 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -900,6 +900,14 @@ static void sender(void                *send_info,
 	printk("**Enqueue: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 
+	/*
+	 * last_timeout_jiffies is updated here to avoid
+	 * smi_timeout() handler passing very large time_diff
+	 * value to smi_event_handler() that causes
+	 * the send command to abort.
+	 */
+	smi_info->last_timeout_jiffies ÿiffies;
+
 	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
 
 	if (smi_info->thread)
-- 
1.7.1

