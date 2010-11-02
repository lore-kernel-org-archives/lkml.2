Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0KBMmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:42:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57398 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0KBMmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pGXLYj0AKizZjuSijcbADzHfWpKVRQfSsKSaYMYIaJKs9wjCAjZsnf+HA9ZBq27yjw
         UFd8YphdGy3h8XHw9HJ9UCjl8IC7VviywFYVhzfYhFxv2ban54yrboSPObazfoOXdE3F
         kQXk/14Ab+j+s2ob4zjeIR9ODOucMVKsC3lOw=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/3] staging: ft1000: Pseudo header handlig improved.
Date: Tue,  2 Nov 2010 13:44:10 +0100
Message-Id: <1288701850-29123-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288701850-29123-1-git-send-email-marek.belisko@gmail.com>
References: <1288701850-29123-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling for pseudo header was done by directly copying
data to tx buffer. This hide a functionality and make
code unreadable.

Use approach where fill pseudo_hdr structure first with data and then copy
to beginning of buffer.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   35 ++++++++++++-------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 5a9edfb..90394e1 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1017,10 +1017,9 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
 
 
-    int i, count, ret;
-    USHORT *pTemp;
-    USHORT checksum;
+	int count, ret;
     u8 *t;
+	struct pseudo_hdr hdr;
 
     if (!pInfo->CardReady)
     {
@@ -1044,21 +1043,21 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     if ( count % 4)
         count = count + (4- (count %4) );
 
-    pTemp = (PUSHORT)&(pFt1000Dev->tx_buf[0]);
-    *pTemp ++ = ntohs(count);
-    *pTemp ++ = 0x1020;
-    *pTemp ++ = 0x2010;
-    *pTemp ++ = 0x9100;
-    *pTemp ++ = 0;
-    *pTemp ++ = 0;
-    *pTemp ++ = 0;
-    pTemp = (PUSHORT)&(pFt1000Dev->tx_buf[0]);
-    checksum = *pTemp ++;
-    for (i=1; i<7; i++)
-    {
-        checksum ^= *pTemp ++;
-    }
-    *pTemp++ = checksum;
+	memset(&hdr, 0, sizeof(struct pseudo_hdr));
+
+	hdr.length = ntohs(count);
+	hdr.source = 0x10;
+	hdr.destination = 0x20;
+	hdr.portdest = 0x20;
+	hdr.portsrc = 0x10;
+	hdr.sh_str_id = 0x91;
+	hdr.control = 0x00;
+
+	hdr.checksum = hdr.length ^ hdr.source ^ hdr.destination ^
+			hdr.portdest ^ hdr.portsrc ^ hdr.sh_str_id ^
+			hdr.control;
+
+	memcpy(&pFt1000Dev->tx_buf[0], &hdr, sizeof(hdr));
 	memcpy(&(pFt1000Dev->tx_buf[sizeof(struct pseudo_hdr)]), packet, len);
 
     netif_stop_queue(netdev);
-- 
1.7.1

