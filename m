Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2ICKP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 06:15:28 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36239 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2ICKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 06:15:27 -0400
MIME-Version: 1.0
Date: Mon, 3 Sep 2012 18:15:26 +0800
Message-ID: <CAPgLHd-WNdXdTAGYOJQ5_2Xp0Wyj2dyrxnp0qc_6n+StiDHJMQ@mail.gmail.com>
Subject: [PATCH] staging: csr: fix possible memory leak in do_patch_convert_download()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

pfw has been allocated in function xbv_to_patch() and should be
freed before leaving from the error handling cases.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/csr/csr_wifi_hip_download.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/csr/csr_wifi_hip_download.c b/drivers/staging/csr/csr_wifi_hip_download.c
index 8e4a460..6db672c 100644
--- a/drivers/staging/csr/csr_wifi_hip_download.c
+++ b/drivers/staging/csr/csr_wifi_hip_download.c
@@ -250,6 +250,7 @@ static CsrResult do_patch_convert_download(card_t *card, void *dlpriv, xbv1_t *p
         if (r != CSR_RESULT_SUCCESS)
         {
             unifi_error(card->ospriv, "Failed to find BOOT_LOADER_CONTROL\n");
+            kfree(pfw);
             return CSR_RESULT_FAILURE;
         }
 
@@ -265,6 +266,7 @@ static CsrResult do_patch_convert_download(card_t *card, void *dlpriv, xbv1_t *p
         desc = unifi_fw_open_buffer(card->ospriv, pfw, psize);
         if (!desc)
         {
+            kfree(pfw);
             return CSR_WIFI_HIP_RESULT_NO_MEMORY;
         }
 


