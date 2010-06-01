Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab0FATce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:32:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15100 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0FATcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=AquEo3et2v74FU/DcA7kcKaq59NbLJ7ht2psKw9wnPqacC3JqFQurMa3GU9/wdBqBY
         FxAY8UjJsUdPP6GO/DMl6MRC7++EFkxkEsKSaoDHANVI4BIxRRjpbT80jwN6BOgJkV4l
         J1k5koxO2YoN9lq8ECeIFK4Yn2eVyEtNjgg3A=
Subject: RAMOOPS: few questions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: marco.stornelli@gmail.com
Content-Type: multipart/mixed; boundary="=-2e5zGR+zTsHGvNNgRBPH"
Date: Tue, 01 Jun 2010 22:32:27 +0300
Message-ID: <1275420747.2574.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2e5zGR+zTsHGvNNgRBPH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

I want to switch over my own patch that does more or less the same that
this driver.

As I see this driver uses ioremap to reserve the memory.
However, I have a question about how to tell kernel that specific memory
region is reserved.

Well, I use now mem=... to do so, but this wastes space, because the
region I need can't be near end of the RAM.

I tried to use 'memmap=20M$0x70000000' on kernel command line, but that
just makes kernel reboot.
I think its a bug though.

Also, does this driver dupms all kernel log or only panic/oops message?
My patch actually makes kernel store actual printk buffer in fixed
location, thus it is very robust. It was rejected though in favour of
solution you eventually implemented.

Also I would like to extend your driver to dump old contents of the ram
buffer to kernel log, so one wouldn't worry about erasing in on next
boot after crash.
Don't know when I do that though.

Best regards,
Maxim Levitsky.

For reference my patch attached.



--=-2e5zGR+zTsHGvNNgRBPH
Content-Disposition: attachment; filename="ram_printk.diff"
Content-Type: text/x-patch; name="ram_printk.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

commit 58316c061f10839dfd5ebfd6ed4def6370de7b62
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Thu May 27 22:49:01 2010 +0300

    printk: Allow to store log buffer into video memory
    
    This patch adds new kernel parameter printk_address=
    that will allow it to store the printk buffer in arbitary
    (I/O) memory address.
    
    If you own a system that has discrete video ram, and it
    isn't cleared automaticly by bios on reboot, you
    can use this as a black box recorder of crashes.
    
    If debugfs is enabled, log of last boot is copied into
    system ram, and can be accessed via debugfs, for example
    cat /sys/kernel/debug/printk/crash_dmesg
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

diff --git a/kernel/printk.c b/kernel/printk.c
index 444b770..68df9fd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -39,6 +39,7 @@
 #include <linux/syslog.h>
 
 #include <asm/uaccess.h>
