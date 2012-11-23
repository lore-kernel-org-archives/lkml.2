Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2KWDpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:45:30 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:44700 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab2KWDp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:45:27 -0500
From: Barry Song <Barry.Song@csr.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <workgroup.linux@csr.com>,
        Barry Song <Barry.Song@csr.com>
Subject: [RFC][PATCH] printk: add boot_quiet param to support deferred printk while booting
Date: Fri, 23 Nov 2012 10:50:22 +0800
Message-ID: <1353639022-13273-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"quiet" boot param can make system boot faster without printk time.
but many embedded systems want default loglevel as a always online
diganostic, and it stills want a fast boot procedure without losing
printk.

for example, for rearview and some other urgent scenerios, we want
kernel boot more quickly without printk so that the vedio driver
begins work earlier to show rearview image.

another example, embedded systems using hibernation as a fast boot
way will begin restore snapshot image earlier as we don't have
printk time before the storage like sd/nand begins working.

this patch makes the boot printk been dumped only either we get
an urgent message(loglevel<4) or system state becomes RUNNING.

Tested on SiRFprimaII, boot log without boot_quiet:
Starting kernel ...
...
[    0.782970] sirfsoc_i2c b00e0000.i2c:  I2C adapter ready to operate
[    0.788861] sirfsoc_i2c b00f0000.i2c:  I2C adapter ready to operate
[    0.795006] cpuidle: using governor ladder
[    0.798703] cpuidle: using governor menu
[    0.802848] sdhci: Secure Digital Host Controller Interface driver
[    0.808769] sdhci: Copyright(c) Pierre Ossman
[    0.860817] mmc0: SDHCI controller on 56000000.sdhci [56000000.sdhci] using DMA
[    0.865492] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.871614] TCP: cubic registered
[    0.874253] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 2
[    0.887860] Freeing init memory: 856K
...

boot log with quiet_boot, you will see all printk is moved ahead and
kernel boot with only a half time of the first time:

Starting kernel ...
...
[    0.363188] sirfsoc_i2c b00e0000.i2c:  I2C adapter ready to operate
[    0.363682] sirfsoc_i2c b00f0000.i2c:  I2C adapter ready to operate
[    0.364010] cpuidle: using governor ladder
[    0.364021] cpuidle: using governor menu
[    0.364162] sdhci: Secure Digital Host Controller Interface driver
[    0.364170] sdhci: Copyright(c) Pierre Ossman
[    0.410932] mmc0: SDHCI controller on 56000000.sdhci [56000000.sdhci] using DMA
[    0.411180] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.411871] TCP: cubic registered
[    0.411926] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 2
[    0.417897] Freeing init memory: 856K
...

Signed-off-by: Barry Song <Barry.Song@csr.com>
---
 Note: This is only a RFC, after we agree about the idea, i will move
 the boot_log_buf to __initdata.

 Documentation/kernel-parameters.txt |    4 ++++
 kernel/printk.c                     |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..d6060eb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2383,6 +2383,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	quiet		[KNL] Disable most log messages
 
+	boot_quiet	[KNL] Defer boot log messages to the moment either
+			we get a high level message or system state becomes
+			running.
+
 	r128=		[HW,DRM]
 
 	raid=		[HW,RAID]
diff --git a/kernel/printk.c b/kernel/printk.c
index 2d607f4..0b88d6bf 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -250,6 +250,9 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+static char __boot_log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
+static int boot_log_len;
+
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -1247,6 +1250,16 @@ module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
 	"print all kernel messages to the console.");
 
+static bool boot_quiet = false;
+
+static int __init boot_quiet_kernel(char *str)
+{
+        boot_quiet = true;
+        return 0;
+}
+
+early_param("boot_quiet", boot_quiet_kernel);
+
 /*
  * Call the console drivers, asking them to write out
  * log_buf[start] to log_buf[end - 1].
@@ -1258,6 +1271,20 @@ static void call_console_drivers(int level, const char *text, size_t len)
 
 	trace_console(text, 0, len, len);
 
+	/*
+	 * if users require boot_quiet feature, we don't write console
+	 * until we get a non-quiet message or system state becomes
+	 * running
+	 */
+	if (boot_quiet && (system_state == SYSTEM_BOOTING) &&
+		(level >= 4) && (level < console_loglevel)) {
+		if (len + boot_log_len > __LOG_BUF_LEN)
+			len = __LOG_BUF_LEN - boot_log_len;
+		memcpy(__boot_log_buf + boot_log_len, text, len);
+		boot_log_len += len;
+		return;
+	}
+
 	if (level >= console_loglevel && !ignore_loglevel)
 		return;
 	if (!console_drivers)
@@ -1273,6 +1300,10 @@ static void call_console_drivers(int level, const char *text, size_t len)
 		if (!cpu_online(smp_processor_id()) &&
 		    !(con->flags & CON_ANYTIME))
 			continue;
+		if (unlikely(boot_log_len)) {
+			con->write(con, __boot_log_buf, boot_log_len);
+			boot_log_len = 0;
+		}
 		con->write(con, text, len);
 	}
 }
-- 
1.7.5.4



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
