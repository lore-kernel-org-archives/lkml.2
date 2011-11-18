Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab1KSAIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660Ab1KSAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:05 2011
Message-Id: <20111119000005.298282565@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [15/26] sfi: table irq 0xFF means no interrupt
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit a94cc4e6c0a26a7c8f79a432ab2c89534aa674d5 upstream.

According to the SFI specification irq number 0xFF means device has no
interrupt or interrupt attached via GPIO.

Currently, we don't handle this special case and set irq field in
*_board_info structs to 255.  It leads to confusion in some drivers.
Accelerometer driver tries to register interrupt 255, fails and prints
"Cannot get IRQ" to dmesg.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/platform/mrst/mrst.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -689,7 +689,9 @@ static int __init sfi_parse_devs(struct
 			irq_attr.trigger = 1;
 			irq_attr.polarity = 1;
 			io_apic_set_pci_routing(NULL, pentry->irq, &irq_attr);
-		}
+		} else
+			pentry->irq = 0; /* No irq */
+
 		switch (pentry->type) {
 		case SFI_DEV_TYPE_IPC:
 			/* ID as IRQ is a hack that will go away */


