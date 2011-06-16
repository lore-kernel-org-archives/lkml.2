Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1FPHW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:22:27 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56006 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab1FPHKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:24 -0400
X-Sasl-enc: M6H78k8kaSBIoQt2kbnismKx0ZJsaAcHMJC5YthyspZn 1308208223
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:05 2011
Message-Id: <20110616002905.470254478@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [17/85] x86, amd: Use _safe() msr access for GartTlbWlk disable code
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "Roedel, Joerg" <Joerg.Roedel@amd.com>

commit d47cc0db8fd6011de2248df505fc34990b7451bf upstream.

The workaround for Bugzilla:

	https://bugzilla.kernel.org/show_bug.cgi?id=33012

introduced a read and a write to the MC4 mask msr.

Unfortunatly this MSR is not emulated by the KVM hypervisor
so that the kernel will get a #GP and crashes when applying
this workaround when running inside KVM.

This issue was reported as:

	https://bugzilla.kernel.org/show_bug.cgi?id=35132

and is fixed with this patch. The change just let the kernel
ignore any #GP it gets while accessing this MSR by using the
_safe msr access methods.

Reported-by: Török Edwin <edwintorok@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -585,10 +585,13 @@ static void __cpuinit init_amd(struct cp
 		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 		 */
 		u64 mask;
+		int err;
 
-		rdmsrl(MSR_AMD64_MCx_MASK(4), mask);
-		mask |= (1 << 10);
-		wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		err = rdmsrl_safe(MSR_AMD64_MCx_MASK(4), &mask);
+		if (err == 0) {
+			mask |= (1 << 10);
+			checking_wrmsrl(MSR_AMD64_MCx_MASK(4), mask);
+		}
 	}
 }
 


