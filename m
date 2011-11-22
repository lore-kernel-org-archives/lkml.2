Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab1KVVuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:50:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49146 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1KVVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:50:09 -0500
Date: Tue, 22 Nov 2011 15:50:01 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Dan McGrath <troubledaemon@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@elte.hu>,
        Alexey Starikovskiy <aystarik@gmail.com>
Subject: [PATCH] x86: mpparse: account for bus types other than ISA and PCI
Message-ID: <20111122215000.GA9151@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 25 Sep 2011 15:29:00 -0600

In commit f8924e770e04 ("x86: unify mp_bus_info"), the 32-bit and
64-bit versions of MP_bus_info were rearranged to match each other
better.  Unfortunately it introduced a regression: prior to that
change we used to always set the mp_bus_not_pci bit, then clear it if
we found a PCI bus.  After it, we set mp_bus_not_pci for ISA buses,
clear it for PCI buses, and leave it alone otherwise.

In the cases of ISA and PCI, there's not much difference.  But ISA is
not the only non-PCI bus, so it's better to always set mp_bus_not_pci
and clear it only for PCI.

Without this change, Dan's Dell PowerEdge 4200 panics on boot with a
log indicating interrupt routing trouble unless the "noapic" option is
supplied.  With this change, the machine boots reliably without
"noapic".

Fixes http://bugs.debian.org/586494

Reported-bisected-and-tested-by: Dan McGrath <troubledaemon@gmail.com>
Cc: stable@vger.kernel.org	# 2.6.26+
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[jrnieder@gmail.com: clarified commit message]
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi,

Fix for an old regression.  Not present in linux-next, so seems to
have been forgotten.  The patch visited LKML a few times --- I suppose
it was not a great time for getting patches in. :)

References:

 - 2011-09-25: debugging session [1]
 - 2011-09-25: first official appearance [2]
   2011-10-17: ping.  Ingo writes:
    "Please resend - this is one of the mails that got lost in my korg
    email disconnect.

    Patch looks good at first sight."
 - 2011-10-18: resent [3]
   2011-10-31: ping
 - 2011-11-08: resent [4]
   2011-11-14: plaintive ping
 - 2011-11-21: resent [5]

[1] http://thread.gmane.org/gmane.linux.kernel/1194982/focus=1195043
[2] http://thread.gmane.org/gmane.linux.kernel/1195093
[3] http://thread.gmane.org/gmane.linux.kernel/1204831
[4] http://thread.gmane.org/gmane.linux.kernel/1212763
[5] http://thread.gmane.org/gmane.linux.kernel/1218323

 arch/x86/kernel/mpparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9103b89c145a..0741b062a304 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	}
 #endif
 
+	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
-- 
1.7.8.rc3

