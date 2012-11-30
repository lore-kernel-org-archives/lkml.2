Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466Ab2K3Sw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:52:28 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:62091 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161056Ab2K3SwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:52:23 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
Date: Fri, 30 Nov 2012 10:52:03 -0800
Message-Id: <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1354301523-5252-1-git-send-email-vpalatin@chromium.org>
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu enters S3 state, the FPU state is lost.
After resuming for S3, if we try to lazy restore the FPU for a process running
on the same CPU, this will result in a corrupted FPU context.

We can just invalidate the "fpu_owner_task", so nobody will try to
lazy restore a state which no longer exists in the hardware.

Tested with a 64-bit kernel on a 4-core Ivybridge CPU with eagerfpu=off,
by doing thousands of suspend/resume cycles with 4 processes doing FPU
operations running. Without the patch, a process is killed after a
few hundreds cycles by a SIGFPE.

The issue seems to exist since 3.4 (after the FPU lazy restore was actually implemented),
to apply the change to 3.4, "this_cpu_write" needs to be replaced by percpu_write.

Cc: Duncan Laurie <dlaurie@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Cc: <stable@kernel.org> [v3.4+] # for 3.4 need to replace this_cpu_write by percpu_write
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 arch/x86/kernel/smpboot.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c80a33b..7610c58 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -68,6 +68,8 @@
 #include <asm/mwait.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
+#include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
@@ -1230,6 +1232,9 @@ int native_cpu_disable(void)
 	clear_local_APIC();
 
 	cpu_disable_common();
+
+	/* the FPU context will be lost, nobody owns it */
+	this_cpu_write(fpu_owner_task, NULL);
 	return 0;
 }
 
-- 
1.7.7.3

