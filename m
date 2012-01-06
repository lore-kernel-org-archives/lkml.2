Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2AFHIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 02:08:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27645 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2AFHIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 02:08:13 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-42-4f069ddbc773
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, "'Greg KH'" <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Nicolas Pitre'" <nicolas.pitre@linaro.org>,
        "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Kay Sievers'" <kay.sievers@vrfy.org>
References: <20120106175227.07a7240920f3ccd95c27b9a7@canb.auug.org.au>
In-reply-to: <20120106175227.07a7240920f3ccd95c27b9a7@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the driver-core tree with the arm tree
Date: Fri, 06 Jan 2012 16:08:09 +0900
Message-id: <031201cccc41$f24aa320$d6dfe960$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczMP8jBomzlaIQwTEerEbd3va9wBQAASdqA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-s5pc100/common.c between commit 109ac862f737 ("ARM:
> mach-s5pc100: use standard arch_idle()") from the arm tree and commit
> 4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
> the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-s5pc100/common.c
> index 4659fb9,af52c09..0000000
> --- a/arch/arm/mach-s5pc100/common.c
> +++ b/arch/arm/mach-s5pc100/common.c
> @@@ -194,27 -154,17 +195,27 @@@ static struct device s5pc100_dev =
> 
>   static int __init s5pc100_core_init(void)
>   {
> - 	return sysdev_class_register(&s5pc100_sysclass);
> + 	return subsys_system_register(&s5pc100_subsys, NULL);
>   }
>  -
>   core_initcall(s5pc100_core_init);
> 
>   int __init s5pc100_init(void)
>   {
>   	printk(KERN_INFO "S5PC100: Initializing architecture\n");
> - 	return sysdev_register(&s5pc100_sysdev);
> ++	return device_register(&s5pc100_sys);

Hi Greg,

Should be 'return device_register(&s5pc100_dev);'?

Greg,
Following should be fixed in your driver-core/driver-core-next.
(I informed that but maybe you missed)

diff --git a/arch/arm/mach-s3c2410/pm.c b/arch/arm/mach-s3c2410/pm.c
index 4b948ec..fda5385 100644
--- a/arch/arm/mach-s3c2410/pm.c
+++ b/arch/arm/mach-s3c2410/pm.c
@@ -137,7 +137,7 @@ arch_initcall(s3c2410_pm_drvinit);
 
 static struct subsys_interface s3c2410a_pm_interface = {
 	.name		= "s3c2410a_pm",
-	subsys		= &s3c2410a_subsys,
+	.subsys		= &s3c2410a_subsys,
 	.add_dev	= s3c2410_pm_add,
 };
 
diff --git a/arch/arm/mach-s3c2412/pm.c b/arch/arm/mach-s3c2412/pm.c
index fd7210d..d1adfa6 100644
--- a/arch/arm/mach-s3c2412/pm.c
+++ b/arch/arm/mach-s3c2412/pm.c
@@ -95,7 +95,7 @@ static struct subsys_interface s3c2412_pm_interface = {
 
 static __init int s3c2412_pm_init(void)
 {
-	return subsys_interface_register_register(&s3c2412_pm_interface);
+	return subsys_interface_register(&s3c2412_pm_interface);
 }
 
 arch_initcall(s3c2412_pm_init);
diff --git a/arch/arm/mach-s3c2440/s3c2442.c
b/arch/arm/mach-s3c2440/s3c2442.c
index 9ab15cd..8004e04 100644
--- a/arch/arm/mach-s3c2440/s3c2442.c
+++ b/arch/arm/mach-s3c2440/s3c2442.c
@@ -151,7 +151,7 @@ static int s3c2442_clk_add(struct device *dev)
 static struct subsys_interface s3c2442_clk_interface = {
 	.name		= "s3c2442_clk",
 	.subsys		= &s3c2442_subsys,
-	.add_dev	 s3c2442_clk_add,
+	.add_dev	= s3c2442_clk_add,
 };
 
 static __init int s3c2442_clk_init(void)
diff --git a/arch/arm/mach-s5p64x0/cpu.c b/arch/arm/mach-s5p64x0/cpu.c
index 8b02990..74387a1 100644
--- a/arch/arm/mach-s5p64x0/cpu.c
+++ b/arch/arm/mach-s5p64x0/cpu.c
@@ -195,7 +195,7 @@ struct bus_type s5p64x0_subsys = {
 	.dev_name	= "s5p64x0-core",
 };
 
-static struct device s5p64x0_subsys = {
+static struct device s5p64x0_dev = {
 	.bus	= &s5p64x0_subsys,
 };
 
diff --git a/arch/arm/mach-s5pc100/cpu.c b/arch/arm/mach-s5pc100/cpu.c
index af52c09..330a10b 100644
--- a/arch/arm/mach-s5pc100/cpu.c
+++ b/arch/arm/mach-s5pc100/cpu.c
@@ -166,5 +166,5 @@ int __init s5pc100_init(void)
 	/* set idle function */
 	pm_idle = s5pc100_idle;
 
-	return device_register(&s5pc100_sys);
+	return device_register(&s5pc100_dev);
 }


Thanks.

Best regards,
Kgene.
--j
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

