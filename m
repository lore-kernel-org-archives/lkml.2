Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945993Ab2I1VHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:07:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55281 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965267Ab2I1VGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:06:01 -0400
X-Sasl-enc: aIhJ7Cu6RR1Y0TIUnH4uGooAFplWPqUnDOMGGVty2QjE 1348866360
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [ 126/127] MCE: Fix vm86 handling for 32bit mce handler
Date: Fri, 28 Sep 2012 13:34:59 -0700
Message-Id: <20120928203100.634426528@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit a129a7c84582629741e5fa6f40026efcd7a65bd4 upstream.

When running on 32bit the mce handler could misinterpret
vm86 mode as ring 0. This can affect whether it does recovery
or not; it was possible to panic when recovery was actually
possible.

Fix this by always forcing vm86 to look like ring 3.

[ Backport to 3.0 notes:
Things changed there slightly:
   - move mce_get_rip() up. It fills up m->cs and m->ip values which
     are evaluated in mce_severity(). Therefore move it up right before
     the mce_severity call. This seem to be another bug in 3.0?
   - Place the backport (fix m->cs in V86 case) to where m->cs gets
     filled which is mce_get_rip() in 3.0
]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -451,6 +451,13 @@ static inline void mce_get_rip(struct mc
 	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV|MCG_STATUS_EIPV))) {
 		m->ip = regs->ip;
 		m->cs = regs->cs;
+		/*
+		 * When in VM86 mode make the cs look like ring 3
+		 * always. This is a lie, but it's better than passing
+		 * the additional vm86 bit around everywhere.
+		 */
+		if (v8086_mode(regs))
+			m->cs |= 3;
 	} else {
 		m->ip = 0;
 		m->cs = 0;
@@ -988,6 +995,7 @@ void do_machine_check(struct pt_regs *re
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
+		mce_get_rip(&m, regs);
 		severity = mce_severity(&m, tolerant, NULL);
 
 		/*
@@ -1026,7 +1034,6 @@ void do_machine_check(struct pt_regs *re
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_get_rip(&m, regs);
 		mce_log(&m);
 
 		if (severity > worst) {


