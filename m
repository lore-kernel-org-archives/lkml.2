Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2ACWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab2ACWgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223034.552493482@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [38/67] watchdog: hpwdt: Changes to handle NX secure bit in 32bit path
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>

commit e67d668e147c3b4fec638c9e0ace04319f5ceccd upstream.

This patch makes use of the set_memory_x() kernel API in order
to make necessary BIOS calls to source NMIs.

This is needed for SLES11 SP2 and the latest upstream kernel as it appears
the NX Execute Disable has grown in its control.

Signed-off by: Thomas Mingarelli <thomas.mingarelli@hp.com>
Signed-off by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/hpwdt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -216,6 +216,7 @@ static int __devinit cru_detect(unsigned
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
+	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -233,8 +234,10 @@ static int __devinit cru_detect(unsigned
 		if ((physical_bios_base + physical_bios_offset)) {
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
-			if (cru_rom_addr)
+			if (cru_rom_addr) {
+				set_memory_x((unsigned long)cru_rom_addr, cru_length);
 				retval = 0;
+			}
 		}
 
 		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",


