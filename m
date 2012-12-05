Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2LERjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:39:21 -0500
Received: from mail.tpi.com ([70.99.223.143]:4146 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab2LERjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:39:20 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 3.7-rc8] ACPICA: Fix ACPI mutex object allocation memory leak on error
Date: Wed,  5 Dec 2012 10:38:57 -0700
Message-Id: <1354729137-67135-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An unattached mutex object is not released
on error, thereby orphaning memory.

I stumbled on this when looking at the output of smatch:

drivers/acpi/acpica/dsmethod.c:225 acpi_ds_begin_method_execution() error: we previously assumed 'obj_desc->method.mutex' could be null (see line 209)

which led me to have a look at acpi_ds_create_method_mutex().

Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: linux-acpi@vger.kernel.org
Cc: stable@vger.kernel.org #2.6.29+
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This applied to the original version of dsmethod.c which was introduced
in 95b482a8d31116f3f5c2a5089569393234d06385 (2.6.29).

 drivers/acpi/acpica/dsmethod.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index aa9a5d4..fe89ea9 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -151,6 +151,7 @@ acpi_ds_create_method_mutex(union acpi_operand_object *method_desc)
 
 	status = acpi_os_create_mutex(&mutex_desc->mutex.os_mutex);
 	if (ACPI_FAILURE(status)) {
+		acpi_ut_delete_object_desc(mutex_desc);
 		return_ACPI_STATUS(status);
 	}
 
-- 
1.7.9.5

