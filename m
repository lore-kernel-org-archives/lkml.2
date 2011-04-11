Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1DKWIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:08:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21807 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1DKWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:08:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=DId9+k/kXiMxW5SWYOp/tr+RkgoJVuiJnmLn+23Qs7VjmbH3/JlD99f1Af57iI303
	KQ1lnmUlyOmQqlzV+/XLg==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v3 2/2] Use "request_muxed_region" in it87 hwmon drivers
Date: Mon, 11 Apr 2011 15:07:31 -0700
Message-Id: <1302559651-18990-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <[PATCH v3 0/2] Make all it87 drivers SMP safe>
References: <[PATCH v3 0/2] Make all it87 drivers SMP safe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02 - Chages to hwmon it87 driver to use "request_muxed_region"
Serialize access to the hardware by using "request_muxed_region" macro defined
by Alan Cox. Call to this macro will hold off the requestor if the resource is
currently busy.

Signed-off-by: Nat Gurumoorthy <natg@google.com>
---

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 316b648..37c8acd 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -111,6 +111,9 @@ superio_select(int ldn)
 static inline void
 superio_enter(void)
 {
+	while (!request_muxed_region(REG, 2, DRVNAME)) {
+		continue;
+	}
 	outb(0x87, REG);
 	outb(0x01, REG);
 	outb(0x55, REG);
@@ -122,6 +125,7 @@ superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
+	release_region(REG, 2);
 }
 
 /* Logical device 4 registers */
-- 
1.7.3.1

