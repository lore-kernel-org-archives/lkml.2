Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0LHBSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:18:52 -0500
Received: from kroah.org ([198.145.64.141]:33639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0LHBDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:14 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:43 2010
Message-Id: <20101208005743.365079840@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dennis Jansen <dennis.jansen@web.de>, Alex Chiang <achiang@hp.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [219/289] ACPI: install ACPI table handler before any dynamic tables being loaded
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit b1d248d96c71665c79befb81207f38f894c7c082 upstream.

ACPI table sysfs I/F is broken by commit

78f1699659963fff97975df44db6d5dbe7218e55
Author: Alex Chiang <achiang@hp.com>
Date:   Sun Dec 20 12:19:09 2009 -0700
    ACPI: processor: call _PDC early

because dynamic SSDT tables may be loaded in _PDC,
before installing the ACPI table handler.
As a result, the sysfs I/F of these dynamic tables are
located at  /sys/firmware/acpi/tables instead of
/sys/firmware/acpi/tables/dynamic, which is not true.

Invoke acpi_sysfs_init() before acpi_early_processor_set_pdc(),
so that the table handler is installed before any dynamic tables loaded.

https://bugzilla.kernel.org/show_bug.cgi?id=21142

CC: Dennis Jansen <dennis.jansen@web.de>
CC: Alex Chiang <achiang@hp.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -935,6 +935,12 @@ static int __init acpi_bus_init(void)
 		goto error1;
 	}
 
+	/*
+	 * _PDC control method may load dynamic SSDT tables,
+	 * and we need to install the table handler before that.
+	 */
+	acpi_sysfs_init();
+
 	acpi_early_processor_set_pdc();
 
 	/*
@@ -1026,7 +1032,6 @@ static int __init acpi_init(void)
 	acpi_scan_init();
 	acpi_ec_init();
 	acpi_power_init();
-	acpi_sysfs_init();
 	acpi_debugfs_init();
 	acpi_sleep_proc_init();
 	acpi_wakeup_device_init();


