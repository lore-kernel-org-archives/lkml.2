Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0LHVgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:36:32 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:24009 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab0LHVg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:29 -0500
Subject: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Wed, 08 Dec 2010 14:36:27 -0700
Message-ID: <20101208213627.13026.18854.stgit@bob.kio>
In-Reply-To: <20101208213606.13026.47657.stgit@bob.kio>
References: <20101208213606.13026.47657.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The HP nx6325 BIOS doesn't report any devices in the [0xf8000000-0xfbffffff]
region via ACPI devices or the E820 memory map, but when we assign it to the
00:14.4 bridge as a prefetchable memory window, the machine hangs.

I determined experimentally that there are only three 1MB regions in
that area that cause trouble, so this fixup builds a fake PNP device
that consumes those regions.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23332
Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/quirks.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)


diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index f18bb69..e7de402 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -343,7 +343,37 @@ static struct pnp_protocol pnp_fixup_protocol = {
 	.name = "Plug and Play fixup",
 };
 
+static int __init hp_nx6325_fixup(const struct dmi_system_id *d)
+{
+	struct pnp_dev *dev;
+
+	/*
+	 * The BIOS apparently forgot to describe some regions in the
+	 * address map.  See https://bugzilla.kernel.org/show_bug.cgi?id=23332
+	 */
+
+	dev = pnp_alloc_dev(&pnp_fixup_protocol, 0, "LNXHAZRD");
+	if (!dev)
+		return 0;
+
+	dev->active = 1;
+	pnp_add_mem_resource(dev, 0xf8300000, 0xf83fffff, 0);
+	pnp_add_mem_resource(dev, 0xf8500000, 0xf85fffff, 0);
+	pnp_add_mem_resource(dev, 0xf9100000, 0xf91fffff, 0);
+	pnp_add_device(dev);
+	dev_info(&dev->dev, "added to work around BIOS defect\n");
+	return 0;
+}
+
 static const struct dmi_system_id pnp_fixup_table[] __initconst = {
+	{
+		.callback = hp_nx6325_fixup,
+		.ident = "HP nx6325 laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+		},
+	},
 	{}
 };
 

