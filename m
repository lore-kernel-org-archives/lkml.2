Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325Ab2DKXXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:23:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965309Ab2DKXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:28 -0400
Message-Id: <20120411231042.452525315@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>
Subject: [ 41/59] mmc: atmel-mci: correct data timeout computation
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit 66292ad92c6d3f2f1c137a1c826b331ca8595dfd upstream.

The HSMCI operates at a rate of up to Master Clock divided by two.
Moreover previous calculation can cause overflows and so wrong
timeouts.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -480,7 +480,14 @@ err:
 static inline unsigned int atmci_ns_to_clocks(struct atmel_mci *host,
 					unsigned int ns)
 {
-	return (ns * (host->bus_hz / 1000000) + 999) / 1000;
+	/*
+	 * It is easier here to use us instead of ns for the timeout,
+	 * it prevents from overflows during calculation.
+	 */
+	unsigned int us = DIV_ROUND_UP(ns, 1000);
+
+	/* Maximum clock frequency is host->bus_hz/2 */
+	return us * (DIV_ROUND_UP(host->bus_hz, 2000000));
 }
 
 static void atmci_set_timeout(struct atmel_mci *host,


