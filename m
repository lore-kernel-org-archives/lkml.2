Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1BEOXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:23:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1BEOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sRLKz57AMRY848qY3m3rjXYZ2rNGBC0glCqM86zBQKaN3+6hSCzjI/jiMwAF7CtSy4
         2siFibt4wSf54wMivXzmTga3F7d7VEWwxZK2a9I2ubMhzmJtPJZzYiJbZ8uenUTMo+wC
         99t4DsbSTkC0AjaW8qTfxoRv7h4IUTw+DfpwU=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 45/52] kstrtox: convert arm
Date: Sat,  5 Feb 2011 16:20:48 +0200
Message-Id: <1296915654-7458-45-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/arm/mach-omap2/board-omap3touchbook.c:
remove "tbr" parameter, it's unused.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/arm/mach-omap2/board-omap3touchbook.c |   11 -----------
 arch/arm/mach-omap2/mux.c                  |   15 ++++++---------
 arch/arm/mach-pxa/balloon3.c               |    2 +-
 arch/arm/mach-pxa/viper.c                  |    3 +--
 arch/arm/mach-s3c2412/mach-jive.c          |    2 +-
 arch/arm/mach-ux500/mbox-db5500.c          |   27 ++++++++-------------------
 arch/arm/mach-w90x900/cpu.c                |    5 +++--
 arch/arm/plat-omap/mcbsp.c                 |    4 ++--
 8 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index db1f74f..16f334f 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -62,8 +62,6 @@
 #define TB_BL_PWM_TIMER		9
 #define TB_KILL_POWER_GPIO	168
 
