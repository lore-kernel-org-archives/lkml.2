Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab1D1JBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:01:37 -0400
Received: from smtp.nokia.com ([147.243.128.26]:49298 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415Ab1D1JBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:01:35 -0400
From: <kalle.jokiniemi@nokia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@slimlogic.co.uk>,
        <mchehab@infradead.org>, <svarbatov@mm-sol.com>, <saaguirre@ti.com>,
        <grosikopulos@mm-sol.com>, <vimarsh.zutshi@nokia.com>,
        <Sakari.Ailus@nokia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [RFC] Regulator state after regulator_get 
Thread-Topic: [RFC] Regulator state after regulator_get 
Thread-Index: AcwFgGFZ8c8Rl1ULSTCPpipjMzkFdg==
Date: Thu, 28 Apr 2011 09:01:03 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.212.101]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Apr 2011 09:01:06.0560 (UTC) FILETIME=[CF1D6800:01CC0582]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello regulator FW and OMAP3 ISP fellows,

I'm currently optimizing power management for Nokia N900 MeeGo DE release,
and found an issue with how regulators are handled at boot.

The N900 uses VAUX2 regulator in OMAP3430 to power the CSIb IO complex
that is used by the camera. While implementing regulator FW support to
handle this regulator in the camera driver I noticed a problem with the
regulator init sequence:

If the device driver using the regulator does not enable and disable the
regulator after regulator_get, the regulator is left in the state that it was
after bootloader. In case of N900 this is a problem as the regulator is left
on to leak current. Of course there is the option to let regulator FW disable
all unused regulators, but this will break the N900 functionality, as the
regulator handling is not in place for many drivers. 

I found couple of solutions to this:
1. reset all regulators that have users (regulator_get is called on them) with
a regulator_enable/disable cycle within the regulator FW.
2. enable/disable the specific vdds_csib regulator in the omap3isp driver
to reset this one specific regulator to disabled state.

So, please share comments on which approach is more appropriate to take?
Or maybe there is option 3?

Here are example code for the two options (based on .37 kernel, will update
on top of appropriate tree once right solution is agreed):

Option1:

If a consumer device of a regulator gets a regulator, but
does not enable/disable it during probe, the regulator may
be left active from boot, even though it is not needed. If
it were needed it would be enabled by the consumer device.

So reset the regulator on first regulator_get call to make
sure that any regulator that has users is not left active
needlessly.

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
---
 drivers/regulator/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ba521f0..040d850 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1152,6 +1152,12 @@ found:
 		module_put(rdev->owner);
 	}
 
+	/* Reset regulator to make sure it is disabled, if not needed */
+	if (!rdev->open_count) {
+		regulator_enable(regulator);
+		regulator_disable(regulator);
+	}
+
 	rdev->open_count++;
 	if (exclusive) {
 		rdev->exclusive = 1;
--

Option2:

Do a enable/disable cycle of the vdds_csib regulator to make
sure it is disabled after init in case there are no other
users for it. Otherwise regulator framework may leave it
active in case it was activated by bootloader.

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
---
 drivers/media/video/isp/ispccp2.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/isp/ispccp2.c b/drivers/media/video/isp/ispccp2.c
index 2d6b014..e11957f 100644
--- a/drivers/media/video/isp/ispccp2.c
+++ b/drivers/media/video/isp/ispccp2.c
@@ -1201,6 +1201,11 @@ int isp_ccp2_init(struct isp_device *isp)
 		}
 	}
 
+	if (ccp2->vdds_csib) {
+		regulator_enable(ccp2->vdds);
+		regulator_disable(ccp2->vdds);
+	}
+
 	ret = isp_ccp2_init_entities(ccp2);
 	if (ret < 0)
 		goto out;
--




Thanks,
Kalle

