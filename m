Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2EIF5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:57:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39102 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915Ab2EIFxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:51 -0400
Message-Id: <20120509055049.342511242@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 143/167] [PATCH] ipw2200: Fix race condition in the command completion
 acknowledge
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Yakovlev <stas.yakovlev@gmail.com>

commit dd447319895d0c0af423e483d9b63f84f3f8869a upstream.

Driver incorrectly validates command completion: instead of waiting
for a command to be acknowledged it continues execution.  Most of the
time driver gets acknowledge of the command completion in a tasklet
before it executes the next one. But sometimes it sends the next
command before it gets acknowledge for the previous one. In such a
case one of the following error messages appear in the log:

Failed to send SYSTEM_CONFIG: Already sending a command.
Failed to send ASSOCIATE: Already sending a command.
Failed to send TX_POWER: Already sending a command.

After that you need to reload the driver to get it working again.

This bug occurs during roaming (reported by Sam Varshavchik)
https://bugzilla.redhat.com/show_bug.cgi?id=738508
and machine booting (reported by Tom Gundersen and Mads Kiilerich)
https://bugs.archlinux.org/task/28097
https://bugzilla.redhat.com/show_bug.cgi?id=802106

This patch doesn't fix the delay issue during firmware load.
But at least device now works as usual after boot.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 2b02257..1779db3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2191,6 +2191,7 @@ static int __ipw_send_cmd(struct ipw_priv *priv, struct host_cmd *cmd)
 {
 	int rc = 0;
 	unsigned long flags;
+	unsigned long now, end;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->status & STATUS_HCMD_ACTIVE) {
@@ -2232,10 +2233,20 @@ static int __ipw_send_cmd(struct ipw_priv *priv, struct host_cmd *cmd)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	now = jiffies;
+	end = now + HOST_COMPLETE_TIMEOUT;
+again:
 	rc = wait_event_interruptible_timeout(priv->wait_command_queue,
 					      !(priv->
 						status & STATUS_HCMD_ACTIVE),
-					      HOST_COMPLETE_TIMEOUT);
+					      end - now);
+	if (rc < 0) {
+		now = jiffies;
+		if (time_before(now, end))
+			goto again;
+		rc = 0;
+	}
+
 	if (rc == 0) {
 		spin_lock_irqsave(&priv->lock, flags);
 		if (priv->status & STATUS_HCMD_ACTIVE) {
-- 
1.7.10



