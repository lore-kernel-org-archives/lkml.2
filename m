Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0IMKOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:14:47 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:60532 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0IMKOq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 13 Sep 2010 06:14:46 -0400
Message-Id: <4C8E15B30200007800015AC9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:14:43 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <khali@linux-fr.org>
Cc: <fenghua.yu@intel.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: don't leak device attribute file from
	 pkgtemp_probe()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While apparently inherited from coretemp source, this particular error
handling cleanup path wasn't copied properly (or perhaps got discarded
intermediately and not re-added properly later).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>

---
 drivers/hwmon/pkgtemp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000 +0200
+++ 2.6.36-rc4-x86-pkgtemp-probe-error-path/drivers/hwmon/pkgtemp.c	2010-09-03 17:54:30.000000000 +0200
@@ -224,7 +224,7 @@ static int __devinit pkgtemp_probe(struc
 
 	err = sysfs_create_group(&pdev->dev.kobj, &pkgtemp_group);
 	if (err)
-		goto exit_free;
+		goto exit_dev;
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(data->hwmon_dev)) {
@@ -238,6 +238,8 @@ static int __devinit pkgtemp_probe(struc
 
 exit_class:
 	sysfs_remove_group(&pdev->dev.kobj, &pkgtemp_group);
+exit_dev:
+	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr);
 exit_free:
 	kfree(data);
 exit:



