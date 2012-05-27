Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946056Ab2E0BWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:22:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946028Ab2E0BVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:21:03 -0400
Message-Id: <20120527002526.105658857@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [ 89/91] MCE: Fix vm86 handling for 32bit mce handler
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -437,6 +437,14 @@ static inline void mce_gather_info(struc
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


