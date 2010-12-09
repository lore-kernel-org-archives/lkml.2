Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0LIU4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:56:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:34991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab0LIU4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:56:48 -0500
Date: Thu, 9 Dec 2010 20:56:30 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <4CFDF785.7010401@kernel.org>
References: <4CFDF785.7010401@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86, ioapic: Avoid writing io_apic id if already correct
Message-ID: <tip-60d79fd99ff3b9c692b260a4d53a203f537c052a@git.kernel.org>
Git-Commit-ID: 60d79fd99ff3b9c692b260a4d53a203f537c052a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:56:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60d79fd99ff3b9c692b260a4d53a203f537c052a
Gitweb:     http://git.kernel.org/tip/60d79fd99ff3b9c692b260a4d53a203f537c052a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 7 Dec 2010 00:59:49 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:05 +0100

x86, ioapic: Avoid writing io_apic id if already correct

For 32bit mptable path, setup_ids_from_mpc() always writes the io_apic
id register, even there is no change needed.

Skip the write, when readout and mptable match.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
LKML-Reference: <4CFDF785.7010401@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/io_apic.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4abf08a..8a02150 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2007,9 +2007,12 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 						= mp_ioapics[apic_id].apicid;
 
 		/*
-		 * Read the right value from the MPC table and
-		 * write it into the ID register.
+		 * Update the ID register according to the right value
+		 * from the MPC table if they are different.
 		 */
+		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
+			continue;
+
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
 			mp_ioapics[apic_id].apicid);
