Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2K2XGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 18:06:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36531 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab2K2XGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 18:06:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: [PATCH] ACPI / PNP: Do not crash due to stale pointer use during system resume
Date: Fri, 30 Nov 2012 00:10:54 +0100
Message-ID: <1829835.4TBEQGhjkq@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

During resume from system suspend the 'data' field of
struct pnp_dev in pnpacpi_set_resources() may be a stale pointer,
due to removal of the associated ACPI device node object in the
previous suspend-resume cycle.  This happens, for example, if a
dockable machine is booted in the docking station and then suspended
and resumed and suspended again.  If that happens,
pnpacpi_build_resource_template() called from pnpacpi_set_resources()
attempts to use that pointer and crashes.

However, pnpacpi_set_resources() actually checks the device's ACPI
handle, attempts to find the ACPI device node object attached to it
and returns an error code if that fails, so in fact it knows what the
correct value of dev->data should be.  Use this observation to update
dev->data with the correct value if necessary and dump a call trace
if that's the case (once).

We still need to fix the root cause of this issue, but preventing
systems from crashing because of it is an improvement too.

Reported-and-tested-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=51071
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pnp/pnpacpi/core.c |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux.orig/drivers/pnp/pnpacpi/core.c
+++ linux/drivers/pnp/pnpacpi/core.c
@@ -95,6 +95,9 @@ static int pnpacpi_set_resources(struct
 		return -ENODEV;
 	}
 
+	if (WARN_ON_ONCE(acpi_dev != dev->data))
+		dev->data = acpi_dev;
+
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;

