Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2IKUbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:31:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2IKUbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:31:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] ACPI / PM: Infer parent power state from child if unknown, v2
Date: Tue, 11 Sep 2012 22:38:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1346053126-7646-1-git-send-email-aaron.lu@intel.com> <201209102150.22738.rjw@sisk.pl> <20120911053305.GA2130@mint-spring.sh.intel.com>
In-Reply-To: <20120911053305.GA2130@mint-spring.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209112238.06658.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
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
