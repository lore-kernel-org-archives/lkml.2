Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0DVQzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:55:20 -0400
Received: from compulab.co.il ([67.18.134.219]:54255 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab0DVQzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:55:18 -0400
Message-ID: <4BD07F3C.8080404@compulab.co.il>
Date: Thu, 22 Apr 2010 19:54:20 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Wim Van Sebroeck <wim@iguana.be>, Andrey Panin <pazke@centrinvest.ru>
Subject: "scheduling while atomic" bug in SBC-FITPC2 watchdog
References: <4A6492EB.1080709@compulab.co.il> <4AF2B7D8.1010903@compulab.co.il> <4B58603F.5030407@compulab.co.il> <4BD07E3B.3030504@compulab.co.il>
In-Reply-To: <4BD07E3B.3030504@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbc_fitpc2_wdt: fixed "scheduling while atomic" bug.

speenlock need to be replaced by mutex because of sleep functions
inside wdt_send_data.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/watchdog/sbc_fitpc2_wdt.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 226f0f2..23da5cb 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -30,7 +30,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int margin = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
-static DEFINE_SPINLOCK(wdt_lock);
+static DEFINE_MUTEX(wdt_lock);

 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -53,18 +53,18 @@ static void wdt_send_data(unsigned char command, unsigned char data)

 static void wdt_enable(void)
 {
-	spin_lock(&wdt_lock);
+	mutex_lock(&wdt_lock);
 	wdt_send_data(IFACE_ON_COMMAND, 1);
 	wdt_send_data(REBOOT_COMMAND, margin);
-	spin_unlock(&wdt_lock);
+	mutex_unlock(&wdt_lock);
 }

 static void wdt_disable(void)
 {
-	spin_lock(&wdt_lock);
+	mutex_lock(&wdt_lock);
 	wdt_send_data(IFACE_ON_COMMAND, 0);
 	wdt_send_data(REBOOT_COMMAND, 0);
-	spin_unlock(&wdt_lock);
+	mutex_unlock(&wdt_lock);
 }

 static int fitpc2_wdt_open(struct inode *inode, struct file *file)
