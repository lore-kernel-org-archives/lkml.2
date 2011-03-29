Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1C2Ifi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1C2Ifh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:35:37 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] x86, microcode: unregister syscore_ops after microcode unloaded
Date: Tue, 29 Mar 2011 16:34:32 +0800
Message-Id: <1301387672-23661-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, microcode doesn't unregister syscore_ops after it's unloaded.
So if we modprobe then rmmod microcode, the stale microcode syscore_ops info
will stay on syscore_ops_list. Later when we're trying to reboot/halt/shutdown
the machine, kernel will panic on syscore_shutdown(). With the patch
applied, I can reboot/halt/shutdown my machine successfully.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk> 
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/microcode_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 5ed0ab5..f924280 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -550,6 +550,7 @@ static void __exit microcode_exit(void)
 	microcode_dev_exit();
 
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
+	unregister_syscore_ops(&mc_syscore_ops);
 
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
-- 
1.7.1

