Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1B1JQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:16:38 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:59324 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1B1JQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:16:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: [PATCH 1/1] WATCHDOG: sbc_fitpc2_wdt, fix crash on systems without DMI_BOARD_NAME
Date: Mon, 28 Feb 2011 10:16:29 +0100
Message-Id: <1298884589-6880-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems don't provide DMI_BOARD_NAME in their DMI tables. Avoid
crash in such situations in fitpc2_wdt_init.

The fix is to check if the dmi_get_system_info return value is NULL.

The oops:
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81253ae6>] strstr+0x26/0xa0
PGD 3966e067 PUD 39605067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 1
Modules linked in: ...
Pid: 1748, comm: modprobe Not tainted 2.6.37-22-default #1 /Bochs
RIP: 0010:[<ffffffff81253ae6>]  [<ffffffff81253ae6>] strstr+0x26/0xa0
RSP: 0018:ffff88003ad73f18  EFLAGS: 00010206
RAX: 0000000000000000 RBX: 00000000ffffffed RCX: 00000000ffffffff
RDX: ffffffffa003f4cc RSI: ffffffffa003f4c2 RDI: 0000000000000000
...
CR2: 0000000000000000 CR3: 000000003b7ac000 CR4: 00000000000006e0
...
Process modprobe (pid: 1748, threadinfo ffff88003ad72000, task ffff88002e6365c0)
Stack: ...
Call Trace:
 [<ffffffffa004201f>] fitpc2_wdt_init+0x1f/0x13c [sbc_fitpc2_wdt]
 [<ffffffff810002da>] do_one_initcall+0x3a/0x170
...
Code: f3 c3 0f 1f 00 80 3e 00 53 48 89 f8 74 1b 48 89 f2 0f 1f 40 00 48 83 c2 01 80 3a 00 75 f7 49 89 d0 48 89 f8 49 29 f0 75 02 5b c3 <80> 3f 00 74 0e 0f 1f 44 00 00 48 83 c0 01 80 38 00 75 f7 49 89

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/sbc_fitpc2_wdt.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index c7d67e9..7990625 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -201,11 +201,14 @@ static struct miscdevice fitpc2_wdt_miscdev = {
 static int __init fitpc2_wdt_init(void)
 {
 	int err;
+	const char *brd_name;
 
-	if (!strstr(dmi_get_system_info(DMI_BOARD_NAME), "SBC-FITPC2"))
+	brd_name = dmi_get_system_info(DMI_BOARD_NAME);
+
+	if (!brd_name || !strstr(brd_name, "SBC-FITPC2"))
 		return -ENODEV;
 
-	pr_info("%s found\n", dmi_get_system_info(DMI_BOARD_NAME));
+	pr_info("%s found\n", brd_name);
 
 	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
 		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);
-- 
1.7.4.1


