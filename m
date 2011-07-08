Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1GHFFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1GHFFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001700.927287231@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Petri Gynther <pgynther@google.com>, Jean Delvare <khali@linux-fr.org>
Subject: [084/107] i2c/pca954x: Initialize the mux to disconnected state
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Petri Gynther <pgynther@google.com>

commit cd823db8b1161ef0d756514d280715a576d65cc3 upstream.

pca954x power-on default is channel 0 connected. If multiple pca954x
muxes are connected to the same physical I2C bus, the parent bus will
see channel 0 devices behind both muxes by default. This is bad.

Scenario:
            -- pca954x @ 0x70 -- ch 0 (I2C-bus-101) -- EEPROM @ 0x50
            |
I2C-bus-1 ---
            |
            -- pca954x @ 0x71 -- ch 0 (I2C-bus-111) -- EEPROM @ 0x50

1. Load I2C bus driver: creates I2C-bus-1
2. Load pca954x driver: creates virtual I2C-bus-101 and I2C-bus-111
3. Load eeprom driver
4. Try to read EEPROM @ 0x50 on I2C-bus-101. The transaction will also bleed
   onto I2C-bus-111 because pca954x @ 0x71 channel 0 is connected by default.

Fix: Initialize pca954x to disconnected state in pca954x_probe()

Signed-off-by: Petri Gynther <pgynther@google.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/muxes/pca954x.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/i2c/muxes/pca954x.c
+++ b/drivers/i2c/muxes/pca954x.c
@@ -201,10 +201,11 @@ static int pca954x_probe(struct i2c_clie
 
 	i2c_set_clientdata(client, data);
 
-	/* Read the mux register at addr to verify
-	 * that the mux is in fact present.
+	/* Write the mux register at addr to verify
+	 * that the mux is in fact present. This also
+	 * initializes the mux to disconnected state.
 	 */
-	if (i2c_smbus_read_byte(client) < 0) {
+	if (i2c_smbus_write_byte(client, 0) < 0) {
 		dev_warn(&client->dev, "probe failed\n");
 		goto exit_free;
 	}


