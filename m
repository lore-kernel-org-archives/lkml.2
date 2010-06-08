Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0FHJA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:00:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab0FHJAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:00:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 5/5] ACPI / ACPICA: Fix sysfs GPE interface
Date: Tue, 8 Jun 2010 10:50:53 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
References: <201006080024.46142.rjw@sisk.pl> <201006081046.48488.rjw@sisk.pl>
In-Reply-To: <201006081046.48488.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081050.53599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The sysfs interface allowing user space to disable/enable GPEs
doesn't work correctly, because a GPE disabled this way will be
re-enabled shortly by acpi_ev_asynch_enable_gpe() if it was
previosuly enabled by acpi_enable_gpe() (in which case the
corresponding bit in its enable register's enable_for_run mask is
set).

To address this issue make the sysfs GPE interface use
acpi_enable_gpe() and acpi_disable_gpe() instead of acpi_set_gpe()
so that GPE reference counters are modified by it along with the
values of GPE enable registers.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/system.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/system.c
===================================================================
--- linux-2.6.orig/drivers/acpi/system.c
+++ linux-2.6/drivers/acpi/system.c
@@ -388,10 +388,12 @@ static ssize_t counter_set(struct kobjec
 	if (index < num_gpes) {
 		if (!strcmp(buf, "disable\n") &&
 				(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_set_gpe(handle, index, ACPI_GPE_DISABLE);
+			result = acpi_disable_gpe(handle, index,
+						ACPI_GPE_TYPE_RUNTIME);
 		else if (!strcmp(buf, "enable\n") &&
 				!(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_set_gpe(handle, index, ACPI_GPE_ENABLE);
+			result = acpi_enable_gpe(handle, index,
+						ACPI_GPE_TYPE_RUNTIME);
 		else if (!strcmp(buf, "clear\n") &&
 				(status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_gpe(handle, index);

