Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2EGL1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:27:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab2EGL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:27:02 -0400
Message-ID: <4FA7B184.7080806@ammonit.com>
Date: Mon, 07 May 2012 13:27:00 +0200
From: =?ISO-8859-15?Q?Steffen_K=FChn?= <sk@ammonit.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110307 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: nicolas.ferre@atmel.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] solve deadlock problem in atmel-mci (kernel 3.2)
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2012 11:27:00.0633 (UTC) FILETIME=[51DB3090:01CD2C44]
X-Provags-ID: V02:K0:z4c8F81hXhizFBCXlkwkh78FFZve+XyLbDdO3/Le5vu
 sCSgAYUQzsXBWdTRDZao+Ui754IqXeXz70t3k9c3zA050YBLaX
 ZwNJgzpwFWr/d1D3xPJTxxPaIpinztTx/C92y6Cq12kTug3szY
 EwfgjE6zMHB4TCvRPaF8IG2ml0Cy0+gp+JaU1ZeFOU7HI+Aw8b
 zf9L/gmxYc8frkY8lo0GXKpvZQpmMFMscYJx2iFLjaogleRC8O
 MkNK4qHiTWWaBtHIyHnanNEwQQAFK4120+KU1/BozMIsByZYZI
 sF0jOx16dUhOGN4M9iQmowt+amSvcFChZVK85+dgzhxl+RfXjP
 +TpA3bTDB252A85un9Es=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Nicolas,

the appended patch solves a deadlock problem which appears when a SD
card is removing and a process is reading from the card at the same
time. The problem occurs not always but only when there are
error-messages like 'end_request: I/O error, dev mmcblk0, sector XXX'
(probably a timing thing).

When the error occurs, the autodetection for SD card insertion does not
work anymore and unloading of the driver with 'rmmod' is no longer possible.

The patch seems to work very well with our hardware. But I have to say,
that I have not understand the mechanisms in the driver entirely. Please
check, if the patch make sense.

Best regards,
Steffen



diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 94c377d..407648f 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1480,8 +1480,10 @@ static void atmci_tasklet_func(unsigned long priv)
 			}

 			if (!atmci_test_and_clear_pending(host,
-						EVENT_XFER_COMPLETE))
+						EVENT_XFER_COMPLETE)) {
+				host->stop_transfer(host);
 				break;
+			}

 			atmci_set_completed(host, EVENT_XFER_COMPLETE);
 			prev_state = state = STATE_DATA_BUSY;
