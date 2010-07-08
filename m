Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0GHFzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 01:55:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41733 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0GHFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 01:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Kxrz1MPy9vnoJwGGYuFD7ULwUx2L+x86gUeyTLSLdGZpG00UsS2nvj5Ka7Hk1yF9J1
         yK0nq/SCGhQ9ZEr95rGuAZ/agXR1hUx+/CRZU72yfgHjcPzQYPnbSkNJBSM2CvitV6d4
         l5FiCa33R/Mqk9VxA356UadxwPzlIO7fINV48=
Subject: [PATCH] asus-laptop: return proper error for store_ledd if
	write_acpi_int fail
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 13:55:35 +0800
Message-Id: <1278568535.7162.18.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, store_ledd() does not return error if write_acpi_int
fail.
This patch fixes it by return -ENODEV if write_acpi_int fail.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 93487eb..975751d 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -796,10 +796,11 @@ static ssize_t store_ledd(struct device *dev, struct device_attribute *attr,
 
 	rv = parse_arg(buf, count, &value);
 	if (rv > 0) {
-		if (write_acpi_int(asus->handle, METHOD_LEDD, value))
+		if (write_acpi_int(asus->handle, METHOD_LEDD, value)) {
 			pr_warning("LED display write failed\n");
-		else
-			asus->ledd_status = (u32) value;
+			return -ENODEV;
+		}
+		asus->ledd_status = (u32) value;
 	}
 	return rv;
 }
-- 
1.5.4.3



