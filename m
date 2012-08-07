Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2HGVod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 17:44:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40957 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2HGVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 17:44:32 -0400
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Sealey <matt@genesi-usa.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] ARM: print an early warning if the ATAG_CORE/OF_DT_MAGIC vet did not pass
Date: Tue,  7 Aug 2012 16:44:23 -0500
Message-Id: <1344375863-29947-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting and passing either corrupted or missing device trees or ATAGs,
the __vet_atags function in kernel/head-common.S will set r2 to 0, thus
causing what might be seen as strange behavior.

What happens is setup_machine_fdt is passed __atags_pointer which is NULL
in the above situation, and it will immediately exit with NULL return
value for the machine_desc. On NULL machine_desc, the implication is that
it was not a device tree, and it falls back to setup_machine_tags. This
function will also return NULL, and the list of supported boards will be
printed out. Only much, much later in the kernel is any message reporting
lack of ATAG_CORE or any other indicator present since they all rely on
there being a valid pointer to get to them.

The following situations where this may happen are suggested:

1) Modification of the device tree blob is performed in the bootloader,
and the tree is being corrupted for some reason.
2) Something is overwriting the device tree magic (kernel decompression,
perhaps) which is possibly more common.
3) Something is overwriting the ATAG_CORE magic (as above)
4) DTB address passed to bootloader is invalid
5) Bootloader actually does boot setting r2 to 0 which either means it
is ridiculously old or horrifically broken.

Several reads of Documentation/arm/Booting lead me to believe that passing
tags in r2 is OPTIONAL, HIGHLY RECOMMENDED for old bootloaders, and
MANDATORY for new bootloaders. The kernel can't tell which is in use, so 0
might actually be valid. However, later it says that a bootloader must
(lowercase) set r2 to "physical address of tagged list in system RAM, or
physical address of device tree block (dtb) in system RAM." So it is not
possible to define a behavior or print a definitive warning, and since we
cannot fix these problems in the kernel we can at least provide more
information about their occurrence at runtime rather than getting to the point
where it seems something even more strange has happened. The pointer is lost
at this point, though, so all we can do is report the event.

Therefore, print a warning at the earliest opportunity to catch the r2=0
case and reduce frustration with developers attempting to port to device
tree or port new bootloaders, hopefully without worrying people with old
bootloaders complying with the existing documentation.

Of course since this is very early in boot, DEBUG_LL needs to be enabled
and a valid UART for the booting board needs to be configured for it to
show any result, but this is true of all the above warnings anyway,
otherwise all you get is Starting Kernel.... and a blinking terminal prompt.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
Tested-by: Steev Klimaszewski <steev@genesi-usa.com>
---
 arch/arm/kernel/setup.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index a81dcec..f788d44 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -942,6 +942,18 @@ void __init setup_arch(char **cmdline_p)
 	struct machine_desc *mdesc;
 
 	setup_processor();
+
+	if (__atags_pointer == 0L) {
+		early_print(
+			"Warning: ATAG_CORE/OF_DT_MAGIC pass failed or __atags_pointer NULL\n"
+			" Either r2 was NULL or __vet_atags set r2 to NULL on boot. This can be because\n"
+			" the bootloader is broken, the ATAGs or Device Tree have been overwritten by\n"
+			" other data during the boot process, the wrong address was supplied for the\n"
+			" Device Tree blob, or NULL was explicitly passed for some reason. Please check\n"
+			" into the situation as it is not usual to be able to boot a board with no ATAGs\n"
+			" or Device Tree.\n");
+	}
+
 	mdesc = setup_machine_fdt(__atags_pointer);
 	if (!mdesc)
 		mdesc = setup_machine_tags(machine_arch_type);
-- 
1.7.9.5