-static unsigned long touchbook_revision;
-
 static struct mtd_partition omap3touchbook_nand_partitions[] = {
 	/* All the partition sizes are listed in terms of NAND block size */
 	{
@@ -493,15 +491,6 @@ static void omap3_touchbook_poweroff(void)
 	gpio_direction_output(TB_KILL_POWER_GPIO, 0);
 }
 
-static int __init early_touchbook_revision(char *p)
-{
-	if (!p)
-		return 0;
-
-	return strict_strtoul(p, 10, &touchbook_revision);
-}
-early_param("tbr", early_touchbook_revision);
-
 static struct omap_musb_board_data musb_board_data = {
 	.interface_type		= MUSB_INTERFACE_ULPI,
 	.mode			= MUSB_OTG,
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index fae49d1..ab5087a 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -548,7 +548,7 @@ static ssize_t omap_mux_dbg_signal_write(struct file *file,
 	char buf[OMAP_MUX_MAX_ARG_CHAR];
 	struct seq_file *seqf;
 	struct omap_mux *m;
-	unsigned long val;
+	u16 val;
 	int buf_size, ret;
 	struct omap_mux_partition *partition;
 
@@ -561,13 +561,10 @@ static ssize_t omap_mux_dbg_signal_write(struct file *file,
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
-	ret = strict_strtoul(buf, 0x10, &val);
+	ret = kstrtou16(buf, 0x10, &val);
 	if (ret < 0)
 		return ret;
 
-	if (val > 0xffff)
-		return -EINVAL;
-
 	seqf = file->private_data;
 	m = seqf->private;
 
@@ -575,7 +572,7 @@ static ssize_t omap_mux_dbg_signal_write(struct file *file,
 	if (!partition)
 		return -ENODEV;
 
-	omap_mux_write(partition, (u16)val, m->reg_offset);
+	omap_mux_write(partition, val, m->reg_offset);
 	*ppos += count;
 
 	return count;
@@ -770,18 +767,18 @@ static void __init omap_mux_set_cmdline_signals(void)
 
 	while ((token = strsep(&next_opt, ",")) != NULL) {
 		char *keyval, *name;
-		unsigned long val;
 
 		keyval = token;
 		name = strsep(&keyval, "=");
 		if (name) {
+			u16 val;
 			int res;
 
-			res = strict_strtoul(keyval, 0x10, &val);
+			res = kstrtou16(keyval, 0x10, &val);
 			if (res < 0)
 				continue;
 
-			omap_mux_init_signal(name, (u16)val);
+			omap_mux_init_signal(name, val);
 		}
 	}
 
diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index a134a14..077fdc0 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -91,7 +91,7 @@ int __init parse_balloon3_features(char *arg)
 	if (!arg)
 		return 0;
 
-	return strict_strtoul(arg, 0, &balloon3_features_present);
+	return kstrtoul(arg, 0, &balloon3_features_present);
 }
 early_param("balloon3_features", parse_balloon3_features);
 
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 49eeeab..bed35b8 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -767,8 +767,7 @@ static unsigned long viper_tpm;
 
 static int __init viper_tpm_setup(char *str)
 {
-	strict_strtoul(str, 10, &viper_tpm);
-	return 1;
+	return !kstrtoul(str, 10, &viper_tpm);
 }
 
 __setup("tpm=", viper_tpm_setup);
diff --git a/arch/arm/mach-s3c2412/mach-jive.c b/arch/arm/mach-s3c2412/mach-jive.c
index 923e01b..a21b119 100644
--- a/arch/arm/mach-s3c2412/mach-jive.c
+++ b/arch/arm/mach-s3c2412/mach-jive.c
@@ -240,7 +240,7 @@ static int __init jive_mtdset(char *options)
 	if (options == NULL || options[0] == '\0')
 		return 0;
 
-	if (strict_strtoul(options, 10, &set)) {
+	if (kstrtoul(options, 10, &set)) {
 		printk(KERN_ERR "failed to parse mtdset=%s\n", options);
 		return 0;
 	}
diff --git a/arch/arm/mach-ux500/mbox-db5500.c b/arch/arm/mach-ux500/mbox-db5500.c
index cbf1571..9c7b832 100644
--- a/arch/arm/mach-ux500/mbox-db5500.c
+++ b/arch/arm/mach-ux500/mbox-db5500.c
@@ -122,29 +122,18 @@ static ssize_t mbox_write_fifo(struct device *dev,
 			       const char *buf,
 			       size_t count)
 {
-	unsigned long mbox_mess;
-	unsigned long nbr_sends;
-	unsigned long i;
-	char int_buf[16];
-	char *token;
-	char *val;
-
 	struct mbox *mbox = (struct mbox *) dev->platform_data;
+	unsigned int mbox_mess, nbr_sends;
+	unsigned int i;
 
-	strncpy((char *) &int_buf, buf, sizeof(int_buf));
-	token = (char *) &int_buf;
-
-	/* Parse message */
-	val = strsep(&token, " ");
-	if ((val == NULL) || (strict_strtoul(val, 16, &mbox_mess) != 0))
-		mbox_mess = 0xDEADBEEF;
-
-	val = strsep(&token, " ");
-	if ((val == NULL) || (strict_strtoul(val, 10, &nbr_sends) != 0))
+	if (sscanf(buf, "%u %u", &mbox_mess, &nbr_sends) != 2) {
 		nbr_sends = 1;
+		if (sscanf(buf, "%u", &mbox_mess) != 1)
+			return -EINVAL;
+	}
 
-	dev_dbg(dev, "Will write 0x%lX %ld times using data struct at 0x%X\n",
-		mbox_mess, nbr_sends, (u32) mbox);
+	dev_dbg(dev, "Will write 0x%X %u times using data struct at %p\n",
+		mbox_mess, nbr_sends, mbox);
 
 	for (i = 0; i < nbr_sends; i++)
 		mbox_send(mbox, mbox_mess, true);
diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 83c5632..67f015c 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -170,12 +170,13 @@ static int __init nuc900_set_clkval(unsigned int cpufreq)
 }
 static int __init nuc900_set_cpufreq(char *str)
 {
-	unsigned long cpufreq, val;
+	unsigned int cpufreq, val;
 
 	if (!*str)
 		return 0;
 
-	strict_strtoul(str, 0, &cpufreq);
+	if (kstrtouint(str, 0, &cpufreq) < 0)
+		return 0;
 
 	nuc900_clock_source(NULL, "ext");
 
diff --git a/arch/arm/plat-omap/mcbsp.c b/arch/arm/plat-omap/mcbsp.c
index b5a6e17..09e4015 100644
--- a/arch/arm/plat-omap/mcbsp.c
+++ b/arch/arm/plat-omap/mcbsp.c
@@ -1485,10 +1485,10 @@ static ssize_t prop##_store(struct device *dev,				\
 				const char *buf, size_t size)		\
 {									\
 	struct omap_mcbsp *mcbsp = dev_get_drvdata(dev);		\
-	unsigned long val;						\
+	u16 val;							\
 	int status;							\
 									\
-	status = strict_strtoul(buf, 0, &val);				\
+	status = kstrtou16(buf, 0, &val);				\
 	if (status)							\
 		return status;						\
 									\
-- 
1.7.3.4

