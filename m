Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1CBPde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:33:34 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56293 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1CBPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:33:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kEjLXt2GqrjDFfXrfUHtXbXh61xdf1iNIBUk5sh0KqHUXn6d3oUL/QA+OOtg29hS5i
         gjlJbRcioOLmcBa6xFxIquvtx3BapvS7J06EZcuIcSQnInPW+IHbmidtGN8ibJ8oqAvE
         UMqkFz9LxKSbEesr/q067l2TMGG975Ne4a/OE=
Message-ID: <4D6E631B.6040701@openvz.org>
Date: Wed, 02 Mar 2011 18:32:43 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until it
 is really needed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At moment we have only BSP apic configured to listen
for external NMIs. So there is no reason for additional
spinlock since only BSP will receive them.

Though we still have UV chips which do enable external NMIs
on all cpus, but since an approach to allow retrieving
NMI reason on BSP only was working pretty fine before --
I assume it still remains valid.

Also it's worth to mention that an initial idea of all this
NMI code-path changes was to make BSP hot-unpluggable but
until all other parts of kernel is prepared for it (which
might consume quite a time to implement) I believe we should
not lock/unlock for nothing.

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
