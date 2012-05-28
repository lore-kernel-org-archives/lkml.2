Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2E1DaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:30:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52208 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071Ab2E1D3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:42 -0400
Message-Id: <20120528031216.518927759@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andi Kleen <andi@firstfloor.org>,
        Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [ 099/117] MCE: Fix vm86 handling for 32bit mce handler
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit a129a7c84582629741e5fa6f40026efcd7a65bd4 upstream.

When running on 32bit the mce handler could misinterpret
vm86 mode as ring 0. This can affect whether it does recovery
or not; it was possible to panic when recovery was actually
possible.

Fix this by always forcing vm86 to look like ring 3.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 66e1c51..5f793e6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -437,6 +437,14 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
 		if (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV)) {
 			m->ip = regs->ip;
 			m->cs = regs->cs;
+
+			/*
+			 * When in VM86 mode make the cs look like ring 3
+			 * always. This is a lie, but it's better than passing
+			 * the additional vm86 bit around everywhere.
+			 */
+			if (v8086_mode(regs))
+				m->cs |= 3;
 		}
 		/* Use accurate RIP reporting if available. */
 		if (rip_msr)


