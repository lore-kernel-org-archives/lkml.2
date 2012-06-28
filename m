Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2F1U6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 16:58:55 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:48204 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1U6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 16:58:53 -0400
X-SMTPAUTH-GN: [zoltan.kelemen@privat.utfors.se]
X-SENDER-IP: [78.82.105.213]
X-LISTENER: [smtp.glocalnet.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAH7E7E9OUmnV/2dsb2JhbAANOLpiATwMChgDAgECAUwMAQUCAQHBN44ZgygDjkeZTw
X-IronPort-AV: E=Sophos;i="4.77,494,1336341600"; 
   d="scan'208";a="144716603"
Message-ID: <4FECC58D.2030904@digisec.se>
Date: Thu, 28 Jun 2012 22:58:53 +0200
From: Zoltan Kelemen <zoltan@digisec.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: willy@meta-x.org, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging:panel: Fix cursor positioning escapes
Content-Type: multipart/mixed;
 boundary="------------000308020001040604000904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000308020001040604000904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------000308020001040604000904
Content-Type: text/plain;
 name="panel-patch3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="panel-patch3"

Patch for fixing bug in cursor position escape handling. The bug was introduced
when simple_strtoul was converted to kstrtoul without taking into account that
the end pointer is used to continue the parsing. Reverted the code back to
simple_strtoul.

This patch depends on patch 2 and should therefore be applied after it.

Signed-off-by: Zoltan Kelemen <zoltan@digisec.se>
----
diff -ru linux-next/drivers/staging/panel/panel.c panel-patch3/drivers/staging/panel/panel.c
--- linux-next/drivers/staging/panel/panel.c	2012-06-28 13:10:37.274466384 +0200
+++ panel-patch3/drivers/staging/panel/panel.c	2012-06-28 13:42:22.514445057 +0200
@@ -1228,14 +1228,16 @@
 			break;
 
 		while (*esc) {
+			char *endp;
+
 			if (*esc == 'x') {
 				esc++;
-				if (kstrtoul(esc, 10, &lcd_addr_x) < 0)
-					break;
+				lcd_addr_x = simple_strtoul(esc, &endp, 10);
+				esc = endp;
 			} else if (*esc == 'y') {
 				esc++;
-				if (kstrtoul(esc, 10, &lcd_addr_y) < 0)
-					break;
+				lcd_addr_y = simple_strtoul(esc, &endp, 10);
+				esc = endp;
 			} else
 				break;
 		}

--------------000308020001040604000904--
