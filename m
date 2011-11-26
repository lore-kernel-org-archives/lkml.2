Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1KZRbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:31:15 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63340 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab1KZRbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:31:11 -0500
Date: Sat, 26 Nov 2011 18:31:03 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org
Cc: federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: [RFC PATCH 5/7] drivers/zio: add the zio-zero device driver
Message-ID: <3b24e14bae3801e2d86db7bcbb3f6c2625026c97.1322328076.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1322328073.git.rubini@gnudd.com>
In-Reply-To: <cover.1322328073.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federico Vaga <federico.vaga@gmail.com>

zio-zero is a demonstration driver that generates /dev/zero-like data.
I can be used to test the default trigger and the default buffer.
The files match commit 7d37663 in git://ohwr.org/misc/zio.git .

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Samuel Iglesias Gonsalvez <siglesia@cern.ch>
Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/zio/drivers/Makefile   |    1 +
 drivers/zio/drivers/zio-zero.c |   87 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 drivers/zio/drivers/Makefile
 create mode 100644 drivers/zio/drivers/zio-zero.c

diff --git a/drivers/zio/drivers/Makefile b/drivers/zio/drivers/Makefile
new file mode 100644
index 0000000..d59387b
--- /dev/null
+++ b/drivers/zio/drivers/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ZIO) += zio-zero.o
diff --git a/drivers/zio/drivers/zio-zero.c b/drivers/zio/drivers/zio-zero.c
new file mode 100644
index 0000000..f803e09
--- /dev/null
+++ b/drivers/zio/drivers/zio-zero.c
@@ -0,0 +1,87 @@
+/* Federico Vaga for CERN, 2011, GNU GPLv2 or later */
+/*
+ * zero-zio is a simple zio driver which fill buffer with 0. From the ZIO
+ * point of view is an input device
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+
+#include <linux/zio.h>
+#include <linux/zio-buffer.h>
+
+static char *zzero_trigger;
+static char *zzero_buffer;
+module_param_named(trigger, zzero_trigger, charp, 0444);
+module_param_named(buffer, zzero_buffer, charp, 0444);
+
+static int zzero_input(struct zio_cset *cset)
+{
+	struct zio_channel *chan;
+	struct zio_block *block;
+	static uint8_t datum;
+	uint8_t *data;
+	int i;
+
+	/* Return immediately: just fill the blocks */
+	cset_for_each(cset, chan) {
+		block = chan->active_block;
+		if (!block)
+			continue;
+		switch (chan->index) {
+		case 0: /* zero */
+			memset(block->data, 0x0, block->datalen);
+			break;
+		case 1: /* random */
+			get_random_bytes(block->data, block->datalen);
+			break;
+		case 2: /* sequence */
+			data = block->data;
+			for (i = 0; i < block->datalen; i++)
+				data[i] = datum++;
+		}
+	}
+	return 1; /* Already done */
+}
+
+static const struct zio_device_operations zzero_d_op = {
+	.input_cset =		zzero_input,
+};
+
+static struct zio_cset zzero_cset[] = {
+	{
+		.n_chan =	3,
+		.ssize =	1,
+		.flags =	ZIO_DIR_INPUT | ZCSET_TYPE_ANALOG,
+	},
+};
+
+static struct zio_device zzero_dev = {
+	.owner =		THIS_MODULE,
+	.d_op =			&zzero_d_op,
+	.cset =			zzero_cset,
+	.n_cset =		ARRAY_SIZE(zzero_cset),
+};
+
+static int __init zzero_init(void)
+{
+	if (zzero_trigger)
+		zzero_dev.preferred_trigger = zzero_trigger;
+	if (zzero_buffer)
+		zzero_dev.preferred_buffer = zzero_buffer;
+	return zio_register_dev(&zzero_dev, "zzero");
+}
+
+static void __exit zzero_exit(void)
+{
+	zio_unregister_dev(&zzero_dev);
+}
+
+module_init(zzero_init);
+module_exit(zzero_exit);
+
+MODULE_AUTHOR("Federico Vaga <federico.vaga@gmail.com>");
+MODULE_DESCRIPTION("A zio driver which fakes zero, random and sawtooth input");
+MODULE_LICENSE("GPL");
-- 
1.7.7.2
