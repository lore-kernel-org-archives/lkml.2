Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab0HLWHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:07:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53915 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0HLWHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:07:05 -0400
Date: Thu, 12 Aug 2010 22:06:45 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1279731838-1522-7-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-7-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, xsave: Disable xsave in i387 emulation mode
Message-ID: <tip-1f999ab5a1360afc388868cc0ef9afe8edeef3be@git.kernel.org>
Git-Commit-ID: 1f999ab5a1360afc388868cc0ef9afe8edeef3be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 22:06:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f999ab5a1360afc388868cc0ef9afe8edeef3be
Gitweb:     http://git.kernel.org/tip/1f999ab5a1360afc388868cc0ef9afe8edeef3be
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:57 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 12 Aug 2010 14:16:54 -0700

x86, xsave: Disable xsave in i387 emulation mode

xsave is broken for (!HAVE_HWFP). This is the case if config
MATH_EMULATION is enabled, 'no387' kernel parameter is set and xsave
exists. xsave will not work because x86/math-emu and xsave share the
same memory. As this case can be treated as corner case we simply
disable xsave then.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-7-git-send-email-robert.richter@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/i387.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 1f11f5c..2605c50 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -67,6 +67,12 @@ static void __cpuinit init_thread_xstate(void)
 	 */
 
 	if (!HAVE_HWFP) {
+		/*
+		 * Disable xsave as we do not support it if i387
+		 * emulation is enabled.
+		 */
+		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+		setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 		xstate_size = sizeof(struct i387_soft_struct);
 		return;
 	}
