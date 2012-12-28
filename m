Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2L1T5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:57:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54936 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754330Ab2L1TRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:03 -0500
Message-Id: <20121228190402.925061372@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 172/173] staging: vt6656: 64bit fixes: vCommandTimerWait change calculation
 of timer.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 70e227790d4ee4590023d8041a3485f8053593fc upstream.

The timer appears to run too fast/race on 64 bit systems.

Using msecs_to_jiffies seems to cause a deadlock on 64 bit.

A calculation of (MSecond * HZ) / 1000 appears to run satisfactory.

Change BSSIDInfoCount to u32.

After this patch the driver can be successfully connect on little endian 64/32 bit systems.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/wcmd.c |   20 +++++++++++---------
 drivers/staging/vt6656/wpa2.h |    4 ++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 586fbe1..b854d7e 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -316,17 +316,19 @@ s_MgrMakeProbeRequest(
     return pTxPacket;
 }
 
-void vCommandTimerWait(void *hDeviceContext, unsigned int MSecond)
+void vCommandTimerWait(void *hDeviceContext, unsigned long MSecond)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
 
-    init_timer(&pDevice->sTimerCommand);
-    pDevice->sTimerCommand.data = (unsigned long)pDevice;
-    pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-    // RUN_AT :1 msec ~= (HZ/1024)
-    pDevice->sTimerCommand.expires = (unsigned int)RUN_AT((MSecond * HZ) >> 10);
-    add_timer(&pDevice->sTimerCommand);
-    return;
+	init_timer(&pDevice->sTimerCommand);
+
+	pDevice->sTimerCommand.data = (unsigned long)pDevice;
+	pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
+	pDevice->sTimerCommand.expires = RUN_AT((MSecond * HZ) / 1000);
+
+	add_timer(&pDevice->sTimerCommand);
+
+	return;
 }
 
 void vRunCommand(void *hDeviceContext)
diff --git a/drivers/staging/vt6656/wpa2.h b/drivers/staging/vt6656/wpa2.h
index 46c2959..c359252 100644
--- a/drivers/staging/vt6656/wpa2.h
+++ b/drivers/staging/vt6656/wpa2.h
@@ -45,8 +45,8 @@ typedef struct tagsPMKIDInfo {
 } PMKIDInfo, *PPMKIDInfo;
 
 typedef struct tagSPMKIDCache {
-    unsigned long       BSSIDInfoCount;
-    PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
+	u32 BSSIDInfoCount;
+	PMKIDInfo BSSIDInfo[MAX_PMKID_CACHE];
 } SPMKIDCache, *PSPMKIDCache;
 
 


