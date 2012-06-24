Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab2FXDNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 23:13:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab2FXDNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 23:13:22 -0400
Date: Sat, 23 Jun 2012 20:13:07 -0700
From: "tip-bot for H.J. Lu" <hjl.tools@gmail.com>
Message-ID: <tip-d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86-64, gcc: Use -mpreferred-stack-boundary=
 3 if supported
Git-Commit-ID: d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 23 Jun 2012 20:13:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27
Gitweb:     http://git.kernel.org/tip/d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27
Author:     H.J. Lu <hjl.tools@gmail.com>
AuthorDate: Tue, 29 May 2012 14:31:23 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 23 Jun 2012 19:25:22 -0700

x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported

On x86-64, the standard ABI requires alignment to 16 bytes.  However,
this is not actually necessary in the kernel (we don't do SSE except
in very controlled ways); and furthermore, the standard kernel entry
on x86-64 actually leaves the stack on an odd 8-byte boundary, which
means that gcc will generate extra instructions to keep the stack
*mis*aligned!

gcc 4.8 adds an -mpreferred-stack-boundary=3 option to override this
and lets us save some stack space and a handful of instructions.

Note that this causes us to pass -mno-sse twice; this is redundant,
but necessary since the cc-option test will fail unless -mno-sse is
passed on the same command line.

[ hpa: rewrote the patch description ]

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1f25214..b0c5276 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -49,6 +49,9 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
+	# Use -mpreferred-stack-boundary=3 if supported.
+	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
+
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
         cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
