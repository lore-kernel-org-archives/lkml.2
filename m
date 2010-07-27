Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0G0QBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab0G0QBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:01:43 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] ipmi: Run a dummy command before submitting a new command
Date: Tue, 27 Jul 2010 12:01:33 -0400
Message-Id: <1280246493-964-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer firmware revisions on HP's ILO3 (1.05 and later) generate state
machine errors with the current IPMI code. Running through the IPMI
timeout handler once before submitting the command avoids this.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index e39a744..3f06199 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -317,6 +317,7 @@ static int unload_when_empty = 1;
 static int add_smi(struct smi_info *smi);
 static int try_smi_init(struct smi_info *smi);
 static void cleanup_one_si(struct smi_info *to_clean);
+static void smi_timeout(unsigned long data);
 
 static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
 static int register_xaction_notifier(struct notifier_block *nb)
@@ -897,6 +898,7 @@ static void sender(void                *send_info,
 #endif
 
 	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+	smi_timeout((unsigned long)smi_info);
 
 	if (smi_info->thread)
 		wake_up_process(smi_info->thread);
-- 
1.7.1.1

