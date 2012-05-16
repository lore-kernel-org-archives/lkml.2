Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2EPMKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:10:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58327 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2EPMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:10:10 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: mjg@redhat.com, tianyu.lan@intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] usb: fix breakage on systems without ACPI
Date: Wed, 16 May 2012 14:11:15 +0200
Message-Id: <1337170275-23859-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da0af6e ("usb: Bind devices to ACPI devices when possible") really
tries to force-bind devices even when impossible, unlike what it says in
the subject.

CONFIG_ACPI is not an indication that ACPI tables are actually present, nor
is an indication that any USB relevant information is present in them. There
is no reason to fail the creation of a USB bus if it can't bind it to
ACPI device during initialization.

On systems with CONFIG_ACPI set but without ACPI tables it would cause a
boot panic.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/usb/core/usb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 7998a67..25d0c61 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1015,9 +1015,7 @@ static int __init usb_init(void)
 	if (retval)
 		goto out;
 
-	retval = usb_acpi_register();
-	if (retval)
-		goto acpi_register_failed;
+	usb_acpi_register();
 	retval = bus_register(&usb_bus_type);
 	if (retval)
 		goto bus_register_failed;
@@ -1053,7 +1051,6 @@ bus_notifier_failed:
 	bus_unregister(&usb_bus_type);
 bus_register_failed:
 	usb_acpi_unregister();
-acpi_register_failed:
 	usb_debugfs_cleanup();
 out:
 	return retval;
-- 
1.7.8.6

