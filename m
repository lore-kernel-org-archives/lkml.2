Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0GASNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:13:40 -0400
Received: from kroah.org ([198.145.64.141]:60053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0GASKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:51 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:28:57 2010
Message-Id: <20100701172857.381949596@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:27:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Kosina <jkosina@suse.cz>, Corey Minyard <minyard@acm.org>
Subject: [11/23] ipmi: handle run_to_completion properly in deliver_recv_msg()
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit a747c5abc329611220f16df0bb4cf0ca4a7fdf0c upstream.

If run_to_completion flag is set, it means that we are running in a
single-threaded mode, and thus no locks are held.

This fixes a deadlock when IPMI notifier is being called during panic.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/ipmi/ipmi_si_intf.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -313,9 +313,14 @@ static void deliver_recv_msg(struct smi_
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


