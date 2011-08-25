Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1HYXF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:05:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29009 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1HYXFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:05:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=JWm/w72vwaFnTPpH8MykfmbT5AE+7MW4aXBAOVq+vvXTMShJ3kalaU0Ci4Wn732n9
	vnSocNpSJKLKnZN69YWag==
Subject: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: RalfJungralfjung-e@gmx.de, Cyrill Gorcunov <gorcunov@openvz.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Aug 2011 17:05:39 -0600
Message-ID: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we reserved 1024 bytes, but that's more space than the IOAPIC
consumes, and it can cause conflicts with nearby devices.  The known
requirement is 68 bytes (sizeof(struct io_apic)), and rounding up to a
power-of-2 gives us 128.

The bug reported below is caused by the following assignments (the IOAPIC
power-on default and the watchdog address recommended in the AMD SP5100
BIOS Developer's Guide):

  IOAPIC[0]        at [mem 0xfec00000-0xfec003ff]
  SP5100 TCO timer at [mem 0xfec000f0-0xfec000f7]

Reported-by: Ralf Jung ralfjung-e@gmx.de
Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638863
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/include/asm/apicdef.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 34595d5..855a18a 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -12,10 +12,11 @@
 #define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
 /*
- * This is the IO-APIC register space as specified
- * by Intel docs:
+ * I/O APICs are accessed indirectly via an index/data pair and an EOI
+ * register.  For example, see sec 13.5.1, "APIC Register Map," in the
+ * Intel ICH10 datasheet and the struct io_apic definition.
  */
-#define IO_APIC_SLOT_SIZE		1024
+#define IO_APIC_SLOT_SIZE		128
 
 #define	APIC_ID		0x20
 

