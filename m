Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1DKXyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:54:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab1DKXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:54:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=rvt30ARbFUhPuYZt8CJBTixhmQFGMDRLyY7sqIYVRjemxzzvk01SkAc2Q9kUvEP8E
	weTJrTqRiHNlKRvhuuaxw==
From: Nat Gurumoorthy <natg@google.com>
To: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Nat Gurumoorthy <natg@google.com>
Subject: [PATCH v4 2/2] Use "request_muxed_region" in it87 hwmon drivers
Date: Mon, 11 Apr 2011 16:53:22 -0700
Message-Id: <1302566002-23962-1-git-send-email-natg@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1302565858-23849-1-git-send-email-natg@google.com>
References: <1302565858-23849-1-git-send-email-natg@google.com>
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
index 316b648..1dc04d4 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -111,6 +111,9 @@ superio_select(int ldn)
 static inline void
 superio_enter(void)
 {
+	while (!request_muxed_region(REG, 2, DRVNAME))
+		continue;
+
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

