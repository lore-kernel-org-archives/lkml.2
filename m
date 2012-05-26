Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2EZNlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:41:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2EZNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:41:28 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 5/5] pstore/ram: Add ftrace messages handling
Date: Sat, 26 May 2012 06:39:09 -0700
Message-Id: <1338039549-24498-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526133412.GA18001@lizard>
References: <20120526133412.GA18001@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace log size is configurable via ramoops.ftrace_size
module option, and the log itself is available via
<pstore-mount>/ftrace-ramoops file.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 Documentation/ramoops.txt  |   24 ++++++++++++++++++++++++
 fs/pstore/ram.c            |   37 +++++++++++++++++++++++++++++++++----
 include/linux/pstore_ram.h |    1 +
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 59a74a8..dee307b 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -94,3 +94,27 @@ timestamp and a new line. The dump then continues with the actual data.
 The dump data can be read from the pstore filesystem. The format for these
 files is "dmesg-ramoops-N", where N is the record number in memory. To delete
 a stored record from RAM, simply unlink the respective pstore file.
+
+5. Persistent function tracing
+
+Persistent function tracing might be useful for debugging software or hardware
+related hangs. The functions call chain log is stored in a "ftrace-ramoops"
+file. Here is an example of usage:
+
+ # mount -t debugfs debugfs /sys/kernel/debug/
+ # cd /sys/kernel/debug/tracing
+ # echo persistent > current_tracer
+ # reboot -f
+ [...]
+ # mount -t pstore pstore /mnt/
+ # tail /mnt/ftrace-ramoops
+ 0 ffffffff8101ea64  ffffffff8101bcda  native_apic_mem_read <- disconnect_bsp_APIC+0x6a/0xc0
+ 0 ffffffff8101ea44  ffffffff8101bcf6  native_apic_mem_write <- disconnect_bsp_APIC+0x86/0xc0
+ 0 ffffffff81020084  ffffffff8101a4b5  hpet_disable <- native_machine_shutdown+0x75/0x90
+ 0 ffffffff81005f94  ffffffff8101a4bb  iommu_shutdown_noop <- native_machine_shutdown+0x7b/0x90
+ 0 ffffffff8101a6a1  ffffffff8101a437  native_machine_emergency_restart <- native_machine_restart+0x37/0x40
+ 0 ffffffff811f9876  ffffffff8101a73a  acpi_reboot <- native_machine_emergency_restart+0xaa/0x1e0
+ 0 ffffffff8101a514  ffffffff8101a772  mach_reboot_fixups <- native_machine_emergency_restart+0xe2/0x1e0
+ 0 ffffffff811d9c54  ffffffff8101a7a0  __const_udelay <- native_machine_emergency_restart+0x110/0x1e0
+ 0 ffffffff811d9c34  ffffffff811d9c80  __delay <- __const_udelay+0x30/0x40
+ 0 ffffffff811d9d14  ffffffff811d9c3f  delay_tsc <- __delay+0xf/0x20
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 96dbd1e..018d895 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -45,6 +45,10 @@ static ulong ramoops_console_size = MIN_MEM_SIZE;
 module_param_named(console_size, ramoops_console_size, ulong, 0400);
 MODULE_PARM_DESC(console_size, "size of kernel console log");
 