+#include <linux/debugfs.h>
 
 /*
  * for_each_console() allows you to iterate on each console
@@ -146,6 +147,7 @@ static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 static int saved_console_loglevel = -1;
+static unsigned int printk_phys_address;
 
 #ifdef CONFIG_KEXEC
 /*
@@ -170,6 +172,9 @@ static int __init log_buf_len_setup(char *str)
 	unsigned size = memparse(str, &str);
 	unsigned long flags;
 
+	if (printk_phys_address)
+		return 1;
+
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len) {
@@ -206,6 +211,103 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
+
+#ifdef CONFIG_HWMEM_PRINTK
+
+#define EARLY_LOG_PAGES (8 * PAGE_SIZE)
+char *old_log_buf;
+struct debugfs_blob_wrapper crash_dmesg_wrapper;
+
+static int __init printk_phys_address_setup(char *str)
+{
+	unsigned long flags;
+	void *mem_address;
+
+	get_option(&str, &printk_phys_address);
+	if (!printk_phys_address)
+		return 0;
+
+	/* temporarly map first few pages of log memory */
+	mem_address = early_ioremap(printk_phys_address,  EARLY_LOG_PAGES);
+	if (!mem_address)
+		return 0;
+
+	printk(KERN_INFO "Logging kernel messages into HW memory at %08x\n",
+								printk_phys_address);
+	/* allocate saved log buffer, and save the log memory that we
+	  will otherwise overwrite */
+	old_log_buf = alloc_bootmem(__LOG_BUF_LEN);
+	if (old_log_buf)
+		memcpy(old_log_buf, mem_address, EARLY_LOG_PAGES);
+
+	/* clear log memory now */
+	memset(mem_address, 0, EARLY_LOG_PAGES);
+
+	/* copy current printk buffer to log memory, and switch to new buffer */
+	spin_lock_irqsave(&logbuf_lock, flags);
+	memcpy(mem_address, log_buf, EARLY_LOG_PAGES);
+	log_buf = mem_address;
+	log_buf_len = EARLY_LOG_PAGES;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	return 1;
+}
+__setup("printk_address=", printk_phys_address_setup);
+
+static int printk_phys_address_late(void)
+{
+
+	char *mem_address, *early_mem_address;
+	unsigned long flags;
+	struct dentry *dbgfs_dir;
+
+	if (!printk_phys_address)
+		return 0;
+
+	/* now do late initialization */
+	mem_address = ioremap(printk_phys_address,  __LOG_BUF_LEN);
+
+	if (!mem_address) {
+		printk(KERN_ALERT "Can't fully map hardware kernel log memory."
+			" Log buffer limited to %lu KB\n", EARLY_LOG_PAGES);
+		return  0;
+	}
+
+	/* save the rest of log memory, and publish it */
+	if (old_log_buf) {
+		memcpy(old_log_buf + EARLY_LOG_PAGES,
+			mem_address + EARLY_LOG_PAGES,
+				__LOG_BUF_LEN - EARLY_LOG_PAGES);
+
+		crash_dmesg_wrapper.data = old_log_buf;
+		crash_dmesg_wrapper.size = __LOG_BUF_LEN;
+
+		dbgfs_dir = debugfs_create_dir("printk", NULL);
+
+		if (dbgfs_dir > 0)
+			debugfs_create_blob("crash_dmesg", S_IRUSR, dbgfs_dir,
+				&crash_dmesg_wrapper);
+	}
+
+	/* clear rest of the log memory now */
+	memset(mem_address + EARLY_LOG_PAGES , 0,
+		__LOG_BUF_LEN - EARLY_LOG_PAGES);
+
+
+	/* switch to the full log memory now */
+	spin_lock_irqsave(&logbuf_lock, flags);
+	early_mem_address = log_buf;
+	log_buf = mem_address;
+	log_buf_len = __LOG_BUF_LEN;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	/* free temp mapping of the log memory */
+	early_iounmap(early_mem_address, EARLY_LOG_PAGES);
+	return 1;
+}
+postcore_initcall(printk_phys_address_late);
+#endif
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static unsigned int boot_delay; /* msecs delay after each printk during bootup */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..aa714ce 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -758,6 +758,37 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
 	  what it believes to be lockup conditions.
 
+config HWMEM_PRINTK
+	bool "Log printk message buffer into video ram (DANGEROUS)"
+	depends on DEBUG_KERNEL && PRINTK
+	help
+	  This option allows to place kernel log buffer into pre-defined
+	  area, somewhere in memory space.
+	  It is intended to place this buffer into video ram assuming it
+	  isn't cleared on reboot.
+	  This creates some sort of black box recorder and can be very useful
+	  to debug several problems, especially 'panics' that happen while you
+	  use the X window system.
+
+	  To use, first ensure that you aren't using X, or that you tell video
+	  driver not to use all the video ram
+	  (easy way is to use the 'vesa' X driver)
+
+	  Then, pick an address within the video memory,
+	  (best somewhere in middle), and boot kernel with
+	  printk_address=$ADDRESS
+
+	  If you also select debugfs support, you can easily look at
+	  kernel log of failed boot at:
+	  /sys/kernel/debug/printk/crash_dmesg
+
+	  (Assuming you mounted debugfs on /sys/kernel/debug)
+
+	  Misuse of this option can be DANGEROUS, as it makes kernel write at
+	  arbitary (selected by you) hardware memory range.
+
+	  It is only intended for debbuging, so say 'no' if not sure
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL

--=-2e5zGR+zTsHGvNNgRBPH--

