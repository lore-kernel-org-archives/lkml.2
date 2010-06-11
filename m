Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab0FKWHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:07:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760620Ab0FKWHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:07:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH][Regression fix]  ACPI / ACPICA: Do not attempt to disable GPE when installing handler
Date: Sat, 12 Jun 2010 00:05:19 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-rjw+; KDE/4.4.3; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>, len.brown@intel.com,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006120005.19807.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 0f849d2cc6863c7874889ea60a871fb71399dd3f (ACPICA: Minimize
the differences between linux GPE code and ACPICA code base)
introduced a change attempting to disable a GPE before installing
a handler for it in acpi_install_gpe_handler() which was incorrect.
First, the GPE disabled by it is never enabled again (except during
resume) which leads to battery insert/remove events not being
reported on the Maxim Levitsky's machine.  Second, the disabled
GPE is still reported as enabled by the sysfs interface that only
checks its enable register's enable_for_run mask.

Revert this change for now, because it causes more damage to happen
than the bug it was supposed to fix.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
Hi Len,

This will conflict with
http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=a771b5f7b5b132fc3e653645405e20abb4da6e8c
but the conflict is easy to resolve.

Please apply.

Rafael
---
 drivers/acpi/acpica/evxface.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxface.c
+++ linux-2.6/drivers/acpi/acpica/evxface.c
@@ -719,13 +720,6 @@ acpi_install_gpe_handler(acpi_handle gpe
 	handler->context = context;
 	handler->method_node = gpe_event_info->dispatch.method_node;
 
-	/* Disable the GPE before installing the handler */
-
-	status = acpi_ev_disable_gpe(gpe_event_info);
-	if (ACPI_FAILURE (status)) {
-		goto unlock_and_exit;
-	}
-
 	/* Install the handler */
 
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