+static ulong ramoops_ftrace_size = MIN_MEM_SIZE;
+module_param_named(ftrace_size, ramoops_ftrace_size, ulong, 0400);
+MODULE_PARM_DESC(ftrace_size, "size of ftrace log");
+
 static ulong mem_address;
 module_param(mem_address, ulong, 0400);
 MODULE_PARM_DESC(mem_address,
@@ -68,16 +72,19 @@ MODULE_PARM_DESC(ramoops_ecc,
 struct ramoops_context {
 	struct persistent_ram_zone **przs;
 	struct persistent_ram_zone *cprz;
+	struct persistent_ram_zone *fprz;
 	phys_addr_t phys_addr;
 	unsigned long size;
 	size_t record_size;
 	size_t console_size;
+	size_t ftrace_size;
 	int dump_oops;
 	bool ecc;
 	unsigned int max_dump_cnt;
 	unsigned int dump_write_cnt;
 	unsigned int dump_read_cnt;
 	unsigned int console_read_cnt;
+	unsigned int ftrace_read_cnt;
 	struct pstore_info pstore;
 };
 
@@ -136,6 +143,9 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 		prz = ramoops_get_next_prz(&cxt->cprz, &cxt->console_read_cnt,
 					   1, id, type, PSTORE_TYPE_CONSOLE, 0);
 	if (!prz)
+		prz = ramoops_get_next_prz(&cxt->fprz, &cxt->ftrace_read_cnt,
+					   1, id, type, PSTORE_TYPE_FTRACE, 0);
+	if (!prz)
 		return 0;
 
 	/* TODO(kees): Bogus time for the moment. */
@@ -184,6 +194,11 @@ static int ramoops_pstore_write_buf(enum pstore_type_id type,
 			return -ENOMEM;
 		persistent_ram_write(cxt->cprz, buf, size);
 		return 0;
+	} else if (type == PSTORE_TYPE_FTRACE) {
+		if (!cxt->fprz)
+			return -ENOMEM;
+		persistent_ram_write(cxt->fprz, buf, size);
+		return 0;
 	}
 
 	if (type != PSTORE_TYPE_DMESG)
@@ -233,6 +248,9 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 	case PSTORE_TYPE_CONSOLE:
 		prz = cxt->cprz;
 		break;
+	case PSTORE_TYPE_FTRACE:
+		prz = cxt->fprz;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -346,7 +364,8 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	if (cxt->max_dump_cnt)
 		goto fail_out;
 
-	if (!pdata->mem_size || (!pdata->record_size && !pdata->console_size)) {
+	if (!pdata->mem_size || (!pdata->record_size && !pdata->console_size &&
+			!pdata->ftrace_size)) {
 		pr_err("The memory size and the record/console size must be "
 			"non-zero\n");
 		goto fail_out;
@@ -355,18 +374,20 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
 	pdata->console_size = rounddown_pow_of_two(pdata->console_size);
+	pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
 	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;
 	cxt->phys_addr = pdata->mem_address;
 	cxt->record_size = pdata->record_size;
 	cxt->console_size = pdata->console_size;
+	cxt->ftrace_size = pdata->ftrace_size;
 	cxt->dump_oops = pdata->dump_oops;
 	cxt->ecc = pdata->ecc;
 
 	paddr = cxt->phys_addr;
 
-	dump_mem_sz = cxt->size - cxt->console_size;
+	dump_mem_sz = cxt->size - cxt->console_size - cxt->ftrace_size;
 	err = ramoops_init_przs(dev, cxt, &paddr, dump_mem_sz);
 	if (err)
 		goto fail_out;
@@ -375,9 +396,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	if (err)
 		goto fail_init_cprz;
 
-	if (!cxt->przs && !cxt->cprz) {
+	err = ramoops_init_prz(dev, cxt, &cxt->fprz, &paddr, cxt->ftrace_size);
+	if (err)
+		goto fail_init_fprz;
+
+	if (!cxt->przs && !cxt->cprz && !cxt->fprz) {
 		pr_err("memory size too small, minimum is %lu\n",
-			cxt->console_size + cxt->record_size);
+			cxt->console_size + cxt->record_size +
+			cxt->ftrace_size);
 		goto fail_cnt;
 	}
 
@@ -424,6 +450,8 @@ fail_clear:
 	cxt->pstore.bufsize = 0;
 	cxt->max_dump_cnt = 0;
 fail_cnt:
+	kfree(cxt->fprz);
+fail_init_fprz:
 	kfree(cxt->cprz);
 fail_init_cprz:
 	ramoops_free_przs(cxt);
@@ -478,6 +506,7 @@ static int __init ramoops_init(void)
 		dummy_data->mem_address = mem_address;
 		dummy_data->record_size = record_size;
 		dummy_data->console_size = ramoops_console_size;
+		dummy_data->ftrace_size = ramoops_ftrace_size;
 		dummy_data->dump_oops = dump_oops;
 		dummy_data->ecc = ramoops_ecc;
 		dummy = platform_create_bundle(&ramoops_driver, ramoops_probe,
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 2470bb5..368da13 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -75,6 +75,7 @@ struct ramoops_platform_data {
 	unsigned long	mem_address;
 	unsigned long	record_size;
 	unsigned long	console_size;
+	unsigned long	ftrace_size;
 	int		dump_oops;
 	bool		ecc;
 };
-- 
1.7.9.2

