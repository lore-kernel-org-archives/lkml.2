Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab0JSHNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:13:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60785 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933578Ab0JSHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:13:44 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>
Subject: [PATCH RESEND] ACPI dock: move some functions to .init.text
Date: Tue, 19 Oct 2010 09:13:39 +0200
Message-Id: <1287472419-13187-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1277127073-10485-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1277127073-10485-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_dock and find_bay are only called by dock_init which lives in
.init.text dock_add is only called by find_dock and find_bay.  So all
three functions can be moved to .init.text, too.

This fixes:

        WARNING: vmlinux.o(.text+0x2134b7): Section mismatch in reference from the function dock_add() to the function .init.text:platform_device_register_resndata()
        The function dock_add() references
        the function __init platform_device_register_resndata().
        This is often because dock_add lacks a __init
        annotation or the annotation of platform_device_register_resndata is wrong.

for a build with unset CONFIG_MODULES.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

since the first submission of the patch back in June I reworded the
commit log to make it (hopefully) more understandable.  Since then
platform_device_register_data was marked __init_or_module, so the
problem is real now (and only occurs with CONFIG_MODULES=n).

Best regards
Uwe

 drivers/acpi/dock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 3fe29e9..2b16563 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -929,7 +929,7 @@ static struct attribute_group dock_attribute_group = {
  * allocated and initialize a new dock station device.  Find all devices
  * that are on the dock station, and register for dock event notifications.
  */
-static int dock_add(acpi_handle handle)
+static int __init dock_add(acpi_handle handle)
 {
 	int ret, id;
 	struct dock_station ds, *dock_station;
@@ -1023,7 +1023,7 @@ static int dock_remove(struct dock_station *ds)
  *
  * This is called by acpi_walk_namespace to look for dock stations.
  */
-static acpi_status
+static __init acpi_status
 find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	if (is_dock(handle))
@@ -1032,7 +1032,7 @@ find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-static acpi_status
+static __init acpi_status
 find_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	/* If bay is a dock, it's already handled */
-- 
1.7.2.3

