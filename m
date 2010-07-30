Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0G3SGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:06:12 -0400
Received: from kroah.org ([198.145.64.141]:59262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828Ab0G3R5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:51 2010
Message-Id: <20100730175151.309401628@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [192/205] ACPI / ACPICA: Fix sysfs GPE interface
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 9d3c752de65dbfa6e522f1d666deb0ac152ef367 upstream.

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
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/system.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -389,10 +389,12 @@ static ssize_t counter_set(struct kobjec
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
 			result = acpi_clear_gpe(handle, index, ACPI_NOT_ISR);


