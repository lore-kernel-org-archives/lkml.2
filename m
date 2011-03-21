Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1CUXvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:51:31 -0400
Received: from kroah.org ([198.145.64.141]:49277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1CUXPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:11 2011
Message-Id: <20110321230711.235464079@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [20/87] x86: Dont check for BIOS corruption in first 64K when theres no need to
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

commit a7bd1dafdcc13ec7add4aafc927eb5e3a8d597e6 upstream.

Due to commit 781c5a67f152c17c3e4a9ed9647f8c0be6ea5ae9 it is
likely that the number of areas to scan for BIOS corruption is 0
 -- especially when the first 64K is already reserved
(X86_RESERVE_LOW is 64K by default).

If that's the case then don't set up the scan.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
LKML-Reference: <20110225202838.2229.71011.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/check.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -106,8 +106,8 @@ void __init setup_bios_corruption_check(
 		addr += size;
 	}
 
-	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
-	       num_scan_areas);
+	if (num_scan_areas)
+		printk(KERN_INFO "Scanning %d areas for low memory corruption\n", num_scan_areas);
 }
 
 
@@ -143,12 +143,12 @@ static void check_corruption(struct work
 {
 	check_for_bios_corruption();
 	schedule_delayed_work(&bios_check_work,
-		round_jiffies_relative(corruption_check_period*HZ)); 
+		round_jiffies_relative(corruption_check_period*HZ));
 }
 
 static int start_periodic_check_for_corruption(void)
 {
-	if (!memory_corruption_check || corruption_check_period == 0)
+	if (!num_scan_areas || !memory_corruption_check || corruption_check_period == 0)
 		return 0;
 
 	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",


