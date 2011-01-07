Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1AGPea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:34:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:40727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab1AGPe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:34:29 -0500
Date: Fri, 7 Jan 2011 15:34:03 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, rja@sgi.com, minyard@acm.org,
        tglx@linutronix.de, dannf@hp.com, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rja@sgi.com, minyard@acm.org,
        tglx@linutronix.de, dannf@hp.com, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1294348732-15030-3-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Convert some devices to use DIE_NMIUNKNOWN
Message-ID: <tip-673a6092ce5f5bec45619b7a7f89cfcf8bcf3c41@git.kernel.org>
Git-Commit-ID: 673a6092ce5f5bec45619b7a7f89cfcf8bcf3c41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:34:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  673a6092ce5f5bec45619b7a7f89cfcf8bcf3c41
Gitweb:     http://git.kernel.org/tip/673a6092ce5f5bec45619b7a7f89cfcf8bcf3c41
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 6 Jan 2011 16:18:48 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:08:52 +0100

x86: Convert some devices to use DIE_NMIUNKNOWN

They are a handful of places in the code that register a die_notifier
as a catch all in case no claims the NMI.  Unfortunately, they trigger
on events like DIE_NMI and DIE_NMI_IPI, which depending on when they
registered may collide with other handlers that have the ability to
determine if the NMI is theirs or not.

The function unknown_nmi_error() makes one last effort to walk the
die_chain when no one else has claimed the NMI before spitting out
messages that the NMI is unknown.

This is a better spot for these devices to execute any code without
colliding with the other handlers.

The two drivers modified are only compiled on x86 arches I believe, so
they shouldn't be affected by other arches that may not have
DIE_NMIUNKNOWN defined.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net
Cc: dann frazier <dannf@hp.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294348732-15030-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c  |    2 +-
 drivers/watchdog/hpwdt.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c1c52c3..927902d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -639,7 +639,7 @@ void __cpuinit uv_cpu_init(void)
  */
 int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
-	if (reason != DIE_NMI_IPI)
+	if (reason != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	if (in_crash_kexec)
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index f4d334f..320668f 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1081,7 +1081,7 @@ ipmi_nmi(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct die_args *args = data;
 
-	if (val != DIE_NMI)
+	if (val != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	/* Hack, if it's a memory or I/O error, ignore it. */
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index dea7b5b..24b966d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -469,7 +469,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+	if (ulReason != DIE_NMIUNKNOWN)
 		goto out;
 
 	if (!hpwdt_nmi_decoding)
