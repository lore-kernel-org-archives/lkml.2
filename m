Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1GNO7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:59:54 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:37469 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab1GNO7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:59:53 -0400
Date: Thu, 14 Jul 2011 16:45:09 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in BCMA: device_unregister causing "NULL pointer dereference at"
Message-ID: <20110714144509.GA6391@electric-eye.fr.zoreil.com>
References: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki <zajec5@gmail.com> :
[...]
> Any tip, why does it happen?

bcma_release_core_dev kfrees core while its list_head is still used ?

May be something like this :

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index be52344..85fb3aa 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -110,11 +110,14 @@ static int bcma_register_cores(struct bcma_bus *bus)
 
 static void bcma_unregister_cores(struct bcma_bus *bus)
 {
-	struct bcma_device *core;
+	struct bcma_device *core, *next;
 
-	list_for_each_entry(core, &bus->cores, list) {
+	list_for_each_entry_safe(core, next, &bus->cores, list) {
+		list_del(&core->list);
 		if (core->dev_registered)
 			device_unregister(&core->dev);
+		else
+			kfree(core);
 	}
 }
 
