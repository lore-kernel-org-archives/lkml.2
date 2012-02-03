Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2BCPsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:48:30 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:50199 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab2BCPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:48:28 -0500
From: Corey Minyard <cminyard@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Srinivas_Gowda <srinivas_g_gowda@dell.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/6] ipmi: decreases the IPMI message transaction time in
 interrupt mode
Date: Fri, 03 Feb 2012 09:47:54 -0600
Message-id: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas_Gowda <srinivas_g_gowda@dell.com>

Call the event handler immediately after starting the next message.

This change considerably decreases the IPMI transaction time (cuts off
~9ms for a single ipmitool transaction).

From: Srinivas_Gowda <srinivas_g_gowda@dell.com>
Signed-off-by: Srinivas_Gowda <srinivas_g_gowda@dell.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 50fcf9c..73ebbb1 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -932,8 +932,10 @@ static void sender(void                *send_info,
 	spin_unlock_irqrestore(&smi_info->msg_lock, flags);
 
 	spin_lock_irqsave(&smi_info->si_lock, flags);
-	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL)
+	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL) {
 		start_next_msg(smi_info);
+		smi_event_handler(smi_info, 0);
+	}
 	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
-- 
1.7.4.1

