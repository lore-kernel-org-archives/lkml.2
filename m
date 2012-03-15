Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031523Ab2COWxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:53:43 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:44152 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031141Ab2COWxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:53:41 -0400
Message-ID: <4F6272F3.7030909@hrz.tu-chemnitz.de>
Date: Thu, 15 Mar 2012 23:53:39 +0100
From: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org
Subject: [PATCH 2/2] w1: Disable irqs during 1-wire bus operations, extend
 1-wire reset pulse
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Scan-AV: mailbox.hrz.tu-chemnitz.de;2012-03-15 23:53:40;df830ebbd724b6a76a2bd811e0047e93
X-Scan-SA: cora.hrz.tu-chemnitz.de;2012-03-15 23:53:40;c7debafe478fbce12e246f034b8bdb9e
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -0.0 T_RP_MATCHES_RCVD Envelope sender domain matches handover relay
 *      domain
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch offers the possibility to disables irqs during w1_write_bit() 
and w1_reset_bus() operations as timing requirements are very strict for 
the 1-wire bus protocol. Per default interrupts are enabled but can be 
disabled via the module parameter "w1_disable_irqs".

Extend 1-wire reset pulse length from 480us to 500us as 480us is the 
minimum requirement for the 1-wire reset/presence pulse.

It applies to the current linux kernel git tree.

Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>
---
  drivers/w1/w1_io.c |   22 ++++++++++++++++++----
  1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 3135b2c..e10acc2 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -31,6 +31,9 @@
  static int w1_delay_parm = 1;
  module_param_named(delay_coef, w1_delay_parm, int, 0);

+static int w1_disable_irqs = 0;
+module_param_named(disable_irqs, w1_disable_irqs, int, 0);
+
  static u8 w1_crc8_table[] = {
  	0, 94, 188, 226, 97, 63, 221, 131, 194, 156, 126, 32, 163, 253, 31, 65,
  	157, 195, 33, 127, 252, 162, 64, 30, 95, 1, 227, 189, 62, 96, 130, 220,
@@ -79,6 +82,10 @@ static u8 w1_touch_bit(struct w1_master *dev, int bit)
   */
  static void w1_write_bit(struct w1_master *dev, int bit)
  {
+	unsigned long flags = 0;
+
+	if(w1_disable_irqs) local_irq_save(flags);
+
  	if (bit) {
  		dev->bus_master->write_bit(dev->bus_master->data, 0);
  		w1_delay(6);
@@ -90,6 +97,8 @@ static void w1_write_bit(struct w1_master *dev, int bit)
  		dev->bus_master->write_bit(dev->bus_master->data, 1);
  		w1_delay(10);
  	}
+
+	if(w1_disable_irqs) local_irq_restore(flags);
  }

  /**
@@ -158,7 +167,7 @@ EXPORT_SYMBOL_GPL(w1_write_8);
  static u8 w1_read_bit(struct w1_master *dev)
  {
  	int result;
-	unsigned long flags;
+	unsigned long flags = 0;

  	/* sample timing is critical here */
  	local_irq_save(flags);
@@ -318,6 +327,9 @@ EXPORT_SYMBOL_GPL(w1_read_block);
  int w1_reset_bus(struct w1_master *dev)
  {
  	int result;
+	unsigned long flags = 0;
+
+	if(w1_disable_irqs) local_irq_save(flags);

  	if (dev->bus_master->reset_bus)
  		result = dev->bus_master->reset_bus(dev->bus_master->data) & 0x1;
@@ -330,19 +342,21 @@ int w1_reset_bus(struct w1_master *dev)
  		 * cpu for such a short amount of time AND get it back in
  		 * the maximum amount of time.
  		 */
-		w1_delay(480);
+		w1_delay(500);
  		dev->bus_master->write_bit(dev->bus_master->data, 1);
  		w1_delay(70);

  		result = dev->bus_master->read_bit(dev->bus_master->data) & 0x1;
-		/* minmum 70 (above) + 410 = 480 us
+		/* minmum 70 (above) + 430 = 500 us
  		 * There aren't any timing requirements between a reset and
  		 * the following transactions.  Sleeping is safe here.
  		 */
-		/* w1_delay(410); min required time */
+		/* w1_delay(430); min required time */
  		msleep(1);
  	}

+	if(w1_disable_irqs) local_irq_restore(flags);
+
  	return result;
  }
  EXPORT_SYMBOL_GPL(w1_reset_bus);
-- 
1.7.4.1
