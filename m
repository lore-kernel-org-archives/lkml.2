Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0GGAVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:21:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49881 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab0GGAVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YdH4sSx/GsFE2qRuFi9JXS/eXqj2uy+LuShtXpY+Jmw8kSQclzeXbkpzdl4uTknbZw
         mBQUdCxK53V7b3yJ2nS4xWGLWhHxuMOBjpmBbhHXDLaDFwQHdpzWA7Uy2a400WQynVd8
         reRilrnve6mA5EiMsu9OfbhXCUvJhNb+3AeF0=
Subject: [PATCH v2] panasonic-laptop: fix acpi_pcc_write_sset return value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Harald Welte <laforge@gnumonks.org>, Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Wed, 07 Jul 2010 08:21:48 +0800
Message-Id: <1278462108.12801.23.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, acpi_pcc_write_sset return 1
if write is successful, 0 if write is failed.
But all the callers consider acpi_pcc_write_sset return 0
if write is successful and return negtive if write is failed.

This patch changes the implementation of acpi_pcc_write_sset to
return 0 if write is successful, -EIO if write is failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/panasonic-laptop.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 2fb9a32..ec01c3d 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -248,7 +248,7 @@ static int acpi_pcc_write_sset(struct pcc_acpi *pcc, int func, int val)
 	status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SSET,
 				      &params, NULL);
 
-	return status == AE_OK;
+	return (status == AE_OK) ? 0 : -EIO;
 }
 
 static inline int acpi_pcc_get_sqty(struct acpi_device *device)
@@ -586,7 +586,6 @@ static int acpi_pcc_init_input(struct pcc_acpi *pcc)
 static int acpi_pcc_hotkey_resume(struct acpi_device *device)
 {
 	struct pcc_acpi *pcc = acpi_driver_data(device);
-	acpi_status status = AE_OK;
 
 	if (device == NULL || pcc == NULL)
 		return -EINVAL;
@@ -594,9 +593,7 @@ static int acpi_pcc_hotkey_resume(struct acpi_device *device)
 	ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Sticky mode restore: %d\n",
 			  pcc->sticky_mode));
 
-	status = acpi_pcc_write_sset(pcc, SINF_STICKY_KEY, pcc->sticky_mode);
-
-	return status == AE_OK ? 0 : -EINVAL;
+	return acpi_pcc_write_sset(pcc, SINF_STICKY_KEY, pcc->sticky_mode);
 }
 
 static int acpi_pcc_hotkey_add(struct acpi_device *device)
-- 
1.5.4.3



