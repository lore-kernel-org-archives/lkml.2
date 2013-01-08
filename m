Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3AHXw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:52:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53644 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3AHXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Dan McGrath <troubledaemon@gmail.com>,
        Alexey Starikovskiy <aystarik@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 39/77] x86/mpparse: Account for bus types other than ISA and PCI
Date: Tue, 8 Jan 2013 18:35:18 -0500
Message-ID: <1357688156-25387-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/mpparse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index e81030f..d60fa2b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -94,8 +94,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	}
 #endif
 
+	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
-- 
1.7.12.1

