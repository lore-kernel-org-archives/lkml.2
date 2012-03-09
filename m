Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031486Ab2CITvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:51:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031453Ab2CITvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:25 -0500
Message-Id: <20120309190215.797777665@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Maxim Uvarov <maxim.uvarov@oracle.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 10/68] watchdog: hpwdt: clean up set_memory_x call for 32 bit
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Uvarov <maxim.uvarov@oracle.com>

commit 97d2a10d5804d585ab0b58efbd710948401b886a upstream.

1. address has to be page aligned.
2. set_memory_x uses page size argument, not size.
Bug causes with following commit:
	commit da28179b4e90dda56912ee825c7eaa62fc103797
	Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
	Date:   Mon Nov 7 10:59:00 2011 +0100

     watchdog: hpwdt: Changes to handle NX secure bit in 32bit path

    commit e67d668e147c3b4fec638c9e0ace04319f5ceccd upstream.

    This patch makes use of the set_memory_x() kernel API in order
    to make necessary BIOS calls to source NMIs.

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/hpwdt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -216,7 +216,7 @@ static int __devinit cru_detect(unsigned
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
-	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
+	set_memory_x((unsigned long)bios32_map, 2);
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -235,7 +235,8 @@ static int __devinit cru_detect(unsigned
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
 			if (cru_rom_addr) {
-				set_memory_x((unsigned long)cru_rom_addr, cru_length);
+				set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK,
+					(cru_length + PAGE_SIZE - 1) >> PAGE_SHIFT);
 				retval = 0;
 			}
 		}


