Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2L1Tkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:40:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55371 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932187Ab2L1TSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:43 -0500
Message-Id: <20121228190349.717575619@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 093/173] ACPI / PNP: Do not crash due to stale pointer use during system
 resume
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit a6b5e88c0e42093b9057856f35770966c8c591e3 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pnp/pnpacpi/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 26b5d4b..ec8e914 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -95,6 +95,9 @@ static int pnpacpi_set_resources(struct pnp_dev *dev)
 		return -ENODEV;
 	}
 
+	if (WARN_ON_ONCE(acpi_dev != dev->data))
+		dev->data = acpi_dev;
+
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;


