Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0CUKNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:13:12 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:42710 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0CUKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fd3mU9ZGleikFV60aBLJLubIvI3YY/ywtUMNPf9Vj2/kgRtUC3ZJI5VLlJjV1URbeK
         jIoGHIXDYHreZtzYhmvYZMRz1H7i5l2OaRNazBVy0I8rAr/MSCo9Mbg95gEYbYn9sR30
         XEptjiSlNVhkF3TZSkKphs45c0XPhRcknpsYc=
Message-ID: <4BA5F0C3.6040709@gmail.com>
Date: Sun, 21 Mar 2010 11:11:15 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>, akpm@linux-foundation.org,
       David.Woodhouse@intel.com, anders.grafstrom@netinsight.net,
       simon.kagstrom@netinsight.net, yuasa@linux-mips.org, gregkh@suse.de
Subject: [PATCH v3] char drivers: Ram oops/panic logger
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Ramoops, like mtdoops, can log oops/panic information but in RAM. It can
be used with persistent RAM for systems without flash support. In
addition, for this systems, with this driver, it's no more needed
add to the kernel the mtd subsystem with advantage in footprint.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
Changelog:
-v1: first draft
-v2: fixed compilation warning when using request_mem_region
-v3: changed permissions from 0600 to 0400 for size and address
of ram buffer. Fixed the lack of 'ramoops:' in some printk.

--- linux-2.6.33-orig/drivers/char/Kconfig	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/char/Kconfig	2010-02-28 10:47:29.000000000 +0100
@@ -1105,5 +1105,12 @@ config DEVPORT
 
 source "drivers/s390/char/Kconfig"
 
+config RAMOOPS
+	tristate "Log panic/oops to a RAM buffer"
+	default n
+	help
+	  This enables panic and oops messages to be logged to a circular
+	  buffer in RAM where it can be read back at some later point.
+
 endmenu
 
--- linux-2.6.33-orig/drivers/char/Makefile	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/char/Makefile	2010-02-28 10:49:17.000000000 +0100
@@ -107,6 +107,7 @@ obj-$(CONFIG_HANGCHECK_TIMER)	+= hangche
 obj-$(CONFIG_TCG_TPM)		+= tpm/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
+obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
--- linux-2.6.33-orig/drivers/char/ramoops.c	2009-12-16 00:58:07.000000000 +0100
+++ linux-2.6.33/drivers/char/ramoops.c	2010-03-21 11:06:40.000000000 +0100
@@ -0,0 +1,162 @@
+/*
+ * RAM Oops/Panic logger
+ *
+ * Copyright (C) 2010 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kmsg_dump.h>
+#include <linux/time.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+
+#define RAMOOPS_KERNMSG_HDR "===="
+#define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
+
+#define RECORD_SIZE 4096
+
+static ulong mem_address;
+module_param(mem_address, ulong, 0400);
+MODULE_PARM_DESC(mem_address,
+		"start of reserved RAM used to store oops/panic logs");
+
+static ulong mem_size;
+module_param(mem_size, ulong, 0400);
+MODULE_PARM_DESC(mem_size,
+		"size of reserved RAM used to store oops/panic logs");
+
+static int dump_oops = 1;
+module_param(dump_oops, int, 0600);
+MODULE_PARM_DESC(dump_oops,
+		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
+
+static struct ramoops_context {
+	struct kmsg_dumper dump;
+	void *virt_addr;
+	phys_addr_t phys_addr;
+	unsigned long size;
+	int count;
+	int max_count;
+} oops_cxt;
+
+static void ramoops_do_dump(struct kmsg_dumper *dumper,
+		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
+		const char *s2, unsigned long l2)
+{
+	struct ramoops_context *cxt = container_of(dumper,
+			struct ramoops_context, dump);
+	unsigned long s1_start, s2_start;
+	unsigned long l1_cpy, l2_cpy;
+	int res;
+	char *buf;
+	struct timeval timestamp;
+
+	/* Only dump oopses if dump_oops is set */
+	if (reason == KMSG_DUMP_OOPS && !dump_oops)
+		return;
+
+	buf = (char *)(cxt->virt_addr + (cxt->count * RECORD_SIZE));
+	memset(buf, '\0', RECORD_SIZE);
+	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
+	buf += res;
+	do_gettimeofday(&timestamp);
+	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
+	buf += res;
+
+	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE));
+	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE) - l2_cpy);
+
+	s2_start = l2 - l2_cpy;
+	s1_start = l1 - l1_cpy;
+
+	memcpy(buf, s1 + s1_start, l1_cpy);
+	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
+
+	cxt->count = (cxt->count + 1) % cxt->max_count;
+}
+
+static int __init ramoops_init(void)
+{
+	struct ramoops_context *cxt = &oops_cxt;
+	int err = -EINVAL;
+
+	if (!mem_size) {
+		printk(KERN_ERR "ramoops: invalid size specification");
+		goto fail3;
+	}
+
+	rounddown_pow_of_two(mem_size);
+
+	if (mem_size < RECORD_SIZE) {
+		printk(KERN_ERR "ramoops: size too small");
+		goto fail3;
+	}
+
+	cxt->max_count = mem_size / RECORD_SIZE;
+	cxt->count = 0;
+	cxt->size = mem_size;
+	cxt->phys_addr = mem_address;
+
+	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
+		printk(KERN_ERR "ramoops: request mem region failed");
+		err = -EINVAL;
+		goto fail3;
+	}
+
+	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
+	if (!cxt->virt_addr) {
+		printk(KERN_ERR "ramoops: ioremap failed");
+		goto fail2;
+	}
+
+	cxt->dump.dump = ramoops_do_dump;
+	err = kmsg_dump_register(&cxt->dump);
+	if (err) {
+		printk(KERN_ERR "ramoops: registering kmsg dumper failed");
+		goto fail1;
+	}
+
+	return 0;
+
+fail1:
+	iounmap(cxt->virt_addr);
+fail2:
+	release_mem_region(cxt->phys_addr, cxt->size);
+fail3:
+	return err;
+}
+
+static void __exit ramoops_exit(void)
+{
+	struct ramoops_context *cxt = &oops_cxt;
+
+	if (kmsg_dump_unregister(&cxt->dump) < 0)
+		printk(KERN_WARNING "ramoops: could not unregister kmsg_dumper");
+
+	iounmap(cxt->virt_addr);
+	release_mem_region(cxt->phys_addr, cxt->size);
+}
+
+
+module_init(ramoops_init);
+module_exit(ramoops_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marco Stornelli <marco.stornelli@gmail.com>");
+MODULE_DESCRIPTION("RAM Oops/Panic logger/driver");

