Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2JAGmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:42:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50563 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2JAGmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:42:54 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH] Prevent AMD MCE oops on multi-server system
Date: Mon,  1 Oct 2012 14:42:05 +0800
Message-Id: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting on a federated multi-server system, the processor Northbridge
lookup returns NULL; add guards to prevent this causing an oops.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index c4e916d..698b6ec 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -576,12 +576,10 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int err = 0;
 
 	if (shared_bank[bank]) {
-
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
-		WARN_ON(!nb);
 
 		/* threshold descriptor already initialized on this node? */
-		if (nb->bank4) {
+		if (nb && nb->bank4) {
 			/* yes, use it */
 			b = nb->bank4;
 			err = kobject_add(b->kobj, &dev->kobj, name);
@@ -615,8 +613,10 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		atomic_set(&b->cpus, 1);
 
 		/* nb is already initialized, see above */
-		WARN_ON(nb->bank4);
-		nb->bank4 = b;
+		if (nb) {
+			WARN_ON(nb->bank4);
+			nb->bank4 = b;
+		}
 	}
 
 	err = allocate_threshold_blocks(cpu, bank, 0,
-- 
1.7.9.5

