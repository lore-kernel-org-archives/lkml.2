Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1LERfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:35:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1LERfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:35:32 -0500
Date: Mon, 5 Dec 2011 09:35:08 -0800
From: tip-bot for Bjorn Helgaas <bhelgaas@google.com>
Message-ID: <tip-9e6866686bdf2dcf3aeb0838076237ede532dcc8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, troubledaemon@gmail.com, hpa@zytor.com,
        mingo@redhat.com, aystarik@gmail.com, bhelgaas@google.com,
        jrnieder@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, troubledaemon@gmail.com,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, jrnieder@gmail.com,
        tglx@linutronix.de, aystarik@gmail.com, mingo@elte.hu
In-Reply-To: <20111122215000.GA9151@elie.hsd1.il.comcast.net>
References: <20111122215000.GA9151@elie.hsd1.il.comcast.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mpparse: Account for bus types other than ISA and PCI
Git-Commit-ID: 9e6866686bdf2dcf3aeb0838076237ede532dcc8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:35:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e6866686bdf2dcf3aeb0838076237ede532dcc8
Gitweb:     http://git.kernel.org/tip/9e6866686bdf2dcf3aeb0838076237ede532dcc8
Author:     Bjorn Helgaas <bhelgaas@google.com>
AuthorDate: Sun, 25 Sep 2011 15:29:00 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 13:46:27 +0100

x86/mpparse: Account for bus types other than ISA and PCI

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
Cc: stable@vger.kernel.org	# 2.6.26+
Cc: Dan McGrath <troubledaemon@gmail.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>
[jrnieder@gmail.com: clarified commit message]
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Link: http://lkml.kernel.org/r/20111122215000.GA9151@elie.hsd1.il.comcast.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9103b89..0741b062 100644
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
