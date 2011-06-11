Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1FKRLH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 13:11:07 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11063 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FKRLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 13:11:05 -0400
Date: Sat, 11 Jun 2011 19:02:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: platform-driver-x86@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: [PATCH] platform, compal: Fix mem leak in compal_probe()
Message-ID: <alpine.LNX.2.00.1106111858490.23835@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll leak the memory allocated to 'data' in 
drivers/platform/x86/compal-laptop.c::compal_probe() if 
sysfs_create_group() doesn't return 0.
Fix the leak by freeing the memory in that case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 compal-laptop.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

	Compile tested only.

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 3f204fd..8877b83 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -1030,8 +1030,10 @@ static int __devinit compal_probe(struct platform_device *pdev)
 	initialize_fan_control_data(data);
 
 	err = sysfs_create_group(&pdev->dev.kobj, &compal_attribute_group);
-	if (err)
+	if (err) {
+		kfree(data);
 		return err;
+	}
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(data->hwmon_dev)) {


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

