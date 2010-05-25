Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0EYImw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:42:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:48084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab0EYImu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:42:50 -0400
Date: Tue, 25 May 2010 10:42:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH] ipmi: handle run_to_completion properly in
 deliver_recv_msg()
Message-ID: <alpine.LNX.2.00.1005251034450.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If run_to_completion flag is set, it means that we are running in
a single-threaded mode, and thus no locks are held.

This fixes a deadlock when IPMI notifier is being called during panic.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/char/ipmi/ipmi_si_intf.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 47ffe4a..d1765b6 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -314,9 +314,14 @@ static void deliver_recv_msg(struct smi_info *smi_info,
 {
 	/* Deliver the message to the upper layer with the lock
 	   released. */
-	spin_unlock(&(smi_info->si_lock));
-	ipmi_smi_msg_received(smi_info->intf, msg);
-	spin_lock(&(smi_info->si_lock));
+
+	if (smi_info->run_to_completion) {
+		ipmi_smi_msg_received(smi_info->intf, msg);
+	} else {
+		spin_unlock(&(smi_info->si_lock));
+		ipmi_smi_msg_received(smi_info->intf, msg);
+		spin_lock(&(smi_info->si_lock));
+	}
 }
 
 static void return_hosed_msg(struct smi_info *smi_info, int cCode)
-- 
1.6.4.2

