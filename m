Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2AIPFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:05:40 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:59854 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2AIPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:05:39 -0500
From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: michael.hennerich@analog.com, grant.likely@secretlab.ca,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
Subject: [PATCH 1/2] input: adp5588-keys - get value from data out when dir out
Date: Mon,  9 Jan 2012 10:05:22 -0500
Message-Id: <1326121523-28634-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.7.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed here: http://ez.analog.com/message/35852,
the 5587 revC and 5588 revB spec sheets contain a mistake
in the GPIO_DAT_STATx register description.

According to R.Shnell at ADI, as well as my own
observations, it should read:
"GPIO data status (shows GPIO state when read for inputs)".

This commit changes the get value function accordingly.

A similar patch for gpio-adp5588 follows.

Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/input/keyboard/adp5588-keys.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 6412ced..b7a0f1a 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -78,6 +78,13 @@ static int adp5588_gpio_get_value(struct gpio_chip *chip, unsigned off)
 	unsigned int bank = ADP5588_BANK(kpad->gpiomap[off]);
 	unsigned int bit = ADP5588_BIT(kpad->gpiomap[off]);
 
+	mutex_lock(&kpad->gpio_lock);
+	if (kpad->dir[bank] & bit) {
+		int result = !!(kpad->dat_out[bank] & bit);
+		mutex_unlock(&kpad->gpio_lock);
+		return result;
+	}
+	mutex_unlock(&kpad->gpio_lock);
 	return !!(adp5588_read(kpad->client, GPIO_DAT_STAT1 + bank) & bit);
 }
 
-- 
1.7.8.2

