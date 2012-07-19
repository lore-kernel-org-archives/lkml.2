Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2GSEkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:40:23 -0400
Received: from lunge.queued.net ([173.255.254.236]:53842 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab2GSEkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:40:21 -0400
Date: Wed, 18 Jul 2012 21:40:09 -0700
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
        "Richard A. Smith" <richard@laptop.org>, linux-kernel@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        devel@driverdev.osuosl.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RESEND 4/9] Platform: OLPC: turn EC driver into a
 platform_driver
Message-ID: <20120718214009.7af19d69@dev.queued.net>
In-Reply-To: <20120718213713.232e4161@dev.queued.net>
References: <20120718213713.232e4161@dev.queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 1.75-based OLPC EC driver already does this; let's do it for all EC
drivers.  This gives us nice suspend/resume hooks, amongst other things.

We want to run the EC's suspend hooks later than other drivers (which may
be setting wakeup masks or be running EC commands).  We also want to run
the EC's resume hooks earlier than other drivers (which may want to run EC
commands).

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/platform/olpc/olpc-ec.c |   48 +++++++++++++++++++++++++++++++++++++++
 include/linux/olpc-ec.h         |    6 +++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 44e6a4f..d00523c 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -8,6 +8,7 @@
 #include <linux/completion.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/platform_device.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/list.h>
@@ -122,3 +123,50 @@ int olpc_ec_cmd(u8 cmd, u8 *inbuf, size_t inlen, u8 *outbuf, size_t outlen)
 	return desc.err;
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
+
+static int olpc_ec_probe(struct platform_device *pdev)
+{
+	int err;
+
+	if (!ec_driver)
+		return -ENODEV;
+
+	err = ec_driver->probe ? ec_driver->probe(pdev) : 0;
+
+	return err;
+}
+
+static int olpc_ec_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	return ec_driver->suspend ? ec_driver->suspend(pdev) : 0;
+}
+
+static int olpc_ec_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	return ec_driver->resume ? ec_driver->resume(pdev) : 0;
+}
+
+static const struct dev_pm_ops olpc_ec_pm_ops = {
+	.suspend_late = olpc_ec_suspend,
+	.resume_early = olpc_ec_resume,
+};
+
+static struct platform_driver olpc_ec_plat_driver = {
+	.probe = olpc_ec_probe,
+	.driver = {
+		.name = "olpc-ec",
+		.pm = &olpc_ec_pm_ops,
+	},
+};
+
+static int __init olpc_ec_init_module(void)
+{
+	return platform_driver_register(&olpc_ec_plat_driver);
+}
+
+module_init(olpc_ec_init_module);
+
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/olpc-ec.h b/include/linux/olpc-ec.h
index 231e96f..5bb6e76 100644
--- a/include/linux/olpc-ec.h
+++ b/include/linux/olpc-ec.h
@@ -14,7 +14,13 @@
 #define EC_SCI_QUERY			0x84
 #define EC_EXT_SCI_QUERY		0x85
 
+struct platform_device;
+
 struct olpc_ec_driver {
+	int (*probe)(struct platform_device *);
+	int (*suspend)(struct platform_device *);
+	int (*resume)(struct platform_device *);
+
 	int (*ec_cmd)(u8, u8 *, size_t, u8 *, size_t, void *);
 };
 
-- 
1.7.2.5

