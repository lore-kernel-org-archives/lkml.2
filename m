Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954Ab2I1S5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:57:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964919Ab2I1S5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 070/262] ACPI / PM: Infer parent power state from child if unknown, v2
Date: Fri, 28 Sep 2012 11:49:59 -0700
Message-Id: <20120928183006.358958948@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 8f7412a792bc989d1bddd3c802282eec09456d57 upstream.

It turns out that there are ACPI BIOSes defining device objects with
_PSx and without either _PSC or _PRx.  For devices corresponding to
those ACPI objetcs __acpi_bus_get_power() returns ACPI_STATE_UNKNOWN
and their initial power states are regarded as unknown as a result.
If such a device is a parent of another power-manageable device, the
child cannot be put into a low-power state through ACPI, because
__acpi_bus_set_power() refuses to change power states of devices
whose parents' power states are unknown.

To work around this problem, observe that the ACPI power state of
a device cannot be higher-power (lower-number) than the power state
of its parent.  Thus, if the device's _PSC method or the
configuration of its power resources indicates that the device is
in D0, the device's parent has to be in D0 as well.  Consequently,
if the parent's power state is unknown when we've just learned that
its child's power state is D0, we can safely set the parent's
power.state field to ACPI_STATE_D0.

Tested-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/bus.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -237,6 +237,16 @@ static int __acpi_bus_get_power(struct a
 	} else if (result == ACPI_STATE_D3_HOT) {
 		result = ACPI_STATE_D3;
 	}
+
+	/*
+	 * If we were unsure about the device parent's power state up to this
+	 * point, the fact that the device is in D0 implies that the parent has
+	 * to be in D0 too.
+	 */
+	if (device->parent && device->parent->power.state == ACPI_STATE_UNKNOWN
+	    && result == ACPI_STATE_D0)
+		device->parent->power.state = ACPI_STATE_D0;
+
 	*state = result;
 
  out:


