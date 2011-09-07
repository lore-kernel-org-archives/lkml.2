Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1IGRn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:43:26 -0400
Received: from mail.visioncatalog.de ([217.6.246.34]:44801 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1IGRnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:43:24 -0400
X-Greylist: delayed 4999 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 13:43:24 EDT
From: Jan Weitzel <j.weitzel@phytec.de>
To: linux-kernel@vger.kernel.org
Cc: zbr@ioremap.net, Jan Weitzel <j.weitzel@phytec.de>
Subject: [RFC] w1: Disable irqs in critical section
Date: Wed, 7 Sep 2011 10:48:32 +0200
Message-Id: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
X-Mailer: git-send-email 1.7.0.4
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 8.5.2FP2|March 22, 2011) at
 07.09.2011 10:48:38,
	Serialize by Router on Idefix/Phytec(Release 8.5.2FP2|March 22, 2011) at
 07.09.2011 10:48:38,
	Serialize complete at 07.09.2011 10:48:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupting w1_delay in w1_read_bit results in missing the low level
on the w1 line and receiving "1" instead of "0".
Adding local_irq_save / local_irq_restore around the critical section

Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
---
 drivers/w1/w1_io.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 8e8b64c..a059eaa 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -158,13 +158,18 @@ EXPORT_SYMBOL_GPL(w1_write_8);
 static u8 w1_read_bit(struct w1_master *dev)
 {
 	int result;
+	unsigned long flags;
 
+	/* sample timing is critical here */
+	local_irq_save(flags);
 	dev->bus_master->write_bit(dev->bus_master->data, 0);
 	w1_delay(6);
 	dev->bus_master->write_bit(dev->bus_master->data, 1);
 	w1_delay(9);
 
 	result = dev->bus_master->read_bit(dev->bus_master->data);
+	local_irq_restore(flags);
+
 	w1_delay(55);
 
 	return result & 0x1;
-- 
1.7.0.4

