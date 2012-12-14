Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab2LNW06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:26:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:38111 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab2LNW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:26:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 16/22] ACPI / PNP: Do not crash due to stale pointer use during system resume
Date: Fri, 14 Dec 2012 14:26:01 -0800
Message-Id: <20121214222253.555232738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pnp/pnpacpi/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -94,6 +94,9 @@ static int pnpacpi_set_resources(struct
 		return -ENODEV;
 	}
 
+	if (WARN_ON_ONCE(acpi_dev != dev->data))
+		dev->data = acpi_dev;
+
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;


