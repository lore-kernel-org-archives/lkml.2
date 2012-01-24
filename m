Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab2AXCto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:49:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996Ab2AXCti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:49:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.668116344@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
        Bruno Friedmann <bruno@ioda-net.ch>, Len Brown <len.brown@intel.com>
Subject: [098/129] intel idle: Make idle driver more robust
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1651
Lines: 47

From: Thomas Renninger <trenn@suse.de>

commit 5c2a9f06a9cd7194f884cdc88144866235dec07d upstream.

kvm -cpu host passes the original cpuid info to the guest.

Latest kvm version seem to return true for mwait_leaf cpuid
function on recent Intel CPUs. But it does not return mwait
C-states (mwait_substates), instead zero is returned.

While real CPUs seem to always return non-zero values, the intel
idle driver should not get active in kvm (mwait_substates == 0)
case and bail out.
Otherwise a Null pointer exception will happen later when the
cpuidle subsystem tries to get active:
[0.984807] BUG: unable to handle kernel NULL pointer dereference at (null)
[0.984807] IP: [<(null)>] (null)
...
[0.984807][<ffffffff8143cf34>] ? cpuidle_idle_call+0xb4/0x340
[0.984807][<ffffffff8159e7bc>] ? __atomic_notifier_call_chain+0x4c/0x70
[0.984807][<ffffffff81001198>] ? cpu_idle+0x78/0xd0

Reference:
https://bugzilla.novell.com/show_bug.cgi?id=726296

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Bruno Friedmann <bruno@ioda-net.ch>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/idle/intel_idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -348,7 +348,8 @@ static int intel_idle_probe(void)
 	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &mwait_substates);
 
 	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
-		!(ecx & CPUID5_ECX_INTERRUPT_BREAK))
+	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK) ||
+	    !mwait_substates)
 			return -ENODEV;
 
 	pr_debug(PREFIX "MWAIT substates: 0x%x\n", mwait_substates);


