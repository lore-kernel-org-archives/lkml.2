Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1JKRED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:04:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab1JKRD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:03:59 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:09 2011
Message-Id: <20111011165709.379360439@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:17 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [07/38] sparc64: Force the execute bit in OpenFirmwares translation entries.
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "David S. Miller" <davem@davemloft.net>

In the OF 'translations' property, the template TTEs in the mappings
never specify the executable bit.  This is the case even though some
of these mappings are for OF's code segment.

Therefore, we need to force the execute bit on in every mapping.

This problem can only really trigger on Niagara/sun4v machines and the
history behind this is a little complicated.

Previous to sun4v, the sun4u TTE entries lacked a hardware execute
permission bit.  So OF didn't have to ever worry about setting
anything to handle executable pages.  Any valid TTE loaded into the
I-TLB would be respected by the chip.

But sun4v Niagara chips have a real hardware enforced executable bit
in their TTEs.  So it has to be set or else the I-TLB throws an
instruction access exception with type code 6 (protection violation).

We've been extremely fortunate to not get bitten by this in the past.

The best I can tell is that the OF's mappings for it's executable code
were mapped using permanent locked mappings on sun4v in the past.
Therefore, the fact that we didn't have the exec bit set in the OF
translations we would use did not matter in practice.

Thanks to Greg Onufer for helping me track this down.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/mm/init_64.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -511,6 +511,11 @@ static void __init read_obp_translations
 		for (i = 0; i < prom_trans_ents; i++)
 			prom_trans[i].data &= ~0x0003fe0000000000UL;
 	}
+
+	/* Force execute bit on.  */
+	for (i = 0; i < prom_trans_ents; i++)
+		prom_trans[i].data |= (tlb_type == hypervisor ?
+				       _PAGE_EXEC_4V : _PAGE_EXEC_4U);
 }
 
 static void __init hypervisor_tlb_lock(unsigned long vaddr,


