Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab2DSVIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:08:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46047 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab2DSVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:08:32 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 17:08:29 EDT
Message-Id: <20120419210308.904256990@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:04:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Danny Kukawka <danny.kukawka@bisect.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 68/75] spi-topcliff-pch: fix -Wuninitialized warning
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit de3bd7e6de25141c466773c2e0fa319b2fa93655 upstream.

Fix for:
drivers/spi/spi-topcliff-pch.c: In function ‘pch_spi_handler_sub’:
drivers/spi/spi-topcliff-pch.c:325:17: warning: ‘bpw_len’ may be
  used uninitialized in this function [-Wuninitialized]
drivers/spi/spi-topcliff-pch.c:325:42: warning: ‘rx_index’ may be
  used uninitialized in this function [-Wuninitialized]
drivers/spi/spi-topcliff-pch.c:325:42: warning: ‘tx_index’ may be
  used uninitialized in this function [-Wuninitialized]

Move usage of tx_index, rx_index and bpw_len into the same
block as where they are set to prevent uninitialized usage.

v2: instead of init variables with 0 move the whole block

[This patch title "warnings" makes you think "This patch is not
for bug fix".  However, this patch surely patch for bug fix.]

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-topcliff-pch.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -318,22 +318,23 @@ static void pch_spi_handler_sub(struct p
 		data->tx_index = tx_index;
 		data->rx_index = rx_index;
 
-	}
-
-	/* if transfer complete interrupt */
-	if (reg_spsr_val & SPSR_FI_BIT) {
-		if ((tx_index == bpw_len) && (rx_index == tx_index)) {
-			/* disable interrupts */
-			pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
+		/* if transfer complete interrupt */
+		if (reg_spsr_val & SPSR_FI_BIT) {
+			if ((tx_index == bpw_len) && (rx_index == tx_index)) {
+				/* disable interrupts */
+				pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
+						   PCH_ALL);
 
-			/* transfer is completed;
-			   inform pch_spi_process_messages */
-			data->transfer_complete = true;
-			data->transfer_active = false;
-			wake_up(&data->wait);
-		} else {
-			dev_err(&data->master->dev,
-				"%s : Transfer is not completed", __func__);
+				/* transfer is completed;
+				   inform pch_spi_process_messages */
+				data->transfer_complete = true;
+				data->transfer_active = false;
+				wake_up(&data->wait);
+			} else {
+				dev_err(&data->master->dev,
+					"%s : Transfer is not completed",
+					__func__);
+			}
 		}
 	}
 }


