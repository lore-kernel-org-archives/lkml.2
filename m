Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2C1NMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:12:53 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36548
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878Ab2C1NMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:12:51 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1LJD7-01-60L-02
X-M-MSG: 
Date: Wed, 28 Mar 2012 15:12:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, amd: Be more verbose about LVT offset assignments
Message-ID: <20120328131240.GB16533@erda.amd.com>
References: <1332876615-29219-1-git-send-email-robert.richter@amd.com>
 <20120328114944.GB17936@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120328114944.GB17936@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.03.12 13:49:45, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Add information about LVT offset assignments to better debug 
> > firmware bug messages related to this.
> 
> Which particular bug message(s) is this related to, can you 
> quote an example perhaps?

Yeah, should have put it into the commit message. Updated patch below.

-Robert


>From efb205d18ba569a058555283c4a66d736118ca6d Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 27 Mar 2012 20:04:02 +0200
Subject: [PATCH] x86, amd: Be more verbose about LVT offset assignments

Add information about LVT offset assignments to better debug firmware
bugs related to this. See following examples.

 # dmesg | grep -i 'offset\|ibs'
 LVT offset 0 assigned for vector 0xf9
 [Firmware Bug]: cpu 0, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
 [Firmware Bug]: cpu 0, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
 Failed to setup IBS, -22

In this case the BIOS assigns both offsets for MCE (0xf9) and IBS
(0x400) vectors to offset 0, which is why the second APIC setup (IBS)
failed.

With correct setup you get:

 # dmesg | grep -i 'offset\|ibs'
 LVT offset 0 assigned for vector 0xf9
 LVT offset 1 assigned for vector 0x400
 IBS: LVT offset 1 assigned
 perf: AMD IBS detected (0x00000007)
 oprofile: AMD IBS detected (0x00000007)

Note: The vector includes also the message type to handle also NMIs
(0x400). In the firmware bug message the format is the same as of the
APIC500 register and includes the mask bit (bit 16) in addition.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic/apic.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2eec05b..11544d8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -383,20 +383,25 @@ static inline int eilvt_entry_is_changeable(unsigned int old, unsigned int new)
 
 static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
 {
-	unsigned int rsvd;			/* 0: uninitialized */
+	unsigned int rsvd, vector;
 
 	if (offset >= APIC_EILVT_NR_MAX)
 		return ~0;
 
-	rsvd = atomic_read(&eilvt_offsets[offset]) & ~APIC_EILVT_MASKED;
+	rsvd = atomic_read(&eilvt_offsets[offset]);
 	do {
-		if (rsvd &&
-		    !eilvt_entry_is_changeable(rsvd, new))
+		vector = rsvd & ~APIC_EILVT_MASKED;	/* 0: unassigned */
+		if (vector && !eilvt_entry_is_changeable(vector, new))
 			/* may not change if vectors are different */
 			return rsvd;
 		rsvd = atomic_cmpxchg(&eilvt_offsets[offset], rsvd, new);
 	} while (rsvd != new);
 
+	rsvd &= ~APIC_EILVT_MASKED;
+	if (rsvd && rsvd != vector)
+		pr_info("LVT offset %d assigned for vector 0x%02x\n",
+			offset, rsvd);
+
 	return new;
 }
 
-- 
1.7.8.4


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

