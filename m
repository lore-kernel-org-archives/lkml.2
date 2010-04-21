Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0DUABT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:01:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:54412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab0DUABO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:01:14 -0400
Date: Wed, 21 Apr 2010 00:00:51 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1271701423-1162-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1271701423-1162-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mrst: Conditionally register cpu hotplug notifier for apbt
Message-ID: <tip-ae7c9b70dcb4313ea3dbcc9a2f240dae6c2b50c0@git.kernel.org>
Git-Commit-ID: ae7c9b70dcb4313ea3dbcc9a2f240dae6c2b50c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Apr 2010 00:00:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae7c9b70dcb4313ea3dbcc9a2f240dae6c2b50c0
Gitweb:     http://git.kernel.org/tip/ae7c9b70dcb4313ea3dbcc9a2f240dae6c2b50c0
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Mon, 19 Apr 2010 11:23:43 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 20 Apr 2010 14:38:28 -0700

x86, mrst: Conditionally register cpu hotplug notifier for apbt

APB timer is used on Moorestown platforms but not on a standard PC.
If APB timer code is compiled in but not initialized at run-time due
to lack of FW reported SFI table, kernel would panic when the non-boot
CPUs are offlined and notifier is called.

https://bugzilla.kernel.org/show_bug.cgi?id=15786

This patch ensures CPU hotplug notifier for APB timer is only registered
when the APBT timer block is initialized.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1271701423-1162-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apb_timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index ff469e4..a353475 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -429,7 +429,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 
 static __init int apbt_late_init(void)
 {
-	if (disable_apbt_percpu)
+	if (disable_apbt_percpu || !apb_timer_block_enabled)
 		return 0;
 	/* This notifier should be called after workqueue is ready */
 	hotcpu_notifier(apbt_cpuhp_notify, -20);
