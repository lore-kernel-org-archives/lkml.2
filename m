Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1AFVUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1AFVU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:20:29 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Russ Anderson <rja@sgi.com>,
        Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net, dann frazier <dannf@hp.com>
Subject: [PATCH 2/6] x86: Convert some devices to use DIE_NMIUNKNOWN
Date: Thu,  6 Jan 2011 16:18:48 -0500
Message-Id: <1294348732-15030-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Russ Anderson <rja@sgi.com>
CC: Corey Minyard <minyard@acm.org>
CC: openipmi-developer@lists.sourceforge.net
CC: dann frazier <dannf@hp.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c  |    2 +-
 drivers/watchdog/hpwdt.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index e6cde91..7b0d2f6 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -642,7 +642,7 @@ void __cpuinit uv_cpu_init(void)
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
-- 
1.7.3.4

