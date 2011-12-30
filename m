Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1L3ThM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 14:37:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1L3ThK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 14:37:10 -0500
Date: Fri, 30 Dec 2011 14:37:05 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, jbarnes@virtuousgeek.org
Subject: Dell Studio 1536 needs pci=nocrs to boot.
Message-ID: <20111230193704.GA2874@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
	jbarnes@virtuousgeek.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines don't boot unless passed pci=nocrs.
(See https://bugzilla.redhat.com/show_bug.cgi?id=770308 for details of
  one report. Waiting on dmidecode output for others).

Currently there is a DMI whitelist, even though the default is on.

This patch extends that dmi list to add a blacklist to automatically
apply disable it when necessary.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 404f21a..2704a9c 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -24,6 +24,12 @@ static int __init set_use_crs(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int __init set_nouse_crs(const struct dmi_system_id *id)
+{
+	pci_use_crs = false;
+	return 0;
+}
+
 static const struct dmi_system_id pci_use_crs_table[] __initconst = {
 	/* http://bugzilla.kernel.org/show_bug.cgi?id=14183 */
 	{
@@ -54,6 +60,18 @@ static const struct dmi_system_id pci_use_crs_table[] __initconst = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
 		},
 	},
+
+	/* Now for the blacklist.. */
+
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=770308 */
+	{
+		.callback = set_nouse_crs,
+		.ident = "Dell Studio 1536",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "0M273C"),
+		},
+	},
 	{}
 };
 
