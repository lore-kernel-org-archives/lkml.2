Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0GURWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:22:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:7484 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751537Ab0GURV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:21:57 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X430-02-2Z6-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
Date: Wed, 21 Jul 2010 19:03:57 +0200
Message-ID: <1279731838-1522-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xsave is broken for (!HAVE_HWFP). This is the case if config
MATH_EMULATION is enabled, 'no387' kernel parameter is set and xsave
exists. xsave will not work because x86/math-emu and xsave share the
same memory. As this case can be treated as corner case we simply
disable xsave then.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/i387.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e73c54e..ff81143 100644
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
-- 
1.7.1.1


