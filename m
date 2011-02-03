Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1BCPHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:07:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45756 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1BCPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=pAMnsoeqbvuj1skRX25YZUQBBHQ132ubp0yTARF9Lh/86t0pbOHWew1OJ3Kn0kWBBs
         +vdhSjhq6G1+A0K0XpFpqpy97w/i0jj3qNrFamhujjVbVId++dC4Mkt4wIAFQVkEUalr
         9gU7Y47JR6fYuupNhebuLqFyI/iqztVz3AfH8=
MIME-Version: 1.0
Date: Thu, 3 Feb 2011 23:07:11 +0800
Message-ID: <AANLkTikLveTej7m7UkT6thCxD_nWbEFbF6q=ayGSj2oT@mail.gmail.com>
Subject: [PATCH] x86: fix setup NMI_LOCAL_APIC watchdog
From: Hillf Danton <dhillf@gmail.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when testing NMI watchdog, at leat for NMI_LOCAL_APIC, the default
value of nmi_active could prevent the dog from being tested. Even
could not, lapic_adjust_nmi_hz() could misplay its role since the
underlying hardware is still not initialized by lapic_watchdog_init().

And for same reason the check for wd_ops could be removed in
enable_lapic_nmi_watchdog(), in which nmi_active is also checked.

If NMI_LOCAL_APIC is enabled thru sysctl on cmdline after bootup, how
to test stuckup?

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/arch/x86/kernel/apic/nmi.c	2011-01-05 08:50:20.000000000 +0800
+++ b/arch/x86/kernel/apic/nmi.c	2011-02-03 22:51:42.000000000 +0800
@@ -171,7 +171,7 @@ int __init check_nmi_watchdog(void)
 	 * something more reasonable; makes a difference in some configs
 	 */
 	if (nmi_watchdog == NMI_LOCAL_APIC)
-		nmi_hz = lapic_adjust_nmi_hz(1);
+		nmi_hz = 1;

 	kfree(prev_nmi_count);
 	return 0;
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c	2011-01-05 08:50:20.000000000 +0800
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c	2011-02-03 22:48:44.000000000 +0800
@@ -196,14 +196,6 @@ void enable_lapic_nmi_watchdog(void)
 	if (atomic_read(&nmi_active) != 0)
 		return;

-	/* are we lapic aware */
-	if (!wd_ops)
-		return;
-	if (!wd_ops->reserve()) {
-		printk(KERN_ERR "NMI watchdog: cannot reserve perfctrs\n");
-		return;
-	}
-
 	on_each_cpu(setup_apic_nmi_watchdog, NULL, 1);
 	touch_nmi_watchdog();
 }
