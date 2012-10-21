Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2JUSQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:16:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2JUSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:16:49 -0400
Date: Sun, 21 Oct 2012 11:16:35 -0700
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-124556ec1555b89af76cec3e41375b6f9a557ead@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, borislav.petkov@amd.com, daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, daniel@numascale-asia.com, borislav.petkov@amd.com
In-Reply-To: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com>
References: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD, MCE:
  Prevent oops on multi-server system
Git-Commit-ID: 124556ec1555b89af76cec3e41375b6f9a557ead
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 11:16:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  124556ec1555b89af76cec3e41375b6f9a557ead
Gitweb:     http://git.kernel.org/tip/124556ec1555b89af76cec3e41375b6f9a557ead
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Mon, 1 Oct 2012 14:42:05 +0800
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Tue, 9 Oct 2012 14:48:43 +0200

x86, AMD, MCE: Prevent oops on multi-server system

When booting on a federated multi-server system (NumaScale), the
processor Northbridge lookup returns NULL; add guards to prevent this
causing an oops.

On those systems, the northbridge is accessed through MMIO and the
"normal" northbridge enumeration in amd_nb.c doesn't work since we're
generating the northbridge ID from the initial APIC ID and the last
is not unique on those systems. Long story short, we end up without
northbridge descriptors.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Cc: stable@vger.kernel.org # 3.6
Link: http://lkml.kernel.org/r/1349073725-14093-1-git-send-email-daniel@numascale-asia.com
[ Boris: beef up commit message ]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

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
