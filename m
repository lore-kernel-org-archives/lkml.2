Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1CIVjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:39:13 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:56747 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab1CIVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:39:12 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEKCd01R8s7g/2dsb2JhbACmcHXDfg2FWAQ
Date: Wed, 9 Mar 2011 22:39:09 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [GIT PULL REQUEST] watchdog - v2.6.38-rc8
Message-ID: <20110309213909.GA19608@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/sbc_fitpc2_wdt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

with these Changes:

Author: Jiri Slaby <jslaby@suse.cz>
Date:   Mon Feb 28 10:16:29 2011 +0100

    watchdog: sbc_fitpc2_wdt, fix crash on systems without DMI_BOARD_NAME
    
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
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
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
