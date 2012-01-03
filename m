Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2ACWlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab2ACWk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:40:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:24 2012
Message-Id: <20120103223324.882635550@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [46/75] watchdog: hpwdt: Changes to handle NX secure bit in 32bit path
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -230,6 +230,7 @@ static int __devinit cru_detect(unsigned
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
+	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -247,8 +248,10 @@ static int __devinit cru_detect(unsigned
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


