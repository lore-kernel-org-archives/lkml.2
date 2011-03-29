Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1C2JRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:17:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:41415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab1C2JRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:17:35 -0400
Date: Tue, 29 Mar 2011 09:17:07 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, rjw@sisk.pl,
        dfeng@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, dfeng@redhat.com,
        rjw@sisk.pl, mingo@elte.hu
In-Reply-To: <1301387672-23661-1-git-send-email-dfeng@redhat.com>
References: <1301387672-23661-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode: Unregister syscore_ops after microcode unloaded
Message-ID: <tip-4ac5fc6a3e4d90120f292526bcaa5ee182a7411b@git.kernel.org>
Git-Commit-ID: 4ac5fc6a3e4d90120f292526bcaa5ee182a7411b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Mar 2011 09:17:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ac5fc6a3e4d90120f292526bcaa5ee182a7411b
Gitweb:     http://git.kernel.org/tip/4ac5fc6a3e4d90120f292526bcaa5ee182a7411b
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Tue, 29 Mar 2011 16:34:32 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 29 Mar 2011 11:12:04 +0200

x86, microcode: Unregister syscore_ops after microcode unloaded

Currently, microcode doesn't unregister syscore_ops after it's
unloaded. So if we modprobe then rmmod microcode, the stale
microcode syscore_ops info will stay on syscore_ops_list.

Later when we're trying to reboot/halt/shutdown the machine, kernel
will panic on syscore_shutdown().

With the patch applied, I can reboot/halt/shutdown my machine successfully.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1301387672-23661-1-git-send-email-dfeng@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
