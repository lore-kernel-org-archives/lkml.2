Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1B1VkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:40:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1B1VkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AVhrawOt1GDjafGqyCg2ucXP9E6l6S5zqWDyh5AkSJVWPK9G1DqXeiW2oqVa8wp57P
         8Oq6l4RYgfxZ0/bY1K78pUnjiDf3ouaXRCgD77bFCuIqbg1fu1Jrxdw4XpspZ+Cqv9yl
         NxwNmGD/gM74HwRSWtt5cDAM+BE4l2KILKuqA=
Message-ID: <4D6C1640.5030402@openvz.org>
Date: Tue, 01 Mar 2011 00:40:16 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip 2/2] x86, traps: Drop nmi_reason_lock until it is really
 needed
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At moment we have only BSP apic configured to listen
for external NMIs. So there is no reason for additional
spinlock since only BSP will receive them.

Though we have UV chips which do enable external NMIs
on all cpus, but since an approach to allow retrieving
NMI reason on BSP only was worked fine previously --
I assume it still remains valid.

Also it's worth to mention that an initial idea of all this
NMI code-path poking was to make BSP hot-unpluggable but
until all others part of kernel is prepared for it (which
might take quite a time to implement) I believe we should not
lock/unlock for nothing.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
  arch/x86/kernel/traps.c |   16 ++++++----------
  1 file changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/traps.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps.c
+++ linux-2.6.git/arch/x86/kernel/traps.c
@@ -84,11 +84,6 @@ EXPORT_SYMBOL_GPL(used_vectors);
  static int ignore_nmis;

  int unknown_nmi_panic;
-/*
- * Prevent NMI reason port (0x61) being accessed simultaneously, can
- * only be used in NMI handler.
- */
-static DEFINE_RAW_SPINLOCK(nmi_reason_lock);

  static inline void conditional_sti(struct pt_regs *regs)
  {
@@ -406,9 +401,12 @@ static notrace __kprobes void default_do
  	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
  		return;

-	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
-	raw_spin_lock(&nmi_reason_lock);
-	reason = get_nmi_reason();
+	/*
+	 * Only BSP is configured to listen and handle external NMIs.
+	 * Note this implicitly orders a call to the get_nmi_reason.
+	 */
+	if (!smp_processor_id())
+		reason = get_nmi_reason();

  	if (reason & NMI_REASON_MASK) {
  		if (reason & NMI_REASON_SERR)
@@ -422,10 +420,8 @@ static notrace __kprobes void default_do
  		 */
  		reassert_nmi();
  #endif
-		raw_spin_unlock(&nmi_reason_lock);
  		return;
  	}
-	raw_spin_unlock(&nmi_reason_lock);

  	unknown_nmi_error(reason, regs);
  }
-- 
     Cyrill
