Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2JZAbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:31:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:53303 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2JZAHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 17/85] x86, amd, mce: Avoid NULL pointer reference on CPU northbridge lookup
Date: Thu, 25 Oct 2012 17:05:35 -0700
Message-Id: <20121026000032.855552613@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@numascale-asia.com>

commit 21c5e50e15b1abd797e62f18fd7f90b9cc004cbd upstream.

When booting on a federated multi-server system (NumaScale), the
processor Northbridge lookup returns NULL; add guards to prevent this
causing an oops.

On those systems, the northbridge is accessed through MMIO and the
"normal" northbridge enumeration in amd_nb.c doesn't work since we're
generating the northbridge ID from the initial APIC ID and the last
is not unique on those systems. Long story short, we end up without
northbridge descriptors.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/1349073725-14093-1-git-send-email-daniel@numascale-asia.com
[ Boris: beef up commit message ]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -576,12 +576,10 @@ static __cpuinit int threshold_create_ba
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
@@ -615,8 +613,10 @@ static __cpuinit int threshold_create_ba
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


