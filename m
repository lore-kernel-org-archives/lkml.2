Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab0DVTxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:53:06 -0400
Received: from kroah.org ([198.145.64.141]:40915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0DVT2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:42 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.448262052@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [090/197] x86: hpet: Make WARN_ON understandable
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 18ed61da985c57eea3fe8038b13fa2837c9b3c3f upstream.

Andrew complained rightly that the WARN_ON in hpet_next_event() is
confusing and the code comment not really helpful.

Change it to WARN_ONCE and print the reason in clear text. Change the
comment to explain what kind of hardware wreckage we deal with.

Pointed-out-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -385,11 +385,22 @@ static int hpet_next_event(unsigned long
 	hpet_writel(cnt, HPET_Tn_CMP(timer));
 
 	/*
-	 * We need to read back the CMP register to make sure that
-	 * what we wrote hit the chip before we compare it to the
-	 * counter.
+	 * We need to read back the CMP register on certain HPET
+	 * implementations (ATI chipsets) which seem to delay the
+	 * transfer of the compare register into the internal compare
+	 * logic. With small deltas this might actually be too late as
+	 * the counter could already be higher than the compare value
+	 * at that point and we would wait for the next hpet interrupt
+	 * forever. We found out that reading the CMP register back
+	 * forces the transfer so we can rely on the comparison with
+	 * the counter register below. If the read back from the
+	 * compare register does not match the value we programmed
+	 * then we might have a real hardware problem. We can not do
+	 * much about it here, but at least alert the user/admin with
+	 * a prominent warning.
 	 */
-	WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
+	WARN_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt,
+		  KERN_WARNING "hpet: compare register read back failed.\n");
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }


