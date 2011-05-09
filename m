Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1EICkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:40:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51343 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1EICkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:40:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EVdXaIcEUgZ/e7KrEgfYsQVcV+k9ssbQxNGUyMvKMPuuaNplGbaWq5v1ugSabsmSw0
         mc2XD99/KXLBBNVsB50Xh8CSzzZjibxlYPsjYM11zvhaRkEKNvQptc4TlWPPNH0Apso6
         ji0fvqF9aandiq3+MTjwisISIPc3d03kBBDik=
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] ioapic: fix potential resume deadlock
Date: Mon,  9 May 2011 10:40:14 +0800
Message-Id: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a potential deadlock when resuming; here the calling function
has disabled interrupts, so we cannot sleep.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 45fd33d..df63620 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapic_entries(void)
 	struct IO_APIC_route_entry **ioapic_entries;
 
 	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_KERNEL);
+				GFP_ATOMIC);
 	if (!ioapic_entries)
 		return 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		ioapic_entries[apic] =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_KERNEL);
+				nr_ioapic_registers[apic], GFP_ATOMIC);
 		if (!ioapic_entries[apic])
 			goto nomem;
 	}
-- 
1.7.4.1

