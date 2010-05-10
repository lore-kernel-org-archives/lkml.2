Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0EJXQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:16:36 -0400
Received: from kroah.org ([198.145.64.141]:51764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885Ab0EJW6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:02 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.466402084@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Colin Ian King <colin.king@canonical.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [45/98] x86: Disable large pages on CPUs with Atom erratum AAE44
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

commit 7a0fc404ae663776e96db43879a0fa24fec1fa3a upstream.

Atom erratum AAE44/AAF40/AAG38/AAH41:

"If software clears the PS (page size) bit in a present PDE (page
directory entry), that will cause linear addresses mapped through this
PDE to use 4-KByte pages instead of using a large page after old TLB
entries are invalidated. Due to this erratum, if a code fetch uses
this PDE before the TLB entry for the large page is invalidated then
it may fetch from a different physical address than specified by
either the old large page translation or the new 4-KByte page
translation. This erratum may also cause speculative code fetches from
incorrect addresses."

[http://download.intel.com/design/processor/specupdt/319536.pdf]

Where as commit 211b3d03c7400f48a781977a50104c9d12f4e229 seems to
workaround errata AAH41 (mixed 4K TLBs) it reduces the window of
opportunity for the bug to occur and does not totally remove it.  This
patch disables mixed 4K/4MB page tables totally avoiding the page
splitting and not tripping this processor issue.

This is based on an original patch by Colin King.

Originally-by: Colin Ian King <colin.king@canonical.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -47,6 +47,27 @@ static void __cpuinit early_init_intel(s
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
+	/*
+	 * Atom erratum AAE44/AAF40/AAG38/AAH41:
+	 *
+	 * A race condition between speculative fetches and invalidating
+	 * a large page.  This is worked around in microcode, but we
+	 * need the microcode to have already been loaded... so if it is
+	 * not, recommend a BIOS update and disable large pages.
+	 */
+	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
+		u32 ucode, junk;
+
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		sync_core();
+		rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
+
+		if (ucode < 0x20e) {
+			printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
+			clear_cpu_cap(c, X86_FEATURE_PSE);
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
 #else


