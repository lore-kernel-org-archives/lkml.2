Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2EDVGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:06:31 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab2EDUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:28 -0400
Message-Id: <20120504204230.094388730@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 67/75] ipw2200: Fix race condition in the command completion acknowledge
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ipw2x00/ipw2200.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2191,6 +2191,7 @@ static int __ipw_send_cmd(struct ipw_pri
 {
 	int rc = 0;
 	unsigned long flags;
+	unsigned long now, end;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->status & STATUS_HCMD_ACTIVE) {
@@ -2232,10 +2233,20 @@ static int __ipw_send_cmd(struct ipw_pri
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


