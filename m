Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1LGQSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329Ab1LGQSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:27 2011
Message-Id: <20111207160827.439290862@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:19 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan McGrath <troubledaemon@gmail.com>,
        Alexey Starikovskiy <aystarik@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [59/80] x86/mpparse: Account for bus types other than ISA and PCI
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 9e6866686bdf2dcf3aeb0838076237ede532dcc8 upstream.

In commit f8924e770e04 ("x86: unify mp_bus_info"), the 32-bit
and 64-bit versions of MP_bus_info were rearranged to match each
other better.  Unfortunately it introduced a regression: prior
to that change we used to always set the mp_bus_not_pci bit,
then clear it if we found a PCI bus.  After it, we set
mp_bus_not_pci for ISA buses, clear it for PCI buses, and leave
it alone otherwise.

In the cases of ISA and PCI, there's not much difference.  But
ISA is not the only non-PCI bus, so it's better to always set
mp_bus_not_pci and clear it only for PCI.

Without this change, Dan's Dell PowerEdge 4200 panics on boot
with a log indicating interrupt routing trouble unless the
"noapic" option is supplied.  With this change, the machine
boots reliably without "noapic".

Fixes http://bugs.debian.org/586494

Reported-bisected-and-tested-by: Dan McGrath <troubledaemon@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dan McGrath <troubledaemon@gmail.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>
[jrnieder@gmail.com: clarified commit message]
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Link: http://lkml.kernel.org/r/20111122215000.GA9151@elie.hsd1.il.comcast.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/mpparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mp
 	}
 #endif
 
+	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif


