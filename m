Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab0CaAjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:39:19 -0400
Received: from kroah.org ([198.145.64.141]:48492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0C3XJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:05 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:54 2010
Message-Id: <20100330224954.169154773@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [21/45] i2c: Do not use device name after device_unregister
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

In Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c556752109794a5ff199b80a1673336b4df8433a

dev_dbg outputs dev_name, which is released with device_unregister. This bug
resulted in output like this:

i2c Xy2�0: adapter [SMBus I801 adapter at 1880] unregistered

The right output would be:
i2c i2c-0: adapter [SMBus I801 adapter at 1880] unregistered

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -644,6 +644,9 @@ int i2c_del_adapter(struct i2c_adapter *
 		}
 	}
 
+	/* device name is gone after device_unregister */
+	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
+
 	/* clean up the sysfs representation */
 	init_completion(&adap->dev_released);
 	device_unregister(&adap->dev);
@@ -654,8 +657,6 @@ int i2c_del_adapter(struct i2c_adapter *
 	/* free bus id */
 	idr_remove(&i2c_adapter_idr, adap->nr);
 
-	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
-
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));


