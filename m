Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769216Ab2K3T1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:27:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993456Ab2K3T1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:27:00 -0500
Date: Fri, 30 Nov 2012 11:26:47 -0800
From: tip-bot for Vincent Palatin <vpalatin@chromium.org>
Message-ID: <tip-c9370d1039848a813a63c3fd44b6e4833a78246a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        olofj@chromium.org, dlaurie@chromium.org, vpalatin@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olofj@chromium.org, vpalatin@chromium.org, dlaurie@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
References: <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, fpu: Avoid FPU lazy restore after suspend
Git-Commit-ID: c9370d1039848a813a63c3fd44b6e4833a78246a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 11:26:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9370d1039848a813a63c3fd44b6e4833a78246a
Gitweb:     http://git.kernel.org/tip/c9370d1039848a813a63c3fd44b6e4833a78246a
Author:     Vincent Palatin <vpalatin@chromium.org>
AuthorDate: Fri, 30 Nov 2012 10:52:03 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Nov 2012 10:58:14 -0800

x86, fpu: Avoid FPU lazy restore after suspend

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
Link: http://lkml.kernel.org/r/1354301523-5252-2-git-send-email-vpalatin@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c | 5 +++++
 1 file changed, 5 insertions(+)

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
 
