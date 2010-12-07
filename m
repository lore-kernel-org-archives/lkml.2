Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0LGJBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:01:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23868 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab0LGJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:01:03 -0500
Message-ID: <4CFDF785.7010401@kernel.org>
Date: Tue, 07 Dec 2010 00:59:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, bigeasy@linutronix.de
Subject: [PATCH -v2] x86, ioapic: Don't write io_apic ID if it is not changed
References: <20101126165020.GA26361@www.tglx.de> <tip-a38c5380ef9f088be9f49b6e4c5d80af8b1b5cd4@git.kernel.org>
In-Reply-To: <tip-a38c5380ef9f088be9f49b6e4c5d80af8b1b5cd4@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For 32bit mptable path, setup_ids_from_mpc() always write io apic id
register, even there is no change needed.

So try to do that when they are different bewteen reading out and mptable

-v2: update to recent setup_ioapic_ids_from_mpc() split..

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2006,9 +2006,12 @@ void __init setup_ioapic_ids_from_mpc_no
 						= mp_ioapics[apic_id].apicid;
 
 		/*
-		 * Read the right value from the MPC table and
-		 * write it into the ID register.
+		 * Update the ID register according to the right value from
+		 *  the MPC table if they are different.
 		 */
+		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
+			continue;
+
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
 			mp_ioapics[apic_id].apicid);
