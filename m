Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1HNK5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:57:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48929 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1HNK5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:57:18 -0400
MIME-Version: 1.0
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 14 Aug 2011 16:26:34 +0530
X-Google-Sender-Auth: ZULRT7B9Rz5rio6K1BA9yAk50ZA
Message-ID: <CAH+eYFD61keboBWfcnxEAwW-4PmoLpofZh08k606OkALg_VFuQ@mail.gmail.com>
Subject: IS_ENABLED() and non-available symbols
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to use the new IS_ENABLED() stuff, but it appears that it
only works if the symbol being tested has its dependencies met, and
results in compiler errors if that is not the case.

For example, I've added code using IS_ENABLED(CONFIG_THUMB2_KERNEL) as
in the below patch.  My config is arch/arm/configs/omap2plus_defconfig
which doesn't satisfy the dependencies for CONFIG_THUMB2_KERNEL (defined
in arch/arm/Kconfig).

Compiling results in the following errors (and indeed the macro hasn't
been generated in include/generated/autoconfg.h).  If I modify my config
to satisfy the dependencies for CONFIG_THUMB2_KERNEL so that it is
selectable, the __enabled_CONFIG_THUMB2_KERNEL macro gets generated.

arch/arm/kernel/setup.c: In function 'c_show':
arch/arm/kernel/setup.c:1056: error: '__enabled_CONFIG_THUMB2_KERNEL'
undeclared (first use in this function)
arch/arm/kernel/setup.c:1056: error: (Each undeclared identifier is
reported only once
arch/arm/kernel/setup.c:1056: error: for each function it appears in.)
arch/arm/kernel/setup.c:1056: error:
'__enabled_CONFIG_THUMB2_KERNEL_MODULE' undeclared (first use in this
function)

Kernel is latest linus (v3.1-rc1-272-g73e0881).

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 70bca64..59aa480 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1053,6 +1053,9 @@ static int c_show(struct seq_file *m, void *v)
        seq_printf(m, "Serial\t\t: %08x%08x\n",
                   system_serial_high, system_serial_low);

+       if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
+               printk("Thumb-2\n");
+
        return 0;
 }
