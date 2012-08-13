Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2HMUVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2HMUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Cross <ccross@android.com>, Barry Song <bs14@csr.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Ido Yariv <ido@wizery.com>,
        Daniel Drake <dsd@laptop.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 22/82] ARM: 7477/1: vfp: Always save VFP state in vfp_pm_suspend on UP
Date: Mon, 13 Aug 2012 13:18:58 -0700
Message-Id: <20120813201748.383804581@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 24b35521b8ddf088531258f06f681bb7b227bf47 upstream.

vfp_pm_suspend should save the VFP state in suspend after
any lazy context switch.  If it only saves when the VFP is enabled,
the state can get lost when, on a UP system:
  Thread 1 uses the VFP
  Context switch occurs to thread 2, VFP is disabled but the
     VFP context is not saved
  Thread 2 initiates suspend
  vfp_pm_suspend is called with the VFP disabled, and the unsaved
     VFP context of Thread 1 in the registers

Modify vfp_pm_suspend to save the VFP context whenever
vfp_current_hw_state is not NULL.

Includes a fix from Ido Yariv <ido@wizery.com>, who pointed out that on
SMP systems, the state pointer can be pointing to a freed task struct if
a task exited on another cpu, fixed by using #ifndef CONFIG_SMP in the
new if clause.

Signed-off-by: Colin Cross <ccross@android.com>
Cc: Barry Song <bs14@csr.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ido Yariv <ido@wizery.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/vfp/vfpmodule.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -457,6 +457,12 @@ static int vfp_pm_suspend(void)
 
 		/* disable, just in case */
 		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
+	} else if (vfp_current_hw_state[ti->cpu]) {
+#ifndef CONFIG_SMP
+		fmxr(FPEXC, fpexc | FPEXC_EN);
+		vfp_save_state(vfp_current_hw_state[ti->cpu], fpexc);
+		fmxr(FPEXC, fpexc);
+#endif
 	}
 
 	/* clear any information we had about last context state */


