Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0GFGwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:52:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40382 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0GFGwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AVMIjP2K6Hnis3Lyyg2nJc1NzTujJ40Mxo0oU/1CCHuC1I7MNoHRt3jRxf7X2mlhPX
         FYiHagHBFJKrHUGzxq+ACVI/Jy7TD9c+DXtxX9S/knooZ32WlMAEm+3v6drFDsVv0iJD
         sVpVh3pWw700R04iyqONvLSIb1aMcXNBJwtLM=
Subject: [PATCH] panasonic-laptop: fix acpi_pcc_write_sset return value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Harald Welte <laforge@gnumonks.org>, Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Tue, 06 Jul 2010 14:46:58 +0800
Message-Id: <1278398818.12801.20.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, acpi_pcc_write_sset return 1
if write is successful, 0 if write is failed.
But all the callers consider acpi_pcc_write_sset return 0
if write is successful and return negative if write is failed.

This patch changes the implementation of acpi_pcc_write_sset to
return 0 if write is successful, -1 if write is failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/panasonic-laptop.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 2fb9a32..d36cbf8 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -248,7 +248,7 @@ static int acpi_pcc_write_sset(struct pcc_acpi *pcc, int func, int val)
 	status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SSET,
 				      &params, NULL);
 
-	return status == AE_OK;
+	return (status == AE_OK) ? 0 : -1;
 }
 
 static inline int acpi_pcc_get_sqty(struct acpi_device *device)
@@ -586,7 +586,7 @@ static int acpi_pcc_init_input(struct pcc_acpi *pcc)
 static int acpi_pcc_hotkey_resume(struct acpi_device *device)
 {
 	struct pcc_acpi *pcc = acpi_driver_data(device);
-	acpi_status status = AE_OK;
+	int ret;
 
 	if (device == NULL || pcc == NULL)
 		return -EINVAL;
@@ -594,9 +594,9 @@ static int acpi_pcc_hotkey_resume(struct acpi_device *device)
 	ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Sticky mode restore: %d\n",
 			  pcc->sticky_mode));
 
-	status = acpi_pcc_write_sset(pcc, SINF_STICKY_KEY, pcc->sticky_mode);
+	ret = acpi_pcc_write_sset(pcc, SINF_STICKY_KEY, pcc->sticky_mode);
 
-	return status == AE_OK ? 0 : -EINVAL;
+	return (ret < 0) ? -EINVAL : 0;
 }
 
 static int acpi_pcc_hotkey_add(struct acpi_device *device)
-- 
1.5.4.3



