Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab0JVTBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:01:32 -0400
Received: from kroah.org ([198.145.64.141]:34463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533Ab0JVS5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:35 2010
Message-Id: <20101022185235.759841730@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [094/103] PM / ACPI: Blacklist systems known to require acpi_sleep=nonvs
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 539986482b0db07b7164ab086d167ab99b4d3061 upstream.

Commit 2a6b69765ad794389f2fc3e14a0afa1a995221c2 (ACPI: Store NVS
state even when entering suspend to RAM) changed the ACPI suspend
to RAM code so that the NVS memory area is always unconditionally
saved during suspend and restored during resume, since some systems
evidently need that for the suspend-resume to work on them.  However,
it turned out that this change broke suspend-resume on a few systems,
so commit 72ad5d77fb981963edae15eee8196c80238f5ed0 (ACPI / Sleep:
Allow the NVS saving to be skipped during suspend to RAM) introduced
the acpi_sleep=nonvs command line switch to allow their users to
work around this issue.  To keep track of the systems that require
this workaround and to make the life of their users slightly easier
blacklist them in acpisleep_dmi_table[].

https://bugzilla.kernel.org/show_bug.cgi?id=16396

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -362,6 +362,12 @@ static int __init init_old_suspend_order
 	return 0;
 }
 
+static int __init init_nvs_nosave(const struct dmi_system_id *d)
+{
+	acpi_nvs_nosave();
+	return 0;
+}
+
 static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	{
 	.callback = init_old_suspend_ordering,
@@ -396,6 +402,22 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
 		},
 	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-SR11M",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-SR11M"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
+	.ident = "Everex StepNote Series",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Everex Systems, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Everex StepNote Series"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */


