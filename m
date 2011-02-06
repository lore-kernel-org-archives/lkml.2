Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1BFKvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:51:43 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:41951 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1BFKva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:51:30 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        cz-bobek-lists-aranym@lists.bobek.cz
Cc: Roman Zippel <zippel@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Petr Stehlik <pstehlik@sophics.cz>
Subject: [PATCH 3/4] m68k/atari: ARAnyM - Add support for console access
Date: Sun,  6 Feb 2011 11:51:08 +0100
Message-Id: <1296989469-7844-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
References: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
[geert] Cleanups and updates
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Petr Stehlik <pstehlik@sophics.cz>

---
Changelog:
  - early_param() does not exist in the modular case,
  - Break too long lines,
  - Make needlessly global functions static,
  - Use pr_*(),
  - Extract nfputs(), to avoid code duplication in nfcon_write() and
    nfcon_tty_write().
---
 arch/m68k/Kconfig      |    8 +++
 arch/m68k/emu/Makefile |    1 +
 arch/m68k/emu/nfcon.c  |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 arch/m68k/emu/nfcon.c

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2c890b5..6719c56 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -255,6 +255,14 @@ config NFBLOCK
 	  which allows direct access to the hard drives without using
 	  the hardware emulation.
 
+config NFCON
+	tristate "NatFeat console driver"
+	depends on NATFEAT
+	help
+	  Say Y to include support for the ARAnyM NatFeat console driver
+	  which allows the console output to be redirected to the stderr
+	  output of ARAnyM.
+
 comment "Processor type"
 
 config M68020
diff --git a/arch/m68k/emu/Makefile b/arch/m68k/emu/Makefile
index fc4f77a..a83ef1e 100644
--- a/arch/m68k/emu/Makefile
+++ b/arch/m68k/emu/Makefile
@@ -5,3 +5,4 @@
 obj-y			+= natfeat.o
 
 obj-$(CONFIG_NFBLOCK)	+= nfblock.o
+obj-$(CONFIG_NFCON)	+= nfcon.o
diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
new file mode 100644
index 0000000..ab20dc0
--- /dev/null
+++ b/arch/m68k/emu/nfcon.c
@@ -0,0 +1,162 @@
+/*
+ * ARAnyM console driver
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/uaccess.h>
+
+#include <asm/natfeat.h>
+
+static int stderr_id;
+static struct tty_driver *nfcon_tty_driver;
+
+static void nfputs(const char *str, unsigned int count)
+{
+	char buf[68];
+
+	buf[64] = 0;
+	while (count > 64) {
+		memcpy(buf, str, 64);
+		nf_call(stderr_id, buf);
+		str += 64;
+		count -= 64;
+	}
+	memcpy(buf, str, count);
+	buf[count] = 0;
+	nf_call(stderr_id, buf);
+}
+
+static void nfcon_write(struct console *con, const char *str,
+			unsigned int count)
+{
+	nfputs(str, count);
+}
+
+static struct tty_driver *nfcon_device(struct console *con, int *index)
+{
+	*index = 0;
+	return (con->flags & CON_ENABLED) ? nfcon_tty_driver : NULL;
+}
+
+static struct console nf_console = {
+	.name	= "nfcon",
+	.write	= nfcon_write,
+	.device	= nfcon_device,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+};
+
+
+static int nfcon_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	return 0;
+}
+
+static void nfcon_tty_close(struct tty_struct *tty, struct file *filp)
+{
+}
+
+static int nfcon_tty_write(struct tty_struct *tty, const unsigned char *buf,
+			   int count)
+{
+	nfputs(buf, count);
+	return count;
+}
+
+static int nfcon_tty_put_char(struct tty_struct *tty, unsigned char ch)
+{
+	char temp[2] = { ch, 0 };
+
+	nf_call(stderr_id, temp);
+	return 1;
+}
+
+static int nfcon_tty_write_room(struct tty_struct *tty)
+{
+	return 64;
+}
+
+static const struct tty_operations nfcon_tty_ops = {
+	.open		= nfcon_tty_open,
+	.close		= nfcon_tty_close,
+	.write		= nfcon_tty_write,
+	.put_char	= nfcon_tty_put_char,
+	.write_room	= nfcon_tty_write_room,
+};
+
+#ifndef MODULE
+
+static int __init nf_debug_setup(char *arg)
+{
+	if (strcmp(arg, "nfcon"))
+		return 0;
+
+	stderr_id = nf_get_id("NF_STDERR");
+	if (stderr_id) {
+		nf_console.flags |= CON_ENABLED;
+		register_console(&nf_console);
+	}
+
+	return 0;
+}
+
+early_param("debug", nf_debug_setup);
+
+#endif /* !MODULE */
+
+static int __init nfcon_init(void)
+{
+	int res;
+
+	stderr_id = nf_get_id("NF_STDERR");
+	if (!stderr_id)
+		return -ENODEV;
+
+	nfcon_tty_driver = alloc_tty_driver(1);
+	if (!nfcon_tty_driver)
+		return -ENOMEM;
+
+	nfcon_tty_driver->owner = THIS_MODULE;
+	nfcon_tty_driver->driver_name = "nfcon";
+	nfcon_tty_driver->name = "nfcon";
+	nfcon_tty_driver->type = TTY_DRIVER_TYPE_SYSTEM;
+	nfcon_tty_driver->subtype = SYSTEM_TYPE_TTY;
+	nfcon_tty_driver->init_termios = tty_std_termios;
+	nfcon_tty_driver->flags = TTY_DRIVER_REAL_RAW;
+
+	tty_set_operations(nfcon_tty_driver, &nfcon_tty_ops);
+	res = tty_register_driver(nfcon_tty_driver);
+	if (res) {
+		pr_err("failed to register nfcon tty driver\n");
+		put_tty_driver(nfcon_tty_driver);
+		return res;
+	}
+
+	if (!(nf_console.flags & CON_ENABLED))
+		register_console(&nf_console);
+
+	return 0;
+}
+
+static void __exit nfcon_exit(void)
+{
+	unregister_console(&nf_console);
+	tty_unregister_driver(nfcon_tty_driver);
+	put_tty_driver(nfcon_tty_driver);
+}
+
+module_init(nfcon_init);
+module_exit(nfcon_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

